{
  pkgs,
  username,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;

  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      curl
      fastfetch
      xclip #move this to de setup

      ripgrep
    ];
  };
}
