{ lib, pkgs }:

{
  system = { };

  home = { ... }: {
    programs.git = {
      enable = true;
      userName = "James";
      userEmail = "james@example.com";
    };
  };
}

