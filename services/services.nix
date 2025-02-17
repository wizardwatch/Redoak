{ config, pkgs, lib, trunk, home-manager, self, inputs, ... }:
{
  imports = [
    #./matrix.nix
  ];

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };/*
    nextcloud = {
      enable = true;
      hostName = "nextcloud.localhost";
      home = "/network/nextcloud";
      config = {
        adminpassFile = "/etc/nextcloud_pass_file";
        extraTrustedDomains = ["192.168.1.214"];
      };
    };*/
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
  };
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "3efa5cb78a1171d9"
    ];
  };
}
