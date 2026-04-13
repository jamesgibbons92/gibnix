{opencode, ...}: {
  imports = [
    ../core
    ../dev
    ../desktop
  ];

  desktop.windowManager = "niri";
  desktop.keyboardLayout = "gb";
}
