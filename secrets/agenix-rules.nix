let
  keys = import ../keys.nix;

  adminKeys = with keys.users.kenny; [
    tez
    earl
  ];

  kennyHosts = builtins.attrValues keys.hosts;

  wifiHosts = with keys.hosts; [
    earl
  ];

  sharedUserHosts = with keys.hosts; [
    tez
  ];
in
{
  "wifi.age".publicKeys = adminKeys ++ wifiHosts;
  "kenny-password.age".publicKeys = adminKeys ++ kennyHosts;
  "karen-password.age".publicKeys = adminKeys ++ sharedUserHosts;
  "keegan-password.age".publicKeys = adminKeys ++ sharedUserHosts;
  "gotify-env.age".publicKeys = adminKeys ++ [ keys.hosts.kingdome ];
  "gotify-token.age".publicKeys = adminKeys ++ [ keys.hosts.kam ];
  "cloudflare-acme.age".publicKeys = adminKeys ++ [ keys.hosts.kingdome ];
  "wireguard-earl.age".publicKeys = adminKeys ++ [ keys.hosts.earl ];
  "restic-server-users.age".publicKeys = adminKeys ++ [ keys.hosts.kingdome ];
  "restic-tez-http.age".publicKeys = adminKeys ++ [ keys.hosts.tez ];
  "restic-tez-repository.age".publicKeys = adminKeys ++ [
    keys.hosts.tez
    keys.hosts.kingdome
  ];
  "gotify-backups-token.age".publicKeys = adminKeys ++ [
    keys.hosts.tez
    keys.hosts.kingdome
  ];
}
