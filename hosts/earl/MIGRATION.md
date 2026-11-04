# Earl migration preparation

Earl inherits Woo's workstation role on the Dell Inspiron 3511 currently running
Kirby. Woo and Kirby remain independent configurations throughout preparation.
This configuration is for review, not ready for installation or activation.

- Hardware scan: copied from Kirby's chassis. Its scan is identical to Woo's,
  but verify storage enumeration, firmware, TPM availability and adapters again
  before installation. `/dev/nvme0n1` is a proposed installation target, not an
  instruction to format the currently installed disk.
- Storage: GPT, 1 GiB EFI partition, explicit LUKS2, Btrfs root/home/nix/swap
  subvolumes and 4 GiB swapfile. Zram stays at 50% of detected RAM: nominally
  32 GiB initially and 8 GiB after moving to 16 GiB. This does not configure
  hibernation; the swapfile is not sized for RAM-sized hibernation images.
- Boot: ordinary systemd-boot and a systemd initrd are used for initial
  installation. Disable Secure Boot enforcement in firmware without clearing
  enrolled keys. First boot requires local manual LUKS passphrase entry;
  initrd SSH unlocking is not configured.
- Disko reads the initial passphrase from `/run/earl-install-luks-passphrase`.
  Supply that runtime file with nixos-anywhere's `--disk-encryption-keys`
  option from protected controller-side storage. Do not put the passphrase in
  the repository, Nix store, shell arguments or the installed initrd. This is
  an installation input, not a persistent boot key file.
- NetworkManager's normal automatic wired DHCP connection is used on untagged
  Ethernet. Configure the switch port for untagged VLAN 10 and verify DHCP and
  connectivity from tez before installation. TCP port 22 is temporarily open
  for LAN administration; SSH remains key-only with root login disabled.
  Review this firewall allowance after migration.
- Secure Boot, Lanzaboote, measured boot and TPM unlocking are deferred.
  The extra PCR 4 digest belongs to the former Kirby physical chassis:
  `522944324bb55c06f770c2757d962e562d9714d6041b6ba1a93041dd4cf9a8c7`.
  Restore and revalidate its measurement when enabling measured boot later;
  do not transfer it to Kam with the server role.
- Later, restore the backed-up signing bundle to `/var/lib/sbctl` on the new filesystem
  through a separate secure provisioning process. Verify its public certificates
  match the keys already enrolled in this chassis's firmware. Do not regenerate
  signing keys or include their private material in this repository/Nix store.
- Establish and verify measured-boot/pcrlock policy, configure
  `tpm2-device=auto` and enroll the new LUKS2 volume later.
  Retain a tested passphrase/recovery route. Enrollment from the old installation
  does not transfer to a freshly formatted volume.
- Provision fresh SSH host keys later. The shared configuration uses the new
  `/etc/ssh/ssh_host_ed25519_key` for agenix. Existing ciphertexts for
  `kenny-password`, `wifi` and `email_personal` are retained as dependencies;
  add Earl's public recipient and rekey them in the next stage. No existing
  host private key should be copied. Until then decryption is not ready.
- `wireguard.nix` preserves the home VPN template behind a false guard. Allocate
  a distinct tunnel address, provision Earl's own WireGuard key/peer and encrypted
  environment file, and declare its agenix secret before enabling it. Woo keeps
  its existing key and 10.253.0.2 address; no gateway peer or DNS change is made.
- Syncthing is disabled pending a fresh identity, peer authorization, and review
  of folder sharing. The shared Home Manager module still contains existing peer
  definitions; review these before enabling. Do not copy Woo/Kirby's Syncthing
  state directory, certificates or device IDs as Earl's identity. Do not repoint
  existing peers or DNS during preparation.

Validation should use `path:/absolute/path/to/repo` flake references so that new,
unstaged host files are included without changing Git metadata. Builds must use
`--no-link --no-write-lock-file`; building does not provision secrets, restore
signing keys, enroll TPM tokens, or prove firmware trust/hardware compatibility.
Prepare nixos-anywhere separately after identities and these prerequisites are
resolved. Do not run installation, disko formatting or activation at this stage.
