{lib, ...}: {
  imports = [
    ../core
    ../dev
  ];

  programs.tmux = {
    # Fix colour issues when running in windows terminal
    extraConfig = lib.mkAfter ''
      set -g default-terminal "screen-256color"
      set-option -sa terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
