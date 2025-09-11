{ config, pkgs, lib, username, ... }: 
let
  git = import ./git.nix { inherit pkgs lib; };
  nvim = import ./nvim.nix { inherit pkgs lib; };
  ssh = import ./ssh.nix { inherit config pkgs lib; hostName = config.networking.hostName; };
  tools = import ./tools.nix { inherit pkgs lib; };
in {

  imports = [
    git.system
    nvim.system
    ssh.system
    tools.system
  ];

  home-manager.users.${username} = { 
    imports = [
      git.home
      nvim.home
      ssh.home
      tools.home
    ];
  };
}

