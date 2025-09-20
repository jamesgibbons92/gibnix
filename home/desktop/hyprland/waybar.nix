{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = lib.importJSON ./config.jsonc;
    style = builtins.readFile ./style.css;
  };

  home.packages = with pkgs; [
  ];

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
