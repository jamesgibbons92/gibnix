{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      name = "James";
      email = "10496761+jamesgibbons92@users.noreply.github.com";
    };
  };

  programs.lazygit = {
    enable = true;
  };

  home.packages = with pkgs; [
    gh
  ];

  programs.zsh.shellAliases = {
    lg = "lazygit";
  };
}
