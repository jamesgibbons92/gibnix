{
  pkgs,
  config,
  lib,
  ...
}: let
  c = config.lib.stylix.colors.withHashtag;
  isNiri = config.desktop.windowManager == "niri";
in {
  config = lib.mkIf isNiri {
    # Disable Stylix's swaylock target - we use custom layout with Stylix colors
    stylix.targets.swaylock.enable = false;

    programs.swaylock = {
      enable = true;
      settings = {
        image = "${config.stylix.image}";
        scaling = "fill";
        font = "JetBrains Mono";
        font-size = 24;

        # Colors from Stylix
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";

        ring-color = "${lib.removePrefix "#" c.base03}";
        ring-clear-color = "${lib.removePrefix "#" c.base0A}";
        ring-ver-color = "${lib.removePrefix "#" c.base0D}";
        ring-wrong-color = "${lib.removePrefix "#" c.base0F}";

        key-hl-color = "${lib.removePrefix "#" c.base0B}";
        bs-hl-color = "${lib.removePrefix "#" c.base0F}";

        text-color = "${lib.removePrefix "#" c.base05}";
        text-clear-color = "${lib.removePrefix "#" c.base0A}";
        text-ver-color = "${lib.removePrefix "#" c.base0D}";
        text-wrong-color = "${lib.removePrefix "#" c.base0F}";

        separator-color = "00000000";
        line-color = "00000000";

        indicator-radius = 100;
        indicator-thickness = 7;
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 115;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }

        {
          timeout = 120;
          command = "${pkgs.bash}/bin/sh -c '${pkgs.swaylock}/bin/swaylock &'";
        }

        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events.before-sleep = "${pkgs.swaylock}/bin/swaylock";
    };
  };
}
