{pkgs, ...}: let
  tomlFormat = pkgs.formats.toml {};
in {
  xdg.configFile."herdr/config.toml".source = tomlFormat.generate "herdr-config.toml" {
    onboarding = false;

    theme.name = "tokyo-night";

    terminal = {
      default_shell = "zsh";
      new_cwd = "follow";
    };

    keys = {
      prefix = "alt+space";

      split_vertical = "alt+|";
      split_horizontal = "alt+-";

      resize_pane_left = ["ctrl+alt+h" "ctrl+alt+left"];
      resize_pane_down = ["ctrl+alt+j" "ctrl+alt+down"];
      resize_pane_up = ["ctrl+alt+k" "ctrl+alt+up"];
      resize_pane_right = ["ctrl+alt+l" "ctrl+alt+right"];

      focus_pane_left = ["alt+h" "alt+left"];
      focus_pane_down = ["alt+j" "alt+down"];
      focus_pane_up = ["alt+k" "alt+up"];
      focus_pane_right = ["alt+l" "alt+right"];
    };

    ui.toast = {
      delivery = "system";
      delay_seconds = 3;
    };

    update = {
      version_check = false;
      manifest_check = false;
    };
  };
}
