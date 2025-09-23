{pkgs, ...}: {
  # imports = [./global];

  # TODO set as general options... instead of program specifc
  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "gb";
    kb_variant = "";
  };
}
