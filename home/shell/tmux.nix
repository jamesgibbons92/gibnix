{
  pkgs,
  lib,
  ...
}: let
  session-bar = pkgs.writeScriptBin "tmux-session-bar" (builtins.readFile ./tmux/scripts/session-bar.sh);
in {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    mouse = true;
    terminal = "screen-256color";
    escapeTime = 0;
    baseIndex = 1;
    clock24 = true;
    extraConfig = ''
      # Key bindings
      bind C-k switch-client -T killmode
      bind -T killmode C-w kill-window
      bind -T killmode C-p kill-pane

      bind C-n switch-client -T newmode
      bind -T newmode C-s command-prompt -p "Session name: " "new-session -d -s '%1' \; switch-client -t '%1'"
      bind -T newmode C-w new-window -c "#{pane_current_path}"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Options
      set -g repeat-time 1000
      set-option -g allow-rename off
      set -g set-clipboard on
      set -ga terminal-overrides ",$TERM:Tc"

    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '5'
        '';
      }
    ];
  };
}
