{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono

    libnotify

    bitwarden-desktop
    slack
    discord
  ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "none";
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
        frame_color = "#d3869b";
        gap_size = 1;
        separator_color = "frame";
        sort = true;
        font = "Monospace 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
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
        icon_path = "${pkgs.gruvbox-gtk-theme}/icons";
        enable_recursive_icon_lookup = true;
        icon_theme = "Gruvbox-Dark";
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
        background = "#504945";
        foreground = "#d4be98";
        timeout = 10;
        default_icon = "dialog-information";
      };

      urgency_normal = {
        background = "#504945";
        foreground = "#d4be98";
        timeout = 10;
        override_pause_level = 30;
        default_icon = "dialog-information";
      };

      urgency_critical = {
        background = "#504945";
        foreground = "#d4be98";
        frame_color = "#ea6962";
        timeout = 0;
        override_pause_level = 60;
        default_icon = "dialog-warning";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark-Compact";
      package = pkgs.gruvbox-gtk-theme.override {
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        themeVariants = ["default"];
      };
    };
    iconTheme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme.override {
        iconVariants = ["Dark"];
      };
    };
  };

  imports = [
    ./hyprland
    ./ghostty.nix
  ];
}
