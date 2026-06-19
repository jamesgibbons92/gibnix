{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    # ./waybar.nix
    ./wallpaper.nix
    ./swaylock.nix
    ./recorder.nix
    ./noctalia.nix
  ];

  config = lib.mkIf (config.desktop.windowManager == "niri") {
    xdg.portal = {
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config.niri = {
        default = ["gnome" "gtk"];
      };
    };

    home.packages = with pkgs; [
      nautilus
      spotify-player
      swaynotificationcenter
      wl-clipboard
      grim
      slurp
      satty
    ];

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    home.file."screenshots/.keep".text = "";

    programs.niri = {
      settings = {
        # Environment variables
        environment = {
          NIXOS_OZONE_WL = "1";
          DISPLAY = ":0";
        };

        # Input configuration - mirrors Hyprland's input settings
        input = {
          keyboard.xkb = {
            layout = config.desktop.keyboardLayout;
            options = "caps:escape";
          };
          touchpad = {
            tap = true;
            natural-scroll = false;
          };
          mouse = {
            accel-speed = 0.0;
          };
          focus-follows-mouse = {
            enable = true;
          };
        };

        # Output / monitor configuration
        outputs = {
          "eDP-1" = {
            scale = 1.25;
          };
          "DP-2" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 144.0;
            };
            position.x = 0;
            position.y = 0;
          };
          "HDMI-A-1" = {
            mode = {
              width = 2560;
              height = 1440;
              refresh = 144.0;
            };
            # position.x = 0;
            # position.y = 0;
          };
        };

        # Named workspaces (referenced by window-rules)
        workspaces = {
          "web" = {};
          "terminal" = {};
          "media" = {};
        };

        # Layout - Niri's scrollable tiling
        layout = {
          gaps = 6;
          center-focused-column = "never";

          preset-column-widths = [
            {proportion = 1.0 / 3.0;}
            {proportion = 1.0 / 2.0;}
            {proportion = 2.0 / 3.0;}
            {proportion = 1.0;}
          ];

          default-column-width = {
            proportion = 1.0 / 2.0;
          };

          focus-ring = {
            enable = true;
            width = 2;
            # Colors managed by Stylix via niri-flake integration
          };

          border = {
            enable = false;
          };
        };

        # Cursor
        cursor = {
          hide-when-typing = true;
        };

        # Prefer server-side decorations
        prefer-no-csd = true;

        # Screenshot path
        screenshot-path = "~/screenshots/%Y-%m-%d_%H-%M-%S.png";

        # Startup applications
        spawn-at-startup = [
          {argv = ["xwayland-satellite"];}
          {argv = ["noctalia"];}
          # {argv = ["waybar"];}
          {argv = ["swaybg" "-i" "${config.stylix.image}" "-m" "fill"];}
          {argv = ["ghostty"];}
          {argv = ["firefox"];}
          {argv = ["discord"];}
          {argv = ["spotify"];}
        ];

        # Animations
        animations = {
          slowdown = 1.0;
        };

        # Window rules
        window-rules = [
          {
            matches = [{app-id = "firefox";}];
            open-on-workspace = "web";
            open-maximized = true;
          }
          {
            matches = [{app-id = "com.mitchellh.ghostty";}];
            open-on-workspace = "terminal";
            open-maximized = true;
          }
          {
            matches = [{app-id = "discord";}];
            open-on-workspace = "media";
          }
          {
            matches = [{app-id = "Spotify";}];
            open-on-workspace = "media";
          }
          # Red indicator on screencasted windows
          {
            matches = [{is-window-cast-target = true;}];
            focus-ring = {
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };
            border = {
              enable = true;
              active.color = "#f38ba8";
              inactive.color = "#7d0d2d";
            };
          }
        ];

        # Keybindings - adapted from Hyprland config
        binds = let
          actions = config.lib.niri.actions;
          sh = actions.spawn "sh" "-c";
        in {
          # Application launchers
          "Mod+Q".action = actions.spawn "ghostty";
          "Mod+E".action = actions.spawn "nautilus";
          "Mod+Space".action = actions.spawn "rofi" "-show" "drun";

          # Window management
          "Mod+C".action = actions.close-window;
          "Mod+V".action = actions.toggle-window-floating;
          "Mod+F".action = actions.maximize-column;
          "Mod+Shift+F".action = actions.fullscreen-window;
          "Mod+Tab".action = actions.toggle-overview;

          # Focus movement (vim-style hjkl)
          "Mod+H".action = actions.focus-column-left;
          "Mod+L".action = actions.focus-column-right;
          "Mod+K".action = actions.focus-window-or-workspace-up;
          "Mod+J".action = actions.focus-window-or-workspace-down;

          # Move windows (vim-style hjkl)
          "Mod+Shift+H".action = actions.move-column-left;
          "Mod+Shift+L".action = actions.move-column-right;
          "Mod+Shift+K".action = actions.move-window-up-or-to-workspace-up;
          "Mod+Shift+J".action = actions.move-window-down-or-to-workspace-down;

          # Monitor focus / move
          "Mod+Comma".action = actions.focus-monitor-left;
          "Mod+Period".action = actions.focus-monitor-right;
          "Mod+Shift+Comma".action = actions.move-column-to-monitor-left;
          "Mod+Shift+Period".action = actions.move-column-to-monitor-right;

          # Column width / window height
          "Mod+Minus".action = actions.set-column-width "-10%";
          "Mod+Equal".action = actions.set-column-width "+10%";
          "Mod+Shift+Minus".action = actions.set-window-height "-10%";
          "Mod+Shift+Equal".action = actions.set-window-height "+10%";

          # Cycle column widths through presets
          "Mod+R".action = actions.switch-preset-column-width;

          # Consume / expel windows from column
          "Mod+BracketLeft".action = actions.consume-or-expel-window-left;
          "Mod+BracketRight".action = actions.consume-or-expel-window-right;

          # Workspace navigation (1-10)
          "Mod+1".action = actions.focus-workspace 1;
          "Mod+2".action = actions.focus-workspace 2;
          "Mod+3".action = actions.focus-workspace 3;
          "Mod+4".action = actions.focus-workspace 4;
          "Mod+5".action = actions.focus-workspace 5;
          "Mod+6".action = actions.focus-workspace 6;
          "Mod+7".action = actions.focus-workspace 7;
          "Mod+8".action = actions.focus-workspace 8;
          "Mod+9".action = actions.focus-workspace 9;
          "Mod+0".action = actions.focus-workspace 10;

          # Move window to workspace (1-10)
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;
          "Mod+Shift+0".action.move-column-to-workspace = 10;

          # Screen recording (wf-recorder region select -> WebP)
          "Mod+O".action = sh "$HOME/.local/bin/screen-capture.sh";

          # Toggle OBS Studio
          "Mod+Shift+O".action = sh "pgrep -x obs && pkill -x obs || obs";

          # Dynamic screencasting (niri built-in)
          "Mod+D".action = actions.set-dynamic-cast-window;
          "Mod+Shift+D".action = actions.set-dynamic-cast-monitor;
          "Mod+Ctrl+D".action = actions.clear-dynamic-cast-target;

          # Screenshots (niri built-in)
          "Mod+P".action.screenshot = {};
          "Mod+Shift+P".action.screenshot-window = {};
          "Mod+Ctrl+P".action.screenshot-screen = {};

          # Media keys - same as Hyprland
          "XF86AudioRaiseVolume".action = sh "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessUp".action = sh "brightnessctl -e4 -n2 set 5%+";
          "XF86MonBrightnessDown".action = sh "brightnessctl -e4 -n2 set 5%-";
          "XF86AudioNext".action = sh "playerctl next";
          "XF86AudioPause".action = sh "playerctl play-pause";
          "XF86AudioPlay".action = sh "playerctl play-pause";
          "XF86AudioPrev".action = sh "playerctl previous";

          # Session management
          "Mod+Shift+E".action = actions.quit;
          "Mod+Shift+Slash".action = actions.show-hotkey-overlay;

          # Lock screen
          "Mod+Ctrl+L".action = actions.spawn "swaylock";
        };

        # Switch events - lock screen when laptop lid closes
        switch-events = {
          lid-close.action.spawn = ["swaylock"];
        };
      };
    };
  };
}
