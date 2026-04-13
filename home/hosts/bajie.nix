{opencode, ...}: {
  imports = [
    ../core
    ../dev
    ../desktop
    # ../gaming
  ];

  desktop.windowManager = "niri";
  desktop.keyboardLayout = "gb";
}
