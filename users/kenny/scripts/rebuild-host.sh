# rebuild-host
#
# Convenience wrapper for building and deploying NixOS flake configurations
# to machines in the homelab.
#
# Usage:
#   rebuild-host HOST
#   rebuild-host HOST ACTION
#
# Examples:
#   rebuild-host tez
#       Build .#tez locally, copy it to tez, and switch tez immediately.
#
#   rebuild-host kirby test
#       Build .#kirby locally, copy it to kirby, and activate it temporarily.
#
#   rebuild-host kingdome boot
#       Build .#kingdome locally, copy it to kingdome, and make it the
#       configuration used on the next boot without activating it now.
#
#   rebuild-host woo build
#       Build .#woo locally only. Nothing is copied to or activated on woo.
#
# Supported actions:
#   switch  - Activate now and make the configuration the boot default.
#             This is the default when ACTION is omitted.
#
#   test    - Activate now, but do not make it the boot default.
#
#   boot    - Make it the boot default, but do not activate it now.
#
#   build   - Build locally only; do not modify the remote host.

if (($# < 1 || $# > 2)); then
  echo "Usage: $(basename "$0") HOST [switch|test|boot|build]" >&2
  exit 2
fi

host="$1"
action="${2:-switch}"

case "$action" in
switch | test | boot | build)
  ;;
*)
  echo "Invalid action: $action" >&2
  echo "Valid actions: switch, test, boot, build" >&2
  exit 2
  ;;
esac

repo="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Not inside a Git repository." >&2
  exit 1
}

if [[ "$action" == "build" ]]; then
  exec nixos-rebuild build \
    --flake "$repo#$host"
fi

exec nixos-rebuild "$action" \
  --flake "$repo#$host" \
  --target-host "kenny@$host" \
  --sudo \
  --ask-sudo-password
