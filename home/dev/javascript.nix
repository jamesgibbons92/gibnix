{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_22
    pnpm_10
  ];

  programs.bun = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    pn = "pnpm";
  };
}
