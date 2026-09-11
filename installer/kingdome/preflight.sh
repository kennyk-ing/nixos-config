#!/usr/bin/env bash
set -uo pipefail

TARGET_PATH="/dev/disk/by-path/pci-0000:00:17.0-ata-5"

LAN_PCI="0000:01:00.0"
WAN_PCI="0000:01:00.1"
NIC_ID="8086:10c9"

errors=0

ok() {
  printf 'OK:   %s\n' "$*"
}

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  ((errors += 1))
}

section() {
  printf '\n== %s ==\n' "$*"
}

if ((EUID != 0)); then
  echo "Run this preflight with sudo." >&2
  exit 1
fi

section "Boot mode"

if [[ -d /sys/firmware/efi/efivars ]]; then
  ok "Booted in UEFI mode"
else
  fail "System is not booted in UEFI mode"
fi

section "Target disk"

target=""

if [[ -e "$TARGET_PATH" ]]; then
  target="$(readlink -f "$TARGET_PATH")"
  ok "$TARGET_PATH -> $target"

  if [[ -b "$target" ]]; then
    lsblk -dn -o NAME,SIZE,MODEL,SERIAL,TYPE "$target"

    if [[ "$(lsblk -dn -o TYPE "$target")" == "disk" ]]; then
      ok "Target is a whole-disk block device"
    else
      fail "Target is not a whole-disk block device"
    fi
  else
    fail "Target does not resolve to a block device"
  fi
else
  fail "Target path does not exist: $TARGET_PATH"
fi

section "Passthrough NICs"

check_nic() {
  local label="$1"
  local pci="$2"
  local device="/sys/bus/pci/devices/$pci"
  local pci_line
  local -a net_paths

  if [[ ! -e "$device" ]]; then
    fail "$label PCI device $pci does not exist"
    return
  fi

  pci_line="$(lspci -nn -s "$pci")"
  printf '      %s\n' "$pci_line"

  if grep -qi "$NIC_ID" <<<"$pci_line"; then
    ok "$label is Intel 82576 [$NIC_ID]"
  else
    fail "$label at $pci does not have expected PCI ID $NIC_ID"
  fi

  if [[ -e "$device/iommu_group" ]]; then
    ok "$label has an IOMMU group"
  else
    fail "$label has no IOMMU group"
  fi

  net_paths=("$device"/net/*)

  if [[ -e "${net_paths[0]:-}" ]]; then
    printf '      MAC: %s\n' "$(cat "${net_paths[0]}/address")"
  fi
}

check_nic "LAN" "$LAN_PCI"
check_nic "WAN" "$WAN_PCI"

section "Recovery payload"

if [[ -f /etc/nixos-config/flake.nix ]]; then
  ok "Embedded NixOS flake is present"
else
  fail "/etc/nixos-config/flake.nix is missing"
fi

if [[ -s /etc/install-closure ]]; then
  ok "Offline closure manifest is present"
else
  fail "/etc/install-closure is missing or empty"
fi

if [[ -x /etc/kingdome-recovery/install.sh ]]; then
  ok "Install script is present"
else
  fail "/etc/kingdome-recovery/install.sh is missing or not executable"
fi

if [[ -f /etc/kingdome-recovery/hodor.xml ]]; then
  ok "hodor domain definition is present"
else
  fail "/etc/kingdome-recovery/hodor.xml is missing"
fi

if [[ -f /etc/nixos-config/flake.nix ]]; then
  printf '      Evaluating kingdome offline...\n'

  if nix \
    --extra-experimental-features 'nix-command flakes' \
    eval \
    --offline \
    --raw \
    /etc/nixos-config#nixosConfigurations.kingdome.config.system.build.toplevel.drvPath \
    >/dev/null; then
    ok "Embedded kingdome configuration evaluates offline"
  else
    fail "Embedded kingdome configuration does not evaluate offline"
  fi
fi

section "Result"

if ((errors > 0)); then
  printf '\nPREFLIGHT FAILED: %d error(s).\n' "$errors" >&2
  printf 'Do not run the destructive installer.\n' >&2
  exit 1
fi

printf '\nPREFLIGHT PASSED.\n'
printf 'No disks were modified.\n'
