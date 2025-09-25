{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin # UI tool so maybe doesn't belong here.
  ];
}
