{lib, ...}: {
  imports = [
    ../core
    ../dev
  ];

  programs.tmux = {
    # Fix colour issues when running in windows terminal
    terminal = lib.mkForce "tmux-256color";
  };
}
