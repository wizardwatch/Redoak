{
  config,
  pkgs,
  lib,
  trunk,
  home-manager,
  self,
  inputs,
  ...
}:
{
  users = {
    users.wyatt = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "dialout"
      ];
      shell = pkgs.zsh;
      initialPassword = "mount"; # config.sops.secrets.wyattPassword.path;
    };
    users.willow = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "mount";
      openssh.authorizedKeys.keyFiles = [
        ./keys/willow.pub
        ./keys/willow-willow.pub
      ];
    };
    users.dockerFolder = {
      isNormalUser = false;
      isSystemUser = true;
      group = "dockerAccess";
    };
    users.ryleu = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      initialPassword = "";
      openssh.authorizedKeys.keyFiles = [
        ./keys/ryleu-rectangle.pub
        ./keys/ryleu-wendys_public_wifi.pub
        ./keys/ryleu-mathrock.pub
      ];
      shell = pkgs.zsh;
    };
    users.media = {
      isNormalUser = false;
      isSystemUser = true;
      createHome = false;
      shell = pkgs.zsh;
      password = "mount";
      group = "media";
      uid = 993;
    };
    groups = {
      dockerAccess = { };
      media = {
        gid = 992;
        members = [
          "willow"
          "ryleu"
        ];
      };
    };
  };
}
