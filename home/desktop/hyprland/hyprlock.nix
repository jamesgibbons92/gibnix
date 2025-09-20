{
  lib,
  config,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ./hyprlock.conf;
    importantPrefixes = [
      "$"
    ];
  };

  wayland.windowManager.hyprland = {
    settings = let
      hyprlock = lib.getExe config.programs.hyprlock.package;
    in {
      bind = [
        "$mainMod,L,exec,${hyprlock}"
      ];
      bindl = [
        ",switch:off:Lid Switch,exec,${hyprlock} --immediate"
      ];
    };
  };
}
