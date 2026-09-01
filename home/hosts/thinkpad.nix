{lib, ...}: {
  imports = [
    ../core
    ../dev
    ../desktop
  ];

  desktop.windowManager = "niri";
  desktop.keyboardLayout = "gb";
  programs.niri.settings.outputs = {
    "eDP-1" = {
      scale = lib.mkForce 1.0;
    };
    "HDMI-A-2" = {
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.951;
      };
      scale = lib.mkForce 1.0;
    };
  };
}
