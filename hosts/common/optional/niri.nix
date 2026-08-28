{pkgs, ...}: {
  # Enable Niri compositor at the system level
  # This sets up the niri binary, systemd integration, and XDG portals
  programs.niri.enable = true;

  # Use nixpkgs' niri instead of the flake's: niri-flake's packaging still
  # references the removed libdisplay-info_0_2 from nixpkgs-unstable
  programs.niri.package = pkgs.niri;

  # XWayland support for X11 apps (Steam, etc.)
  environment.systemPackages = [pkgs.xwayland-satellite];
}
