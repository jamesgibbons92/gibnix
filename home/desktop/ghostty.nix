{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Gruvbox Dark Hard";
      font-size = 10;
    };
  };
}
