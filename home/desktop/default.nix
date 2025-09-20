{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono

    bitwarden-desktop
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark-Compact";
      package = pkgs.gruvbox-gtk-theme.override {
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        themeVariants = ["default"];
      };
    };
    iconTheme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme.override {
        iconVariants = ["Dark"];
      };
    };
  };

  imports = [
    ./hyprland
    ./ghostty.nix
  ];
}
