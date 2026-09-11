#!/usr/bin/env bash
set -euo pipefail

TARGET="/dev/disk/by-path/pci-0000:00:17.0-ata-5"
FLAKE="/etc/nixos-config#kingdome"

RECOVERY_MOUNT="/mnt/recovery-usb"
KEY_DIR="$RECOVERY_MOUNT/hosts/kingdome"
PRIVATE_KEY="$KEY_DIR/ssh_host_ed25519_key"
PUBLIC_KEY="$KEY_DIR/ssh_host_ed25519_key.pub"

STAGE="/run/kingdome-install"
STAGED_PRIVATE="$STAGE/etc/ssh/ssh_host_ed25519_key"
STAGED_PUBLIC="$STAGE/etc/ssh/ssh_host_ed25519_key.pub"

OPNSENSE_DEST="/var/lib/libvirt/images/installers/opnsense-installer.iso"

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

cleanup() {
  rm -rf "$STAGE"
}

trap cleanup EXIT

if ((EUID != 0)); then
  die "Run this installer with sudo."
fi

if (($# != 1)); then
  cat >&2 <<EOF
Usage:
  sudo $0 /path/to/OPNsense-dvd-amd64.iso
EOF
  exit 2
fi

OPNSENSE_ISO="$1"

[[ -f "$OPNSENSE_ISO" ]] ||
  die "OPNsense ISO does not exist: $OPNSENSE_ISO"

[[ -r "$OPNSENSE_ISO" ]] ||
  die "OPNsense ISO is not readable: $OPNSENSE_ISO"

OPNSENSE_ISO="$(readlink -f -- "$OPNSENSE_ISO")"

case "$(basename "$OPNSENSE_ISO")" in
OPNsense-*-dvd-amd64.iso)
  ;;
*)
  die "File does not look like an OPNsense DVD amd64 ISO: $OPNSENSE_ISO"
  ;;
esac

printf '\n== Preflight ==\n'
/etc/kingdome-recovery/preflight.sh

printf '\n== Recovery identity ==\n'

mountpoint -q "$RECOVERY_MOUNT" ||
  die "$RECOVERY_MOUNT is not mounted"

recovery_options="$(
  findmnt -n -o OPTIONS --target "$RECOVERY_MOUNT"
)"

if [[ ",$recovery_options," != *,ro,* ]]; then
  die "$RECOVERY_MOUNT is not mounted read-only"
fi

[[ -f "$PRIVATE_KEY" ]] ||
  die "Missing private key: $PRIVATE_KEY"

[[ -f "$PUBLIC_KEY" ]] ||
  die "Missing public key: $PUBLIC_KEY"

rm -rf "$STAGE"

install -d -o root -g root -m 0700 "$STAGE/etc/ssh"
install -o root -g root -m 0600 "$PRIVATE_KEY" "$STAGED_PRIVATE"
install -o root -g root -m 0644 "$PUBLIC_KEY" "$STAGED_PUBLIC"

derived_public="$(ssh-keygen -y -f "$STAGED_PRIVATE")"
stored_public="$(
  awk 'NF >= 2 { print $1 " " $2; exit }' "$STAGED_PUBLIC"
)"

if [[ "$derived_public" != "$stored_public" ]]; then
  die "Private and public SSH host keys do not match"
fi

printf 'SSH host key pair verified.\n'

printf '\n== OPNsense installer ==\n'
printf 'Source: %s\n' "$OPNSENSE_ISO"
printf 'Target: %s\n' "$OPNSENSE_DEST"

printf '\n== Destructive install ==\n'

resolved_target="$(readlink -f "$TARGET")"

[[ -b "$resolved_target" ]] ||
  die "Target does not resolve to a block device: $TARGET"

printf 'The following disk will be erased:\n\n'

lsblk \
  -o NAME,SIZE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS \
  "$resolved_target"

printf '\n'

read -r -p 'Continue with the kingdome installation? [y/N] ' confirmation

case "$confirmation" in
[yY] | [yY][eE][sS])
  ;;
*)
  printf 'Installation cancelled.\n'
  exit 0
  ;;
esac

printf '\nStarting Disko installation...\n\n'

disko-install \
  --write-efi-boot-entries \
  --option offline true \
  --flake "$FLAKE" \
  --disk main "$TARGET" \
  --extra-files "$STAGED_PRIVATE" /etc/ssh/ssh_host_ed25519_key \
  --extra-files "$STAGED_PUBLIC" /etc/ssh/ssh_host_ed25519_key.pub \
  --extra-files "$OPNSENSE_ISO" "$OPNSENSE_DEST"

printf '\n========================================\n'
printf 'KINGDOME INSTALLATION COMPLETED\n'
printf '========================================\n\n'
printf 'The OPNsense installer was copied to:\n'
printf '  %s\n\n' "$OPNSENSE_DEST"
printf 'Unmount/lock the recovery media and Ventoy before rebooting.\n'
