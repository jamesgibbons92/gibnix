{inputs, ...}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      bar.default = {
        center = ["media" "audio_visualizer" "clock"];
        end = ["group:g1" "tray" "notifications" "clipboard" "bluetooth" "volume" "group:2" "control-center" "session"];
        margin_edge = 4;
        margin_ends = 4;

        start = ["launcher" "workspaces" "cpu" "ram"];

        widget_spacing = 13;
        capsule_group = [
          {
            fill = "surface_variant";
            id = "g1";
            members = ["network" "network_rx" "network_tx"];
            opacity = 1.0;
            padding = 6.0;
          }
          {
            fill = "surface_variant";
            id = "g2";
            members = ["power_profile" "battery"];
            opacity = 1.0;
            padding = 6.0;
          }
        ];
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = ["lockscreen-login-box@eDP-1"];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@eDP-1" = {
          box_height = 0.0;
          box_width = 0.0;
          cx = 1440.0;
          cy = 1677.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            input_opacity = 1.0;
            input_radius = 6.0;
            show_login_button = true;
          };
        };
      };

      shell = {
        font_family = "JetBrainsMono NF";
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Tokyo-Night";
      };

      wallpaper = {
        enabled = true;
        default.path = "/path/to/wallpapers/wallpaper.png";
      };
    };
  };
}
