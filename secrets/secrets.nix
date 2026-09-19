let
  keys = import ../keys.nix;

  adminKeys = with keys.users.kenny; [
    tez
    woo
  ];

  kennyHosts = builtins.attrValues keys.hosts;

  wifiHosts = with keys.hosts; [
    woo
  ];

  kennyWorkstationHosts = with keys.hosts; [
    tez
    woo
  ];

  sharedUserHosts = with keys.hosts; [
    tez
    woo
  ];
in
{
  "wifi.age".publicKeys = adminKeys ++ wifiHosts;
  "email_personal.age".publicKeys = adminKeys ++ kennyWorkstationHosts;
  "kenny-password.age".publicKeys = adminKeys ++ kennyHosts;
  "karen-password.age".publicKeys = adminKeys ++ sharedUserHosts;
  "keegan-password.age".publicKeys = adminKeys ++ sharedUserHosts;
  "gotify-env.age".publicKeys = adminKeys ++ [ keys.hosts.kingdome ];
  "gotify-token.age".publicKeys = adminKeys ++ [ keys.hosts.kirby ];
  "cloudflare-acme.age".publicKeys = adminKeys ++ [ keys.hosts.kingdome ];
}
