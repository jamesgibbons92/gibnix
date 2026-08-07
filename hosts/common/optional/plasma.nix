{pkgs, ...}: {
  # A second desktop session used for gaming, kept separate from the daily niri
  # setup. Plasma ships both a Wayland and an X11 session (`plasma` and
  # `plasmax11`), so games can be tried under either without a rebuild.
  #
  # No display manager is enabled: sessions are launched from tty1 by the `game`
  # command (see home/desktop/gaming.nix). Xorg itself comes from
  # hosts/common/core (services.xserver.enable + startx) and the nvidia driver
  # from the host's hardware-configuration.nix, so plasmax11 needs no extra X
  # config here.
  services.desktopManager.plasma6.enable = true;

  # Drop the bundled applications that duplicate what's already installed.
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    ark
    elisa
    gwenview
    kate
    khelpcenter
    krdp
    okular
    plasma-browser-integration
    plasma-keyboard
    qtvirtualkeyboard
  ];
}
