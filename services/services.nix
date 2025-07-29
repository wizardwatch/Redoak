{ config, pkgs, lib, trunk, home-manager, self, inputs, ... }:
{
  imports = [
    #./matrix.nix
  ];

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    
    fstrim.enable = true;
  };
  services.zerotierone = {
    #enable = true;
    joinNetworks = [
      "3efa5cb78a1171d9"
    ];
  };

  services.tailscale.enable = true;
}
