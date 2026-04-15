{pkgs, ...}: {
  home.packages = with pkgs; [
  ];

  xdg.desktopEntries.steam-gamescope = {
    name = "Steam (Gamescope)";
    exec = "steam-gamescope";
    icon = "steam";
    comment = "Launch Steam Big Picture inside Gamescope";
    terminal = false;
    type = "Application";
    categories = ["Game"];
  };
}
