{config, ...}: {
  programs.lazydocker.enable = config.virtualisation.docker.enable or false;
}
