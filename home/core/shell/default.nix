{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./tmux.nix
    ./starship.nix
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
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
      initContent = lib.mkOrder 1600 ''
        # if [ -z "$TMUX" ]; then
        #   tmux a
        # fi

        find-replace() {
          local dry_run=false
          local search=""
          local replace=""
          local rg_args=()

          for arg in "$@"; do
            case "$arg" in
              --dry-run) dry_run=true ;;
              *)
                if [[ -z "$search" ]]; then
                  search="$arg"
                elif [[ -z "$replace" ]]; then
                  replace="$arg"
                else
                  rg_args+=("$arg")
                fi
                ;;
            esac
          done

          if [[ -z "$search" || -z "$replace" ]]; then
            echo "Usage: find-replace [--dry-run] <search> <replace> [rg args...]"
            return 1
          fi

          local files=($(rg -l --fixed-strings "$search" "''${rg_args[@]}"))

          if [[ ''${#files[@]} -eq 0 ]]; then
            echo "No files found containing: $search"
            return 0
          fi

          echo "Found ''${#files[@]} file(s):"
          printf '  %s\n' "''${files[@]}"
          echo ""

          local escaped_search=$(printf '%s' "$search" | sed 's/[&/\|.*^$[\]]/\\&/g')
          local escaped_replace=$(printf '%s' "$replace" | sed 's/[&/\|]/\\&/g')

          if $dry_run; then
            echo "--- Dry run (no changes will be made) ---"
            echo ""
            for f in "''${files[@]}"; do
              local diff_output=$(sed "s|$escaped_search|$escaped_replace|g" "$f" | diff --color=always -u "$f" - 2>/dev/null)
              if [[ -n "$diff_output" ]]; then
                echo "$diff_output" | sed "s|^--- .*|--- $f|;s|^+++ .*|+++ $f (modified)|"
                echo ""
              fi
            done
            return 0
          fi

          read -q "REPLY?Replace '$search' with '$replace'? [y/N] "
          echo ""

          if [[ "$REPLY" == "y" ]]; then
            for f in "''${files[@]}"; do
              sed -i "s|$escaped_search|$escaped_replace|g" "$f"
            done
            echo "Done. Replaced in ''${#files[@]} file(s)."
          else
            echo "Aborted."
          fi
        }
      '';
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
