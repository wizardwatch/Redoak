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
        DNS = [ "192.168.1.146" "1.1.1.1" ];
      };
      linkConfig.RequiredForOnline = "routable";
    };
    ###
    ### Container Networking
    ###
    /*
    networks = {
      "20-eno1np0" = {
        matchConfig.Name = "eno1np0";
      };
      
      "10-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCPServer = true;
          IPv6SendRA = true;
        };
        addresses = [ {
          addressConfig.Address = "10.0.0.1/24";
        } {
          addressConfig.Address = "fd12:3456:789a::1/64";
        } ];
        ipv6Prefixes = [ {
          ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
        } ];
      };
      "11-lan" = {
        matchConfig.Name = ["vm-*"];
        networkConfig = {
          Bridge = "br0";
        };
      };
    };
    netdevs = {
     "10-br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };*/
  };
}
