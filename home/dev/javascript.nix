{pkgs, ...}: {
  # Default node version. Use a nix shell for project specific versions
  home.packages = with pkgs; [
    nodejs_22
    pnpm_9
  ];

  programs.bun = {
    enable = true;
  };
}
