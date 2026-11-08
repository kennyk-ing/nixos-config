# Recipient rules discovered automatically by agenix.
let
  keys = import ../keys.nix;

  adminKeys = with keys.users.kenny; [
    tez
    woo
  ];

  kennyHosts = builtins.attrValues keys.hosts;

  wifiHosts = with keys.hosts; [
    earl
    woo
  ];

  sharedUserHosts = with keys.hosts; [
    tez
    woo
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
  "wireguard-woo.age".publicKeys = adminKeys ++ [ keys.hosts.woo ];
  "wireguard-earl.age".publicKeys = adminKeys ++ [ keys.hosts.earl ];
}
