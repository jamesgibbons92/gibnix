{config, ...}: {
  # Wallpaper is handled by Stylix via stylix.image in hosts/common/core/stylix.nix
  # Stylix sets the wallpaper but doesn't preload it, so we add preload here.
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      preload = [config.stylix.image];
    };
  };
}
