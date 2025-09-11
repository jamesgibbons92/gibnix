{ config, pkgs, lib, hostName, ... }:

{
  system = { };
  home = { config, pkgs, lib, ... }: {
    programs.ssh.enable = true;
    home.activation.generateSSHKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        echo "Generating SSH key..."
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "${config.home.username}@${hostName}" -f "$HOME/.ssh/id_ed25519" -N ""
      fi
    '';
  };
}

