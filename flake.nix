{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #sops-nix.url = "github:Mic92/sops-nix";
/*    trunk = {
      url = "github:wizardwatch/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
    /*home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
/*    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };*/
  };
  outputs = 
    { self
    , nixpkgs
    #, trunk
    #, home-manager
    #, sops-nix
    #, microvm
    , ...
    }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        # imports the system variable
        inherit system;
        # enable non free packages
        config = {
          allowUnfree = true;
        };
      };
    in{
    nixosConfigurations.redoak = nixpkgs.lib.nixosSystem{
      system = "x86_64-linux";
      specialArgs = { 
        inherit self;
        inherit inputs;
      };
      modules =
        [
          #microvm.nixosModules.host
          #sops-nix.nixosModules.sops
          #home-manager.nixosModules.home-manager
          #(trunk.nixosModules.common)
          (import ./main.nix)
          (import ./unixStuff/hardware.nix)
          /*({ pkgs, lib, ... }: {
            home-manager = {
              extraSpecialArgs = {
                inherit self;
                inherit inputs;
                inherit system;
              };
              useUserPackages = true;
              users.willow = pkgs.lib.mkMerge [
                #(trunk.nixosModules.userZshStarship)
                (import ./home.nix)
              ];
            };
          })*/
        ];
    };
  };
}
