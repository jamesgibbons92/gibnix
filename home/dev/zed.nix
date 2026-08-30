
{pkgs, ...}: {
  imports = [
  ];

  home.packages = with pkgs; [
    zed-editor
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
  };
}
