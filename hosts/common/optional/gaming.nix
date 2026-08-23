{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
    };
    gamemode = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    vulkan-tools # vkcube, vulkaninfo for debugging
    vulkan-loader
  ];

  # services.sunshine = {
  #   enable = true;
  #   autoStart = true;
  #   capSysAdmin = true;
  #   openFirewall = true;
  # };
  #
  # services.sunshine.package = pkgs.sunshine.override {
  #   cudaSupport = true;
  #   cudaPackages = pkgs.cudaPackages;
  #   boost = pkgs.boost187; # https://github.com/NixOS/nixpkgs/pull/493384
  # };
}
