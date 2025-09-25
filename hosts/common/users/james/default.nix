{
  pkgs,
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # users.mutableUsers = false;
  users.users.james = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "audio"
      "docker"
      "git"
      "network"
      "networkmanager"
      "wheel"
    ];

    # openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/james/ssh.pub);
    # hashedPasswordFile = config.sops.secrets.james-password.path;
    packages = [pkgs.home-manager];
  };

  services.getty = {
    autologinOnce = true;
    autologinUser = "james";
  };

  # sops.secrets.james-password = {
  #   sopsFile = ../../secrets.yaml;
  #   neededForUsers = true;
  # };

  home-manager.users.james = {
    imports = [
      ../../../../home/hosts/${config.networking.hostName}.nix
    ];

    _module.args = {inherit pkgs-unstable;};
  };
}
