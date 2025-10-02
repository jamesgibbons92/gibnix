{
  config,
  pkgs,
  ...
}: {
  programs.lazydocker.enable = config.virtualisation.docker.enable or false;

  home.packages = with pkgs; [
    devenv
  ];
}
