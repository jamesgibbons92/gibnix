{
  config,
  lib,
  pkgs,
  ...
}: let
  # Wrap Steam to strip PrefersNonDefaultGPU and X-KDE-RunOnDiscreteGpu
  # from its desktop entries. These properties cause Steam windows to fail
  # to render when launched via app launchers (Walker/Wofi/Rofi) on
  # Hyprland + XWayland. Terminal launches bypass the .desktop file and
  # are unaffected.
  # Ref: https://bbs.archlinux.org/viewtopic.php?id=300993
  steamBase = pkgs.steam.override {
    extraEnv = {};
  };

  steamPatched = steamBase.overrideAttrs (prev: {
    postInstall =
      (prev.postInstall or "")
      + ''
        find $out/share/applications -name '*.desktop' -exec \
          sed -i \
            -e '/^PrefersNonDefaultGPU/d' \
            -e '/^X-KDE-RunOnDiscreteGpu/d' \
            {} +
      '';
  });
in {
  hardware.steam-hardware.enable = true;
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = steamPatched;
      gamescopeSession.enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    vulkan-tools # vkcube, vulkaninfo for debugging
    vulkan-loader
  ];

  # NVIDIA + Proton/DXVK environment variables for better UE5 compatibility
  environment.sessionVariables = {
    # Enable NVIDIA API for better game compatibility
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";

    # Shader disk cache (prevents recompilation on every launch)
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

    # DXVK async shader compilation (reduces stuttering)
    DXVK_ASYNC = "1";
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };
  services.sunshine.package = pkgs.sunshine.override {
    cudaSupport = true;
    cudaPackages = pkgs.cudaPackages;
    boost = pkgs.boost187; # https://github.com/NixOS/nixpkgs/pull/493384
  };
}
