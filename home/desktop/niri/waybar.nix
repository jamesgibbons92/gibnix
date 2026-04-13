{
  pkgs,
  lib,
  config,
  ...
}: let
  c = config.lib.stylix.colors.withHashtag;
  isNiri = config.desktop.windowManager == "niri";
in {
  config = lib.mkIf isNiri {
    stylix.targets.waybar.enable = false;

    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          spacing = 0;
          height = 30;
          margin-top = 0;
          margin-right = 0;
          margin-bottom = 0;
          margin-left = 0;
          modules-left = ["niri/workspaces" "cpu" "memory"];
          modules-center = ["custom/playerinfo"];
          modules-right = [
            "tray"
            "battery"
            "network"
            "bluetooth"
            "pulseaudio"
            "clock"
          ];

          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              default = "";
            };
          };

          tray = {
            spacing = 10;
            tooltip = false;
            show-passive-items = true;
          };

          "custom/playerinfo" = {
            format = "|{}|";
            exec = "~/.config/waybar/scripts/playerinfo.sh";
            escape = true;
            return-type = "string";
            interval = 1;
            tooltip = true;
            on-click-middle = "playerctl play-pause";
            on-click-right = "playerctl next";
            on-click-left = "playerctl previous";
          };

          clock = {
            format = "{:%a %d, %I:%M %p}";
            tooltip = false;
          };

          cpu = {
            interval = 2;
            format = "  {}%";
            max-length = 10;
            states = {
              critical = 90;
            };
          };

          memory = {
            interval = 5;
            format = "  {used:0.1f}G/{total:0.1f}G";
            states = {
              critical = 80;
            };
          };

          battery = {
            format = "{icon} ";
            format-icons = ["" "" "" "" ""];
            max-length = 25;
            interval = 60;
            states = {
              warning = 20;
              critical = 10;
            };
            tooltip-format = "{capacity}% - {timeTo}";
          };

          network = {
            format = "{ifname}";
            format-wifi = "   {signalStrength}%";
            format-ethernet = "󰊗 {ipaddr}/{cidr}";
            format-disconnected = "no net";
            tooltip-format = "{essid}";
            on-click = "ghostty -e nmtui";
          };

          bluetooth = {
            format = " {status}";
            format-connected = " {device_alias}";
            format-connected-battery = " {device_alias} {device_battery_percentage}%";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
            on-click = "/bin/sh -c '$(bluetoothctl show | grep -q \"Powered: yes\") && bluetoothctl power off || bluetoothctl power on'";
            on-click-right = "blueman-manager";
          };

          pulseaudio = {
            scroll-step = 1;
            max-volume = 150;
            format = "{icon}   {volume}%";
            format-bluetooth = "{icon}   {volume}%";
            format-muted = "";
            format-icons = {
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
              "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = ["" ""];
            };
            nospacing = 1;
            on-click = "pavucontrol";
            tooltip = false;
          };
        }
      ];
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
        #pulseaudio {
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

        #workspaces button.focused,
        #workspaces button.active {
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

        #custom-playerinfo {
            font-size: 13px;
            color: ${c.base05};
        }
      '';
    };
  };
}
