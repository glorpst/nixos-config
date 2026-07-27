{ inputs, ... }: {
  perSystem =
    { pkgs, system, ... }:
    let
      myNeovim = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            config.vim = {
              globals.mapleader = " ";
              viAlias = false;
              vimAlias = true;

              # lsp
              lsp.enable = true;
              languages = {
                enableTreesitter = true;
                nix.enable = true;
                java.enable = true;
                typescript.enable = true;
                odin.enable = true;
                clang.enable = true;
                rust = {
                  enable = true;
                  extensions.crates-nvim.enable = true;
                };
              };

              debugger.nvim-dap = {
                enable = true;
                ui.enable = true;
              };

              theme = {
                enable = true;
                name = "tokyonight";
                style = "storm";
                transparent = true;
              };

              options = {
                tabstop = 2;
                shiftwidth = 2;
                expandtab = true;
                mouse = "a";
                clipboard = "unnamedplus";
                colorcolumn = "100";
                wrap = false;
              };

              autopairs.nvim-autopairs.enable = true;
              binds.whichKey.enable = true;
              statusline.lualine.enable = true;
              telescope.enable = true;
              autocomplete.nvim-cmp.enable = true;
              git.gitsigns.enable = true;

              filetree.neo-tree = {
                enable = true;
                setupOpts = {
                  close_if_last_window = true;
                  window.width = 30;
                };
              };

              extraPlugins = with pkgs.vimPlugins; {
                oil-nvim = {
                  package = oil-nvim;
                  setup = "require('oil').setup()";
                };
              };

              keymaps = [
                {
                  key = "<Space>";
                  mode = [
                    "n"
                    "v"
                  ];
                  action = "<Nop>";
                  silent = true;
                }
                {
                  key = "<leader>e";
                  mode = "n";
                  action = ":Oil<CR>";
                  silent = true;
                }
                {
                  key = "<leader>nt";
                  mode = "n";
                  action = ":Neotree toggle<CR>";
                  silent = true;
                }
              ];

              luaConfigRC.user-init = builtins.readFile ../../../config/nvim/init.lua;
            };
          }
        ];
      };
    in
    {
      packages.myNeovim = myNeovim.neovim;
    };
}
