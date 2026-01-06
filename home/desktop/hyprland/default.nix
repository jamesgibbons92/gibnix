{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./rofi.nix
  ];

  xdg.portal = {
    extraPortals = [(pkgs.xdg-desktop-portal-hyprland.override {hyprland = config.wayland.windowManager.hyprland.package;})];

    config.hyprland = {
      default = ["hyprland" "gtk"];
    };
  };

  # home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  home.pointerCursor = {
    enable = true;
    x11.enable = true;
    gtk.enable = true;
    hyprcursor = {
      enable = true;
    };
    name = "DMZ-White";
    package = pkgs.vanilla-dmz;
  };

  home.packages = with pkgs; [
    nautilus
    spotify-player
    hyprshot
  ];

  home.sessionVariables = {
    HYPRSHOT_DIR = "${config.home.homeDirectory}/screenshots";
  };

  home.file."screenshots/.keep".text = "";

  wayland.windowManager.hyprland = {
    enable = true;
    importantPrefixes = [
      "$"
    ];
    # Extra config is always placed last in .conf
    extraConfig = ''
      animations {
        enabled = yes

        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1

        animation = global, 1, 10, linear
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      exec-once=ghostty
      exec-once=firefox
      exec-once=discord
      exec-once=spotify
      exec-once=[workspace special:magic silent] logseq
    '';
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$shiftMod" = "SHIFT";

      monitor = ",preferred,auto,1.25,bitdepth,8";

      xwayland = {
        force_zero_scaling = true;
      };

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 3;
        gaps_out = 6;
        border_size = 1;
        "col.active_border" = "rgb(dedede)";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 4;
        rounding_power = 4;
        active_opacity = 1.0;
        inactive_opacity = 0.85;
        shadow = {
          enabled = false;
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          vibrancy = 0.6960;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = lib.mkDefault "gb";
        kb_variant = lib.mkDefault "";
        kb_model = lib.mkDefault "";
        kb_rules = lib.mkDefault "";
        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gesture = "3, horizontal, workspace";

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "$mainMod,F,fullscreen"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, space, exec, rofi -show drun"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, left, bringactivetotop"
        "$mainMod, right, bringactivetotop"
        "$mainMod, up, bringactivetotop"
        "$mainMod, down, bringactivetotop"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod ALT, right, exec, hyprctl dispatch resizeactive exact 50% 96% && hyprctl dispatch moveactive exact 50% 4%"
        "$mainMod ALT, left, exec, hyprctl dispatch resizeactive exact 50% 96% && hyprctl dispatch moveactive exact 0 4%"
        "$mainMod ALT, down, exec, hyprctl dispatch resizeactive exact 100% 50% && hyprctl dispatch moveactive exact 0 50%"
        "$mainMod ALT, up, exec, hyprctl dispatch resizeactive exact 98% 93% && hyprctl dispatch moveactive exact 1% 5%"
        "$mainMod, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "$shiftMod, PRINT, exec, hyprshot -m region"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod ALT, mouse:272, resizewindow"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "workspace 1, class:(firefox)"
        "workspace 2, class:(com.mitchellh.ghostty)"
        "workspace 9, class:(Spotify)"
        "workspace 9, class:(discord)"
        "workspace special:magic, class:(Logseq)"
      ];

      exec-once = [
        "hyprpaper"
        "waybar"
      ];
    };
  };
}
