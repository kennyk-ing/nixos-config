let
  kenny = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0GBm6VaFt7sMzUy5gCiS9umQmuPxtfskzO+GkXEvnP kenny@kirby";
  kirby = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgY9NgbiN6lb7YDx135NPBTwWYO7r8/oX3ALweQwQQ2 root@kirby";
  woo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKRzPZ5rAtMrEL3Vo0Jdfb58GyWktgZ93MP6gu0wwo1 root@woo";
in
{
  "wifi.age".publicKeys = [ kenny kirby woo ];
  "email_personal.age".publicKeys = [ kenny kirby woo ];
}
