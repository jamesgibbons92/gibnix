{
  lib,
  opencode,
  ...
}: {
  imports = [
    ../core
    ../dev
  ];

  programs.tmux = {
    # Fix colour issues when running in windows terminal
    extraConfig = lib.mkAfter ''
      set -g default-terminal "tmux-256color"
      set-option -sa terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
