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
}
