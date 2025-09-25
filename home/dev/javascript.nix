{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_22
    pnpm_9
  ];

  programs.bun = {
    enable = true;
  };
}
