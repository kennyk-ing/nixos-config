let
  keys = import ../keys.nix;

  adminKeys = builtins.attrValues keys.users.kenny;

  kennyHosts = builtins.attrValues keys.hosts;

  wifiHosts = with keys.hosts; [
    kirby
    woo
  ];

  kennyWorkstationHosts = with keys.hosts; [
    kirby
    tez
    woo
  ];

  sharedUserHosts = with keys.hosts; [
    kirby
    tez
  ];
in
{
  "wifi.age".publicKeys = adminKeys ++ wifiHosts;
  "email_personal.age".publicKeys = adminKeys ++ kennyWorkstationHosts;
  "kenny-password.age".publicKeys = adminKeys ++ kennyHosts;
  "karen-password.age".publicKeys = adminKeys ++ sharedUserHosts;
}
