{
  lib,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  isHyprland = config.desktop.windowManager == "hyprland";
in {
  config = lib.mkIf isHyprland {
    # Disable Stylix's hyprlock target - we use custom layout with Stylix colors
    stylix.targets.hyprlock.enable = false;

    programs.hyprlock = {
      enable = true;
      importantPrefixes = [
        "$"
      ];
      settings = {
        general = {
          hide_cursor = true;
        };

        animations = {
          enabled = false;
          bezier = "linear, 1, 1, 0, 0";
          animation = [
            "fadeIn, 1, 5, linear"
            "fadeOut, 1, 5, linear"
            "inputFieldDots, 1, 2, linear"
          ];
        };

        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "20%, 5%";
            outline_thickness = 3;
            inner_color = "rgba(0, 0, 0, 0.0)";
            outer_color = "rgb(${c.base0D}) rgb(${c.base0B}) 45deg";
            check_color = "rgb(${c.base0A}) rgb(${c.base0A}) 120deg";
            fail_color = "rgb(${c.base0F}) rgb(${c.base0F}) 40deg";
            font_color = "rgb(${c.base05})";
            fade_on_empty = false;
            rounding = 15;
            font_family = "Monospace";
            placeholder_text = "...";
            fail_text = "$PAMFAIL";
            dots_spacing = 0.3;
            position = "0, -20";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          # TIME
          {
            monitor = "";
            text = "$TIME";
            font_size = 90;
            font_family = "Monospace";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          # DATE
          {
            monitor = "";
            text = "cmd[update:60000] date +\"%A, %d %B %Y\"";
            font_size = 25;
            font_family = "Monospace";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
          # Keyboard layout switcher
          {
            monitor = "";
            text = "";
            font_size = 24;
            onclick = "hyprctl switchxkblayout all next";
            position = "250, -20";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      settings = let
        hyprlock = lib.getExe config.programs.hyprlock.package;
      in {
        bind = [
          "$mainMod,L,exec,${hyprlock}"
        ];
        bindl = [
          ",switch:off:Lid Switch,exec,${hyprlock} --immediate"
        ];
      };
    };
  };
}
