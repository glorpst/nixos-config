{ inputs, ... }: {

  perSystem =
    { pkgs, ... }:
    {
      packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia.wrap {
        inherit pkgs;
        settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
      };
    };

}
