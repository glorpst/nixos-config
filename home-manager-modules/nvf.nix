{ config, pkgs, ... }: 

{
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        globals.mapleader = " ";

        viAlias = false;
        vimAlias = true;

        lsp.enable = true;
        languages = {
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
        };

        theme = {
          enable = true;
          name = "tokyonight";
          style = "storm";
        };

        options = {
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;

          mouse = "a";

          colorcolumn = "100";
          wrap = false;
        };

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
          { key = "<Space>"; mode = ["n" "v"]; action = "<Nop>"; silent = true; }
          { key = "<leader>e"; mode = "n"; action = ":Oil<CR>"; silent = true; }
          { key = "<leader>nt"; mode = "n"; action = ":Neotree toggle<CR>"; silent = true; }
        ];

        luaConfigRC.user-init = ''
          vim.opt.rtp:prepend("${config.home.homeDirectory}/nixos/config/nvim")
          dofile("${config.home.homeDirectory}/nixos/config/nvim/init.lua")
        '';
      };
    };
  };
}
