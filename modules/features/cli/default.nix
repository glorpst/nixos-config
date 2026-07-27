{ self, ... }: {
  flake.nixosModules.cli = { pkgs, ... }: {
    imports = [
      self.nixosModules.zsh
    ];

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
      self.packages.${pkgs.stdenv.hostPlatform.system}.myTmux
      self.packages.${pkgs.stdenv.hostPlatform.system}.tmux-sessionizer
    ];
  };
}
