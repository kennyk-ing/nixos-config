# Kingdome Recovery

Offline procedure for rebuilding `kingdome` as native NixOS and restoring the
`hodor` OPNsense VM.

Use an installer ISO built from the current repository.

## Assumptions

System disk:

```text
/dev/disk/by-path/pci-0000:00:17.0-ata-5
```

The disk model may change, but this physical SATA path is the installation
target. If the system disk is moved to another SATA port, update the
configuration and rebuild the installer ISO first.

Network:

```text
kingdome onboard:
  10.0.10.2/24

hodor LAN:
  PCI 0000:01:00.0
  10.0.10.1/24

hodor WAN:
  PCI 0000:01:00.1
  DHCP
```

---

## 1. Prepare for the outage

Before shutdown:

```text
kingdome onboard → LAN switch
hodor LAN        → LAN switch
kirby            → LAN switch

hodor WAN        → disconnected from ONT
```

Shut down OPNsense cleanly, then shut down kingdome.

Keep hodor WAN disconnected until its LAN configuration is working.

---

## 2. Boot and verify the installer

Boot the current kingdome installer ISO from Ventoy in UEFI mode.

Verify the recovery payload:

```bash
ls -l /etc/kingdome-recovery
```

Expected:

```text
preflight.sh
install.sh
hodor.xml
README.md
```

Run:

```bash
sudo /etc/kingdome-recovery/preflight.sh
```

Expected:

```text
PREFLIGHT PASSED.
No disks were modified.
```

Do not continue if preflight fails.

---

## 3. Mount the recovery USB

Find the encrypted recovery USB:

```bash
lsblk -o NAME,PATH,SIZE,MODEL,FSTYPE,LABEL,MOUNTPOINTS
```

Unlock it:

```bash
sudo cryptsetup open /dev/<LUKS-partition> recovery-usb
```

Mount it read-only:

```bash
sudo mkdir -p /mnt/recovery-usb
sudo mount -o ro /dev/mapper/recovery-usb /mnt/recovery-usb
```

Verify the host keys:

```bash
sudo ls -l /mnt/recovery-usb/hosts/kingdome/
```

Required:

```text
ssh_host_ed25519_key
ssh_host_ed25519_key.pub
```

---

## 4. Locate the OPNsense ISO

Check whether Ventoy's data filesystem is already mounted:

```bash
lsblk -o NAME,PATH,SIZE,FSTYPE,LABEL,MOUNTPOINTS
```

If it already has a mountpoint, use it.
Last time it was at /dev/mapper/sdx#
Otherwise:

```bash
sudo mkdir -p /mnt/ventoy
sudo mount -o ro /dev/<Ventoy-data-partition> /mnt/ventoy
```

Find the ISO:

```bash
find <Ventoy-mountpoint> \
  -maxdepth 2 \
  -type f \
  -iname 'OPNsense-*-dvd-amd64.iso'
```

---

## 5. Install NixOS

Run:

```bash
sudo /etc/kingdome-recovery/install.sh \
  <full-path-to-OPNsense-ISO>
```

The installer displays the disk that will be erased.

Verify it is the intended kingdome system disk, then confirm:

```text
Continue with the kingdome installation? [y/N]
```

Expected ending:

```text
KINGDOME INSTALLATION COMPLETED
```

If installation fails, remain in the live environment and diagnose it before
rebooting.

---

## 6. Reboot into kingdome

Unmount the recovery USB:

```bash
sudo umount /mnt/recovery-usb
sudo cryptsetup close recovery-usb
```

If Ventoy was mounted manually:

```bash
sudo umount /mnt/ventoy
```

Reboot:

```bash
sudo reboot
```

Boot the internal system disk.

---

## 7. Verify kingdome

Check:

```bash
hostname
ip -br addr
ip route
systemctl is-active sshd
```

Expected:

```text
hostname: kingdome
onboard:  10.0.10.2/24
sshd:     active
```

Before hodor is running, `10.0.10.1` will not be reachable.

Verify virtualization:

