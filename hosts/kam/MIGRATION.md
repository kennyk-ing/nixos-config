# Kam migration preparation

Kam inherits Kirby's server role on the Dell Inspiron 3511 currently running
Woo. The new configuration retains systemd-networkd, Plasma, Kenny's lingering
user session, SMART/Gotify monitoring, lid-close behavior and disabled sleep.
It is for review, not ready for installation or activation.

- Hardware scan: copied from Woo's chassis (identical to Kirby's current scan).
  Verify the real disk and adapters before installation. Storage keeps GPT,
  1 GiB EFI, explicit LUKS2, Btrfs root/home/nix/swap and a 4 GiB swapfile.
  `/dev/nvme0n1` must be confirmed; no disk operations have been performed.
  Zram remains 10% of detected RAM, nominally 6.4 GiB at the eventual 64 GiB.
- NetworkManager remains disabled. `networking.nix` stages VLAN 100 with IPv4
  DHCP, but leaves `parentMAC = null` and disables the VLAN configuration until
  the intended adapter's permanent MAC is confirmed. Kirby's 9c:69:d3:81:48:ea
  must not be assumed to move with the role: determine whether the USB adapter
  moves too. The shared laptop module retains its existing ASIX USB-ID power
  workaround; confirm the actual adapter model. Confirm switch tagging, DHCP,
  routing, DNS and management access before deployment. This configuration has
  no provisioned management uplink yet. Existing DNS/services remain untouched.
- Use ordinary systemd-boot initially; Secure Boot must not be required by
  firmware for that unsigned boot path. This chassis has no established trust
  for the backed-up signing keys. Before enabling Secure Boot, choose the signing
  identity, securely provision its bundle, review/enroll its public certificates
  into this chassis's firmware trust database, and verify signed boot artifacts.
  Do not assume Earl's firmware enrollment applies to Kam. Then switch from the
  shared systemd-boot module to secure-boot/Lanzaboote in a subsequent change.
- Measured boot and TPM unlocking are deferred here. Do not copy Kirby's PCR 4
  digest: it belongs to Earl's physical chassis. Inspect Kam's own TPM event log,
  prepare its measured-boot policy, and enroll its new LUKS2 volume separately
  if TPM unlocking is desired. Keep recovery/passphrase access.
- Provision fresh SSH host keys later; agenix uses the local ed25519 host key.
  `kenny-password` and `gotify-token` ciphertexts are retained as dependencies,
  but Kam needs new public recipients and rekeying before decryption will work.
  No secrets or recipient files have been changed in this stage.
- Syncthing stays disabled until a fresh identity is provisioned and peer/folder
  sharing reviewed. Do not copy existing Syncthing certificates/state or invent
  device IDs. Shared peer definitions remain unchanged; do not repoint Kirby's
  peers or DNS prematurely. No WireGuard client was inherited from Kirby.

Use a `path:` flake reference for validation of unstaged files and `--no-link
--no-write-lock-file` for builds. Build success cannot validate firmware, TPM,
secret decryption or live network connectivity. Prepare nixos-anywhere later;
do not format, install, reboot, deploy or activate this configuration now.
