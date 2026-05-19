{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nvf, ... } @ inputs:
    let
      sysUser = "glorpst"; # change per system user
    in {
    nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem { # change nixosConfig.x to host name
      specialArgs = { inherit inputs sysUser; };
      modules = [
        ./hosts/nixos-vm/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
