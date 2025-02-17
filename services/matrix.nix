{config, pkgs, lib, ...}: 
let 
  # Keep the case the same, need to avoid recursion
  aSecret  = "Im Owen's himbo sword boyfriend now I guess";
  minPort = 49000;
  maxPort = 50001;
  baseURL = "matrix.genchumen.com";
in {
  # inherit asecret min-port max-port;
  # enable coturn
  services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = minPort;
    max-port = maxPort;
    use-auth-secret = true;
    static-auth-secret = aSecret;
    realm = "turn." + baseURL;
    cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
    pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
    extraConfig = ''
      # for debugging
      verbose
      # ban private IP ranges
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    '';
  };
  # open the firewall
  networking.firewall = {
    interfaces.enp2s0 =
    let range = [ {
        from = minPort;
        to = maxPort;
    } ];
    in
    {
      allowedUDPPortRanges = range;
      allowedUDPPorts = [ 3478 5349 ];
      allowedTCPPortRanges = [ ];
      allowedTCPPorts = [ 3478 5349 ];
    };
  };
  /*
  # get a certificate
  security.acme.certs.${config.services.coturn.realm} = {
    # insert here the right configuration to obtain a certificate
    postRun = "systemctl restart coturn.service";
    group = "turnserver";
  };*/
  services.conduwuit = {
    enable = true;
    settings = {
      global = {
        server_name = "matrix.genchumen.com";
      };    
    };
  };
  /*# configure synapse to point users to coturn
  services.matrix-synapse.settings = with config.services.coturn; {
    turn_uris = ["turn:${realm}:3478?transport=udp" "turn:${realm}:3478?transport=tcp"];
    turn_shared_secret = static-auth-secret;
    turn_user_lifetime = "1h";
  };*/
}
