{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nvf, ... } @ inputs:
    let
      sysUser = "peebs"; # change per system user
    in {
    nixosConfigurations = {
        # Host: NixOS VM
        nixos-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs sysUser; };
          modules = [
            ./hosts/nixos-vm/configuration.nix # change file path to match hosts/ dir name
            inputs.home-manager.nixosModules.default
          ];
        };

        # Host: Laptop
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs sysUser; };
          modules = [
            ./hosts/laptop/configuration.nix # change file path to match hosts/ dir name
            ./hosts/laptop/disko-config.nix
            inputs.home-manager.nixosModules.default
            inputs.disko.nixosModules.default
          ];
        };
    };
  };
}
