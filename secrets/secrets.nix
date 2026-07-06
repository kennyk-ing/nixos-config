let
  kenny_kirby = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0GBm6VaFt7sMzUy5gCiS9umQmuPxtfskzO+GkXEvnP kenny@kirby";
  kenny_woo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPn3sIhk+pS0a5LSppmHbLY98Wktsi6QnH0V4XGf/5m kenny@woo";
  kirby = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgY9NgbiN6lb7YDx135NPBTwWYO7r8/oX3ALweQwQQ2 root@kirby";
  woo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKRzPZ5rAtMrEL3Vo0Jdfb58GyWktgZ93MP6gu0wwo1 root@woo";
in
{
  "wifi.age".publicKeys = [ kenny_kirby kenny_woo kirby woo ];
  "email_personal.age".publicKeys = [ kenny_kirby kenny_woo kirby woo ];
}
