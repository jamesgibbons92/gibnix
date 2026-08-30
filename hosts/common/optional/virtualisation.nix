{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    kubectl
    k9s
    sops
  ];
}
