# Noctalia v5 migration (tez first)

The unchanged 26.05 flake lock resolves `pkgs.noctalia` to 5.0.1. No new
inputs, overrides, secrets backend, login manager, accounts, or Plasma changes.
System capabilities stay in `modules/desktop/niri/default.nix`; Kenny's
workstation Home Manager configuration now owns the shared Niri links and
`users/kenny/files/noctalia.toml`. Noctalia starts once from Niri, never from a global
user service or XDG autostart entry. Plasma continues to use its own shell/locker.

## Settings to transfer before activation

No live home directories were available in this workspace. No existing JSON,
wallpapers, or application state were changed. V4 JSON does not migrate to v5
TOML automatically. Back up `~/.config/noctalia/` and, if present,
`~/.local/state/noctalia/` on each host before activation. Keep backups outside
those directories: v5 loads every top-level `*.toml` in its config directory.
If `~/.config/noctalia/config.toml` already exists, inspect and move it aside
before Home Manager activation; the migration deliberately does not force
replacement of an unmanaged file.

Transfer wallpaper directory, selected image(s), slideshow preferences, theme,
bar widgets, launcher pins, and other personal choices from v4 settings into
`users/kenny/files/noctalia.toml` or v5 Settings. For example, `[wallpaper].directory`
and `[wallpaper.default].path` accept personal wallpaper paths. The baseline
keeps wallpaper rendering enabled and stationary behind transparent Niri
workspaces, with v5's separate backdrop disabled. It cannot recover the old
selected wallpaper without the user's live settings. Notifications, launcher,
clipboard history and tray use native v5 defaults; visual parity needs review.

GUI changes are saved in `~/.local/state/noctalia/settings.toml` and override
declarative TOML. Inspect that file if settings appear ignored, particularly
`lockscreen` and `idle` overrides. Run `noctalia config validate` on each host to
validate the complete merged live configuration. Promote desired shared settings
to the repository and remove corresponding state overrides when appropriate.
Check for manually installed v4 autostart entries/services before the first v5
login; the repository contains no other shell or idle/locker startup.

## Locking and suspend

Both existing lock shortcuts now call `noctalia msg session lock`; Mod+Space
calls `noctalia msg panel-toggle launcher`. Other shortcuts are preserved.
Noctalia 5.0.1 uses PAM service `login` for password authentication. Existing
NixOS login PAM and KWallet integration are retained; no custom PAM service or
second keyring is needed. Fingerprint and empty-password submission are disabled.

Native idle behavior locks after 600 seconds and powers displays off at 660.
There is no idle suspend action. Noctalia handles logind locking and holds a
sleep-delay inhibitor until the session lock engages for external suspend/lid
sleep. Use the default **Lock & Suspend** action (or
`noctalia msg session lock-and-suspend`) for shell-initiated sleep. Plain Suspend
intentionally skips lock-before-sleep in 5.0.1, so do not add a plain Suspend
menu action. Tez's existing system sleep prohibition stays in place. Woo retains
its existing logind/lid configuration and needs a real suspend/resume test.

## Switch User: deferred pending runtime verification

5.0.1's lock screen exposes configured `shell.session.actions`, including custom
`action = "command"` rows. SDDM's candidate interface is the system-bus
`org.freedesktop.DisplayManager.Seat.SwitchToGreeter` method; discover the seat
object instead of hardcoding Seat0. Its presence, permissions, and behavior have
not been verified on tez, so no button or privileged helper is installed.
Never use logout, terminate-session, restart SDDM, or unlock as a substitute.

Before adding a button, inspect the live SDDM D-Bus objects read-only, verify the
method and caller permissions, then explicitly test from an already locked Niri
session that the greeter opens, another account can log in, and returning to
Kenny's session still requires authentication. Test existing Plasma sessions too.
A command shared between the session panel and lock screen must await confirmed
session locking before switching; issuing a lock IPC request alone is not proof
that the compositor has engaged the lock.

When migrating to Plasma Login Manager in 26.11, verify its actual supported
seat/session switching API, multi-user authorization, return-to-session behavior,
and Noctalia lock-screen action support. Keep the same lock-before-switch
requirement. No assumptions about that future interface are encoded here.

## Activation and rollback (operator steps; not executed)

1. Keep the current known-good NixOS generation and settings backups. Ensure the
   new TOML file is included when using a Git flake (new untracked files are
   otherwise omitted). `path:.` includes the working tree without staging.
2. On tez, build `nix build --no-link path:.#nixosConfigurations.tez.config.system.build.toplevel`.
   At an agreed maintenance time, activate with `sudo nixos-rebuild switch --flake path:.#tez`,
   then log out of Niri and start a fresh Niri session. Startup commands do not
   restart the shell on a config reload. Do not launch v5 beside a running v4.
3. Confirm one `noctalia` process, no v4 shell/other locker, launcher and app
   launch, wallpaper/overview, notification actions, tray, clipboard, media keys,
   brightness, KWallet, and an unaffected Plasma login. Validate merged TOML.
4. Test both lock shortcuts, wrong/right passwords, all monitors, idle lock and
   display wake, and `loginctl lock-session` from the session. Keep a separate
   TTY/admin session available for recovery. Tez must still reject suspend.
5. Only after tez passes, build and activate woo's corresponding configuration;
   test lid-close and Lock & Suspend, resume authentication, and external display
   hotplug. Fast user switching remains unverified until separately tested.
6. If necessary, use the retained generation or `sudo nixos-rebuild switch --rollback`
   from a TTY, then start a fresh session. Revert these migration files before a
   subsequent rebuild. Restore backed-up settings as needed; v4 JSON is retained
   and ignores v5 TOML. Home Manager removes its v5 link when rolling back, while
   app-managed v5 state may remain and can be moved aside after backup.

## Verification and upstream references

Validated against the pinned 5.0.1 source rather than assuming current docs
match this older stable package:

- [5.0.1 Niri integration](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/docs/user/compositor-settings/niri.mdx)
- [Configuration precedence](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/docs/user/configuration/index.mdx)
- [Lock and session settings](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/docs/user/configuration/shell.mdx)
- [Password PAM selection](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/src/shell/lockscreen/lock_screen.cpp)
- [Lock-screen session actions](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/src/shell/lockscreen/lock_surface.cpp)
- [Sleep handling](https://github.com/noctalia-dev/noctalia/blob/v5.0.1/src/app/application_services.cpp)

Workspace validation completed on 2026-11-02:

- `nixfmt --check` for both changed Nix files; `git diff --check`: passed.
- Noctalia 5.0.1 `config validate users/kenny/files/noctalia.toml`: passed.
- Niri 26.04 `validate -c modules/desktop/niri/configs/config.kdl`: passed.
- Both hosts evaluate to Noctalia 5.0.1 with SDDM, Plasma and login KWallet
  enabled, GNOME keyring disabled, and all NixOS assertions passing.
- User accounts remain tez: karen, keegan, kenny; woo: kenny.
- Tez full system build (`--no-link`): passed.
- Woo full `system.build.toplevel.drvPath` evaluation: passed.
- Runtime desktop/locking/suspend/user switching: unverified; no activation,
  deployment, reboot, commit or push was performed.
