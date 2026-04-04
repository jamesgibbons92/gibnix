{opencode, ...}: {
  imports = [
    ../core
    ../dev
    ../desktop
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "gb";
    kb_variant = "";
  };
}
