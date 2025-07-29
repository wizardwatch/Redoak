{ config, pkgs, lib, trunk, home-manager, self, inputs, ... }:
{
  
  boot.kernelModules = ["macvtap"];
    networking.macvlans.lan = {
      interface = "eno1np0";

      mode = "bridge";
    };
  networking = {
    hostName = "redoak";
    networkmanager.enable = false;

    # disable ipv6 because it is COOKED
    enableIPv6 = false;

    # Disable global dhcp as this by default uses networkmanager.
    # Normally you can override this with useNetworkd, but
    # https://nixos.wiki/wiki/Systemd-networkd recomends against
    # setting useNetworkd to true if the network is configured within
    # systemd.network, which it is here. 
    useDHCP = false;
    firewall = {
      allowedTCPPorts = [ 27036 27037 80 443 22];
      allowedUDPPorts = [ 27031 27036 67 ];
    };
  };
  systemd.network = {
    enable = true;
    ###
    ### Connection to LAN
    ###
    networks."30-eno1np1" = {
      matchConfig.Name = "eno1np1";
      networkConfig = {
        DHCP = "ipv4";
        DNS = [ "1.1.1.1" ];
      };
      linkConfig.RequiredForOnline = "routable";
    };
    ###
    ### Container Networking
    ###

  };
  ###
  ### ACME
  ###
  /*security.acme = {
    acceptTerms = true;
    defaults.email = "wyatt.osterling@hotmail.com";
    certs."genchumeni.com" = {
      dnsProvider = "namecheap";
      domain = "genchumen.com";
      credentialFiles = {
        "NAMECHEAP_API_KEY_FILE" = "/etc/acme_key";
        "NAMECHEAP_API_USER_FILE" = "/etc/acme_user";
      };
    };
  };*/

}
