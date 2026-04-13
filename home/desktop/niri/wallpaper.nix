{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.desktop.windowManager == "niri") {
    # Wallpaper via swaybg - launched in niri's spawn-at-startup
    # swaybg uses the Stylix image, same as hyprpaper does for Hyprland
    home.packages = with pkgs; [
      swaybg
    ];
  };
}
