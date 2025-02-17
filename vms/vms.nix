{ config, pkgs, lib, trunk, home-manager, self, inputs, microvm, ... }:
let 
baseConfig = {
  microvm = {
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

    vms = {/*
      matrix = {
        pkgs = pkgs;
        config = baseConfig // {      
          microvm.shares = [{
            proto = "virtiofs";
            tag = "acme";
            #source = "/var/lib/microvms/acme";
            source = "/home/willow/cool";
            mountPoint = "/var/lib/traefik";
          }];
          microvm.interfaces = [{
            type = "tap";
            id = "vm-test1";
            mac = "02:00:00:00:00:01";
          }];
        } // import ./matrix.nix;
      };*/
      traefik = {
        pkgs = pkgs;
        config = baseConfig // {
           
        users.users.root.password = "toor";
          services.openssh = {
            enable = true;
            settings.PermitRootLogin = "yes";
         };
         microvm.interfaces = [{
            type = "macvtap";
            id = "vm-traefik";
            macvtap = {
              link = "eno1np1";
              mode = "bridge";
            };
            mac = "02:00:00:00:00:04";
          }];
                    microvm.hypervisor = "cloud-hypervisor";
         } // import ./traefik.nix;  
      };
    }; 
  };
}
