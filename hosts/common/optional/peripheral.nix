{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    yubioath-flutter
  ];
}
