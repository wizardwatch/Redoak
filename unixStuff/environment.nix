{ config, pkgs, lib, trunk, home-manager, self, inputs, ... }:
{
  programs = {
    zsh.enable = true;
  };
  #       #
  # fonts #
  #       #
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Nerd Font" ];
        serif = [ "Iosevka Etoile" ];
        sansSerif = [ "Iosevka Aile" ];
      };
    };
  };
}
