{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./locale.nix
    ./stylix.nix
    # system packages/programs...
  ];

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  boot.loader.systemd-boot.configurationLimit = 5;

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    unzip
  ];

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5";
    };
  };
  nix.settings = {
    trusted-users = ["root" "james"];
    experimental-features = ["nix-command" "flakes"];
  };

  security.wrappers.nethogs = {
    source = "${pkgs.nethogs}/bin/nethogs";
    capabilities = "cap_net_admin,cap_net_raw,cap_dac_read_search,cap_sys_ptrace+ep";
    owner = "root";
    group = "root";
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=60
  '';
}
