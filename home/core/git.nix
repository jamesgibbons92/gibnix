{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "James";
    userEmail = "jay.m.gibbons@gmail.com";
  };

  programs.lazygit = {
    enable = true;
  };
}
