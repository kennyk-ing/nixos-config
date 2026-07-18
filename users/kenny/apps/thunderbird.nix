{ osConfig, inputs, ... }:

let
  secretData = import inputs.privateData;
in
  {
  programs.thunderbird = {
    enable = true;
    profiles.kenny.isDefault = true;
  };

  accounts.email.accounts = {
    "Personal" = {
      primary = true;
      address = secretData."Personal".address;
      userName = secretData."Personal".address;
      realName = secretData."Personal".realName;
      passwordCommand = "cat ${osConfig.age.secrets.email_personal.path}";
      imap = {
        host = secretData."Personal".imapHost;
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = secretData."Personal".smtpHost; 
        port = 465; 
        tls.enable = true;
      };
      thunderbird.enable = true;
    };

    "School" = {
      primary = false;
      address = secretData."School".address;
      userName = secretData."School".address;
      realName = secretData."School".realName;
      flavor = "outlook.office365.com";
      thunderbird.enable = true;
    };

    "Gmail" = {
      primary = false;
      address = secretData."Gmail".address;
      userName = secretData."Gmail".address;
      realName = secretData."Gmail".realName;
      flavor = "gmail.com";
      thunderbird.enable = true;
    };

    "GmailSpam" = {
      primary = false;
      address = secretData."GmailSpam".address;
      userName = secretData."GmailSpam".address;
      realName = secretData."GmailSpam".realName;
      flavor = "gmail.com";
      thunderbird.enable = true;
    };
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
