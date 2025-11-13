{
  pkgs,
  lib,
  ...
}: let
  session-bar = pkgs.writeScriptBin "tmux-session-bar" (builtins.readFile ./tmux/scripts/session-bar.sh);
in {
  programs.tmux = {
    enable = true;
    prefix = "M-Space";
    mouse = true;
    terminal = "screen-256color";
    newSession = true;
    escapeTime = 0;
    baseIndex = 1;
    clock24 = true;
    extraConfig = ''
      # Key bindings
      bind -n M-p switch-client -T panemode
      bind -T panemode M-c kill-pane
      bind -T panemod M-b break-pane

      bind -n M-w switch-client -T windowmode
      bind -T windowmode M-n new-window -c "#{pane_current_path}"
      bind -T windowmode M-c kill-window

      bind -n M-s switch-client -T sessionmode
      bind -T sessionmode M-n command-prompt -p "Session name: " "new-session -d -s '%1' \; switch-client -t '%1'"
      bind -T sessionmode M-c kill-session

      bind -n M-| split-window -h -c "#{pane_current_path}"
      bind -n M-- split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Vim style
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D

      # resize panes
      bind -n C-M-h resize-pane -L 5
      bind -n C-M-l resize-pane -R 5
      bind -n C-M-k resize-pane -U 5
      bind -n C-M-j resize-pane -D 5
      bind -n C-M-Left resize-pane -L 5
      bind -n C-M-Right resize-pane -R 5
      bind -n C-M-Up resize-pane -U 5
      bind -n C-M-Down resize-pane -D 5


      # Options
      set -g repeat-time 1000
      set-option -g allow-rename off
      set -g set-clipboard on
      set -g default-path "~"
    '';

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          resurrect_dir=~/.tmux/resurrect/
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g' $(readlink -f $resurrect_dir/last)"
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'off'
          set -g @continuum-save-interval '2'
        '';
      }
    ];
  };
  systemd.user.services.tmuxserver = {
    Unit = {
      Description = "Tmux server";
      After = ["home-manager-james.service"];
    };
    Install = {
      WantedBy = ["multi-user.target"];
    };
    Service = {
      Type = "forking";
      Environment = "TMUX_TMPDIR=/run/user/1000/";
      ExecStart = "${pkgs.tmux}/bin/tmux start-server";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
    };
  };
}
