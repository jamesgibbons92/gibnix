{
  pkgs,
  lib,
  config,
  ...
}: let
  c = config.lib.stylix.colors.withHashtag;
  isHyprland = config.desktop.windowManager == "hyprland";
in {
  config = lib.mkIf isHyprland {
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;
      settings = lib.importJSON ./config.jsonc;
      style = ''
        * {
            border: none;
            border-radius: 0;
            min-height: 0;
            font-family: "JetBrainsMono Nerd Font";
            font-weight: bold;
            font-size: 16px;
            padding: 0;
        }

        window#waybar {
            background: ${c.base00};
            border-bottom: 2px solid ${c.base03};
        }

        window.overlay#waybar {
          background: transparent;
          border: none;
        }

        tooltip {
            background-color: ${c.base00};
            border: 2px solid ${c.base03};
        }

        #clock,
        #tray,
        #cpu,
        #memory,
        #battery,
        #network,
        #bluetooth,
        #pulseaudio,
        #custom-cava {
            margin: 6px 6px 6px 0px;
            padding: 2px 8px;
        }

        #workspaces {
            background-color: ${c.base01};
            margin: 6px 6px 6px 6px;
            border: 2px solid ${c.base03};
        }

        #workspaces button {
            all: initial;
            min-width: 0;
            box-shadow: inset 0 -3px transparent;
            padding: 2px 4px;
            color: ${c.base04};
        }

        #workspaces button.focused {
            color: ${c.base05};
        }

        #workspaces button.urgent {
            background-color: ${c.base0F};
            color: ${c.base00};
        }

        #clock {
            background-color: ${c.base01};
            border: 2px solid ${c.base03};
            color: ${c.base05};
        }

        #tray,
        #cpu,
        #memory,
        #network,
        #bluetooth,
        #battery,
        #pulseaudio {
            background-color: ${c.base04};
            border: 2px solid ${c.base03};
            color: ${c.base00};
        }

        #cpu.critical,
        #memory.critical {
            background-color: ${c.base04};
            border: 2px solid ${c.base03};
            color: ${c.base0F};
        }

        #bluetooth.off {
          background-color: ${c.base00};
          color: ${c.base04};
        }

        #battery.warning,
        #battery.critical,
        #battery.urgent {
            background-color: ${c.base04};
            border: 2px solid ${c.base03};
            color: ${c.base0F};
        }

        #custom-cava {
            color: ${c.base05};
            border: none;
            font-family: "bargraph";
            font-size: 22px;
        }

        #custom-playerinfo {
            font-size: 13px;
            color: ${c.base05};
        }
      '';
    };

    home.packages = with pkgs; [
    ];
  };
}
