{...}: {
  imports = [
    ../core
    ../dev
    ../desktop
  ];

  desktop.windowManager = "niri";
  desktop.keyboardLayout = "gb";

  programs.niri.settings.outputs = {
    "eDP-1" = {
      scale = 1.25;
      position.x = 0;
      position.y = 0;
    };
    "HDMI-A-1" = {
      mode = {
        width = 2560;
        height = 1440;
        refresh = 144.0;
      };
      # position.x = 2880;
      # position.y = 0;
    };
  };
}
