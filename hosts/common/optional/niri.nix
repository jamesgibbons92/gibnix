{pkgs, ...}: {
  # Enable Niri compositor at the system level
  # This sets up the niri binary, systemd integration, and XDG portals
  programs.niri.enable = true;

  # Use nixpkgs' niri instead of the flake's: niri-flake's packaging still
  # references the removed libdisplay-info_0_2 from nixpkgs-unstable
  programs.niri.package = pkgs.niri;

  # Pin xwayland-satellite to 0.8.1; nixpkgs-unstable has moved on to 0.8.2
  nixpkgs.overlays = [
    (_final: prev: {
      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: rec {
        version = "0.8.1";

        src = prev.fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          tag = "v${version}";
          hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
        };

        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit src;
          name = "${old.pname}-${version}-vendor";
          hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
        };
      });
    })
  ];

  # XWayland support for X11 apps (Steam, etc.)
  environment.systemPackages = [pkgs.xwayland-satellite];
}
