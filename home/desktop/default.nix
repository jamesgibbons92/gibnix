{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  # Slack's own version hasn't moved (still 4.51.180), but nixpkgs' gtk3/glib
  # regressed since ~2026-09, causing a GLib-GObject "instance has no handler"
  # crash on startup. Build slack against the last known-good nixpkgs snapshot
  # instead, so it links a working gtk3/glib via its rpath.
  pkgsSlackPin = import inputs.nixpkgs-slack-pin {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in {
  options.desktop = {
    windowManager = lib.mkOption {
      type = lib.types.enum ["hyprland" "niri"];
      default = "hyprland";
      description = "Which Wayland compositor to use as the desktop environment.";
    };

    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "gb";
      description = "Keyboard layout passed to the active window manager.";
    };
  };

  config = {
    # Auto-start the configured compositor from TTY1
    programs.zsh.initContent = let
      wmCmd =
        if config.desktop.windowManager == "niri"
        then "niri-session"
        else "Hyprland";
    in
      lib.mkOrder 500 ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec ${wmCmd}
        fi
      '';

    programs.firefox = {
      enable = true;
      profiles.default = {};
      configPath = ".mozilla/firefox";
    };

    stylix.targets.firefox.profileNames = ["default"];

    home.packages = with pkgs; [
      wl-clipboard

      blueman
      playerctl
      pavucontrol
      brightnessctl # Maybe belongs in a laptop specific module?

      libnotify

      (wrapOBS {
        plugins = with obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      })

      spotify
      spotify-player # tui fun
      # bitwarden-desktop
      # Force XWayland: native Wayland Ozone triggers a zxdg_exporter_v2
      # "invalid role" crash on niri (Electron popup surfaces exported
      # before being assigned a role). xwayland-satellite covers this.
      # Built against pkgsSlackPin (see top of file) to avoid a newer
      # nixpkgs gtk3/glib regression that crashes slack on startup.
      (pkgsSlackPin.slack.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings
          ["--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true"]
          ["--ozone-platform=x11"]
          old.installPhase;
      }))
      vesktop

      # blender
      # cura-appimage
      vivaldi
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          timeout = 5;
          monitor = 0;
          follow = "keyboard";
          width = 350;
          height = "(0, 350)";
          origin = "top-right";
          offset = "(30, 30)";
          scale = 0;
          notification_limit = 20;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          progress_bar_corner_radius = 0;
          progress_bar_corners = "all";
          icon_corner_radius = 0;
          icon_corners = "all";
          indicate_hidden = true;
          transparency = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 4;
          gap_size = 1;
          separator_color = lib.mkForce "frame";
          sort = true;
          line_height = 0;
          markup = "full";
          format = ''<b>%s</b>\n%b'';
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          min_icon_size = 16;
          max_icon_size = 128;
          enable_recursive_icon_lookup = true;
          sticky_history = true;
          history_length = 20;
          dmenu = "rofi -dmenu -p dunst";
          browser = "firefox";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 0;
          corners = "all";
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };

        experimental = {
          per_monitor_dpi = false;
        };

        urgency_low = {
          timeout = 10;
          default_icon = "dialog-information";
        };

        urgency_normal = {
          timeout = 10;
          override_pause_level = 30;
          default_icon = "dialog-information";
        };

        urgency_critical = {
          timeout = 0;
          override_pause_level = 60;
          default_icon = "dialog-warning";
        };
      };
    };

    # GTK theme is managed by Stylix
  };

  # Import both WM modules unconditionally - they use mkIf internally
  imports = [
    ./ghostty.nix
    ./rofi.nix
    ./gaming.nix
    ./hyprland
    ./niri
  ];
}
