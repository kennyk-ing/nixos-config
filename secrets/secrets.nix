let
  keys = import ../keys.nix;

  adminKeys = builtins.attrValues keys.users.kenny;
  allHosts = builtins.attrValues keys.hosts;
  sharedUserHosts = with keys.hosts; [
    kirby
  ];

  allRecipients = adminKeys ++ allHosts;
  sharedUserRecipients = adminKeys ++ sharedUserHosts;
in
{
  "wifi.age".publicKeys = allRecipients;
  "email_personal.age".publicKeys = allRecipients;
  "kenny-password.age".publicKeys = allRecipients;
  "karen-password.age".publicKeys = sharedUserRecipients;
}
