{ config, pkgs, lib, trunk, home-manager, self, inputs, microvm, ... }:
let 
baseConfig = {
  microvm = {
    hypervisor = "cloud-hypervisor";
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    
      {
        tag = "home";
        source = "home";
        mountPoint = "/home";
      }
    ];
  };
  system.stateVersion = "24.11";
};

# Use Traefik instead TODO: Write a base config for a share for the cert
# Use traefik instead TODO: Setup ACME with DNS as a wildcard
# TODO: Setup conduwuit with the cert
# TODO: Test
# TODO: Port forward
# TODO: Test
# TODO: Celebrate
in

{
  systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
  microvm = {
    autostart = [
      "traefik"
    ];

    vms = {

      traefik = {
        pkgs = pkgs;
        config = baseConfig // {
         microvm.interfaces = [{
            type = "macvtap";
            id = "vm-traefik";
            macvtap = {
              link = "eno1np1";
              mode = "bridge";
            };
            mac = "02:00:00:00:00:04";
          }];
         } // import ./traefik.nix;  
      };
      
      matrix = {
        pkgs = pkgs;
        config = baseConfig // {
         microvm.interfaces = [{
            type = "macvtap";
            id = "vm-matrix";
            macvtap = {
              link = "eno1np1";
              mode = "bridge";
            };
            mac = "02:00:00:00:00:06";
          }];
         } // import ./matrix.nix;  
      };
      
    }; 
  };
}
