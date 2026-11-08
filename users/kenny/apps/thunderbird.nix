{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.kenny.isDefault = true;
  };

  # Set as default email/calendar app
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "x-scheme-handler/net.thunderbird" = "thunderbird.desktop";

      # Calendar links
      "text/calendar" = "thunderbird.desktop";
      "application/x-extension-ics" = "thunderbird.desktop";
      "x-scheme-handler/webcal" = "thunderbird.desktop";
      "x-scheme-handler/webcals" = "thunderbird.desktop";
    };
  };
}
