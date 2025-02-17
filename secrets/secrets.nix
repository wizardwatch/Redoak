{ config, pkgs, lib, trunk, home-manager, self, inputs, ... }:
{  
  sops.defaultSopsFile = ./ekeys.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops = {
    secrets = {
    /*
      nextcloud_pass = {
        owner = config.users.users.nextcloud.name;
        path = "/etc/nextcloud_pass_file";
      };*/
    };
  };
}
