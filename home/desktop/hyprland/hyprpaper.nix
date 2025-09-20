{config, ...}: let
  wallpaper = ./wallpaper.jpg;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;
      preload = "${wallpaper}";
      wallpaper = ",${wallpaper}";
    };
  };
}
