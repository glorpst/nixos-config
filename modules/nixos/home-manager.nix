{ inputs, outputs, sysUser, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs sysUser; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}