```bash
test -c /dev/kvm && echo "KVM OK"
systemctl is-active libvirtd

lspci -nnk -s 01:00.0
lspci -nnk -s 01:00.1
```

Both Intel 82576 functions must be available for VFIO passthrough.

---

## 8. Connect from kirby

Bring up the temporary recovery network:

```bash
sudo nmcli connection up kingdome-recovery
```

Test:

```bash
ping -c 3 10.0.10.2
```

SSH:

```bash
TERM=xterm-256color ssh kenny@10.0.10.2
```

---

## 9. Create hodor

Verify the copied OPNsense installer:

```bash
ls -lh /var/lib/libvirt/images/installers/opnsense-installer.iso
```

Create the VM disk:

```bash
sudo qemu-img create \
  -f qcow2 \
  /var/lib/libvirt/images/hodor.qcow2 \
  40G
```

Define hodor:

```bash
sudo virsh -c qemu:///system define \
  --validate \
  /etc/kingdome-recovery/hodor.xml
```

Verify:

```bash
sudo virsh -c qemu:///system dominfo hodor
```

Expected:

```text
State: shut off
```

---

## 10. Install OPNsense

Keep WAN disconnected.

Start hodor:

```bash
sudo virsh -c qemu:///system start hodor
```

From kirby:

```bash
virt-viewer \
  --connect qemu+ssh://kenny@10.0.10.2/system \
  hodor
```

Install OPNsense to the approximately 40 GiB virtual disk.

Use:

```text
login: installer
password: opnsense

filesystem: ZFS
topology: stripe
```

Set the permanent root password during installation.

---

## 11. Configure OPNsense

Assign:

```text
LAN → PCI 0000:01:00.0
WAN → PCI 0000:01:00.1
```

Configure LAN:

```text
IPv4:    static
Address: 10.0.10.1/24
Gateway: none
IPv6:    none
```

Do not configure VLANs yet.

From kirby:

```bash
ping -c 3 10.0.10.1
```

Then open:

```text
https://10.0.10.1/
```

### DHCP and DNS

Enable Dnsmasq DHCP on LAN with:

```text
10.0.10.100 - 10.0.10.199
```

Keep Unbound enabled for DNS.

Use Unbound for port 53 rather than Dnsmasq's DNS listener.

---

## 12. Restore WAN

Configure WAN:

```text
IPv4: DHCP
IPv6: None
```

Leave automatic outbound NAT enabled.

Connect:

```text
ONT → hodor WAN
```

Verify hodor receives a WAN IPv4 address.

Test from OPNsense:

```text
1.1.1.1
opnsense.org
```

Both should succeed.

---

## 13. Return kirby to DHCP

On kirby:

```bash
sudo nmcli connection up "USB LAN"
```

Check:

```bash
ip -4 addr show dev enp0s20f0u2c2
ip route
nmcli device show enp0s20f0u2c2 | grep IP4.DNS
```

Expected:

```text
address: 10.0.10.100-199
gateway: 10.0.10.1
DNS:     10.0.10.1
```

Test:

```bash
ping -c 3 10.0.10.1
ping -c 3 1.1.1.1
getent hosts nixos.org
```

---

## 14. Finish hodor

After OPNsense boots successfully from its installed disk, eject the installer:

```bash
sudo virsh -c qemu:///system change-media \
  hodor \
  sda \
  --eject \
  --live \
  --config
```

Enable autostart:

```bash
sudo virsh -c qemu:///system autostart hodor
```

Verify:

```bash
sudo virsh -c qemu:///system dominfo hodor
```

Expected:

```text
Autostart: enable
```

---

## Complete

Recovery is complete when:

```text
kingdome = 10.0.10.2/24

hodor is running
hodor LAN = 10.0.10.1/24
hodor WAN has Internet access

kirby receives DHCP from hodor
kirby gateway = 10.0.10.1
kirby DNS = 10.0.10.1

kingdome and kirby have Internet access
DNS resolution works

hodor autostart is enabled
```

Add VLANs, VPN routing, ad blocking, IDS/IPS, Tailscale, DMZ, and the
restricted-services network only after this baseline is working.
