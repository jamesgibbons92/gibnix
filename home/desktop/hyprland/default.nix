{
  pkgs,
  config,
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

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    importantPrefixes = [
      "$"
    ];
    settings = {
      "$mainMod" = "SUPER";
    };
  };
}
