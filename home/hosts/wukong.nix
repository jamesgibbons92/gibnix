{opencode, ...}: {
  imports = [
    ../core
    ../dev
    ../desktop
  ];

  desktop.windowManager = "niri";
  desktop.keyboardLayout = "gb";
  programs.niri.settings.outputs = {
    "HDMI-A-1" = {
      transform.rotation = 90;
      position.x = -1080;
      position.y = 0;
      # position.y = 0;
    };
  };
}
