{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./tmux.nix
  ];

  home.packages = [
    (pkgs.writeScriptBin "shell-tmux" ''
      # Exit if already in a tmux session
      if [[ -z "$TMUX" && ! $(tmux list-clients 2>/dev/null) ]]; then
        tmux attach-session || tmux new-session
      fi
    '')
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      history = {
        save = 999999;
        size = 999999;
        share = true;
      };
      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };
      initContent =
        (
          if (pkgs ? hyprland)
          then ''
            if [ "$(tty)" = "/dev/tty1" ]; then
              exec Hyprland
            fi
          ''
          else ""
        )
        + ''
          shell-tmux
        '';
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$character"
        ];

        directory = {
          style = "blue";
        };

        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };

        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
