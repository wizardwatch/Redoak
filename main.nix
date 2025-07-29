{ config, pkgs, lib, trunk, home-manager, self, inputs, microvm, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
         "zerotierone"
   ];
  imports = [
    ### Basic Settings and Config
    ### You Know
    ### unixStuff
    ./unixStuff/users.nix
    ./unixStuff/environment.nix
    ./unixStuff/extraHardware.nix
    ./unixStuff/networking.nix
    ###
    ### Programs, it's in the name
    ###
    #./programs/cyberSecurity.nix
    ./programs/main.nix
    ### These Programs run for longer
    ### Thus wanted a special dir
    ###
    ./services/services.nix
    ### I Would Tell You Whats in Here
    ### But it's a Secret
    ###
    #./secrets/secrets.nix ## We emulate another computer
    ### because we couldn't trust these programs
    ### and emulated computers don't have rights
    #./vms/vms.nix
  ];
  environment.systemPackages = with pkgs; [
    #sshfs
    #tree
    #gcc
    #jq
    #tokei
    #age
    #ssh-to-age
    #sops
    #nix-index
    vim
    #starship
    python3
  ];
  security.rtkit.enable = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      
    '';
  };
  time.timeZone = "America/New_York";
  virtualisation = {
    docker = {
      enable   = true;
      daemon.settings = {
        data-root = "/home/dockerFolder/";
      };
    };
    waydroid.enable = false;
    lxd.enable      = false;
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05";
}
