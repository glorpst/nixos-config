{ self, inputs, ... }: {

  flake.nixosConfigurations.bmo = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.nixosModules.laptopConfiguration
    ];
  };

}
