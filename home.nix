{ config, pkgs, lib, home-manager, inputs, system, ... }:
{
  home = {
    stateVersion = "23.11";
    username = "willow";
    homeDirectory = lib.mkForce "/home/willow/";
  };
  imports = [
    ./programs/helix_theme.nix
  ];
  programs = {
   helix = {
      enable = false;
      settings = {
      theme = "catppuccin_mocha";
        editor = {
          auto-save = true;
          true-color = true;
          color-modes = true;
          cursorline = true;
          completion-replace = true;
          soft-wrap.enable = true;
          idle-timeout = 1;
          gutters = ["diff" "diagnostics" "line-numbers" "spacer"];
          statusline = {
            left = ["mode" "spinner"];
            center = ["file-name"];
            right = ["diagnostics" "selections" "position" "file-line-ending" "file-type" "version-control"];
            separator = "|";
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            render = true;
            rainbow = "dim";
            character = "┆";
          };
          whitespace = {
            characters = {
              space = "·";
              nbsp = "⍽";
              tab = "→";
              newline = "⏎";
              tabpad = "·";
            };
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
        };
      };
    };
  };
}
