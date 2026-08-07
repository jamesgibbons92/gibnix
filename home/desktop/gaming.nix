{
  pkgs,
  lib,
  config,
  ...
}: let
  plasma = pkgs.kdePackages.plasma-workspace;

  # Written by `game`, read (and consumed) by the tty1 hook below.
  flagFile = "\${XDG_STATE_HOME:-$HOME/.local/state}/gaming-session";

  game = pkgs.writeShellScriptBin "game" ''
    set -eu

    flag="${flagFile}"
    session=plasma

    case "''${1:-}" in
      "") ;;
      --x11) session=plasmax11 ;;
      -h | --help)
        echo "usage: game [--x11]"
        echo
        echo "  game        queue the Plasma Wayland session, then quit niri"
        echo "  game --x11  queue the Plasma X11 session instead"
        echo
        echo "Log back in on tty1 to enter it; log out of Plasma to return to niri."
        exit 0
        ;;
      *)
        echo "game: unknown argument '$1' (try --help)" >&2
        exit 1
        ;;
    esac

    mkdir -p "$(dirname "$flag")"
    printf '%s\n' "$session" > "$flag"

    if [ -n "''${NIRI_SOCKET:-}" ]; then
      exec niri msg action quit --skip-confirmation
    fi

    echo "$session queued - log out of tty1 to start it."
  '';
in {
  options.desktop.gaming.enable =
    lib.mkEnableOption "the on-demand Plasma session for gaming, entered with `game`";

  config = lib.mkIf config.desktop.gaming.enable {
    home.packages = [game];

    # Stylix follows the DE configured in NixOS, so enabling Plasma flips the Qt
    # platform theme to "kde" - which Stylix warns is unsupported, dropping its
    # theming from Qt apps in the everyday niri session. Pin it back to qtct: the
    # gaming session is the guest here and shouldn't restyle the daily desktop.
    stylix.targets.qt.platform = "qtct";

    # Runs before the compositor exec in ./default.nix (mkOrder 500), so a queued
    # gaming session wins on tty1 without that block needing to know about this one.
    programs.zsh.initContent = lib.mkOrder 400 ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        gaming_session_flag="${flagFile}"
        if [ -r "$gaming_session_flag" ]; then
          gaming_session=$(cat "$gaming_session_flag")
          # Consume the flag before starting: a session that fails to come up falls
          # back to the normal desktop at the next login rather than looping.
          rm -f "$gaming_session_flag"
          # Plasma's shell is entirely QtQuick, and the niri session's Qt settings
          # name kvantum as the style. Kvantum is a QWidget-only style with no
          # QtQuick Controls counterpart, so every QML component fails to load
          # ("module kvantum is not installed") and the session comes up as a bare
          # cursor on black. Hand Plasma its own theming instead; colours still
          # come from Stylix via kdeglobals in XDG_CONFIG_DIRS.
          export QT_QPA_PLATFORMTHEME=kde
          export QT_QUICK_CONTROLS_STYLE=org.kde.desktop
          unset QT_STYLE_OVERRIDE
          # Plasma runs its shell as systemd user services, and the manager still
          # holds the values niri imported earlier in this boot - fix them there too.
          systemctl --user set-environment \
            QT_QPA_PLATFORMTHEME=kde QT_QUICK_CONTROLS_STYLE=org.kde.desktop
          systemctl --user unset-environment QT_STYLE_OVERRIDE
          case "$gaming_session" in
            plasmax11) exec startx ${plasma}/bin/startplasma-x11 ;;
            *) exec ${plasma}/bin/startplasma-wayland ;;
          esac
        fi
      fi
    '';
  };
}
