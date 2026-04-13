{pkgs, ...}: {
  # Enable Niri compositor at the system level
  # This sets up the niri binary, systemd integration, and XDG portals
  programs.niri.enable = true;

  # XWayland support for X11 apps (Steam, etc.)
  environment.systemPackages = [pkgs.xwayland-satellite];
}
