{
  pkgs,
  inputs,
  ...
}: {
  # Disable Stylix's opencode module at the HM level.
  # The nixpkgs opencode HM module doesn't have the `tui` option
  # that Stylix's opencode module expects, causing evaluation errors.
  home-manager.sharedModules = [
    {
      disabledModules = [
        "${inputs.stylix}/modules/opencode/hm.nix"
      ];
    }
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    image = ../../../home/desktop/hyprland/wallpaper.jpg;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        applications = 11;
        terminal = 10;
        desktop = 11;
      };
    };

    cursor = {
      package = pkgs.vanilla-dmz;
      name = "DMZ-White";
      size = 24;
    };
  };
}
