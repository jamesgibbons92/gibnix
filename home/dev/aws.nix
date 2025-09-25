{pkgs, ...}: {
  programs.awscli = {
    enable = true;
    # settings = {
    #   "default" = {
    #     region = "eu-west-2";
    #     output = "json";
    #   };
    # };
  };

  home.packages = with pkgs; [
    ssm-session-manager-plugin
    amazon-ecr-credential-helper
  ];
}
