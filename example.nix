{ pkgs ? import ./nix {} }:

let
  neovim = import ./default.nix { lib = pkgs.lib; neovim = pkgs.neovim; };
  vimPlugins = pkgs.vimPlugins;
in
  neovim.override {
    withNodeJs = true;
    configure = {
      customRC = ''
      "from customrc
      '';
      packages = {
        a = {
          start = [
            {
              plugin = vimPlugins.vim-tmux-navigator;
              vimrc = ''
                "package a. start. plugin 1 
              '';
            }
          ];
          opt = [
            {
              plugin = vimPlugins.vim-commentary;
              vimrc = ''
              "package a. opt. plugin 2
              '';
            }
          ];
        };
        b = {
          start = [
            vimPlugins.syntastic
            {
              plugin = vimPlugins.nerdtree;
              vimrc = ''
              "package b. start. plugin 3
              '';
            }
          ];
          opt = [
            {
              plugin = vimPlugins.tagbar;
              vimrc = ''
              "package b. opt. plugin 4
              '';
            }
          ];
        };
      };
      plug.plugins = [ 
        vimPlugins.vim-gitgutter
        { 
          plugin = vimPlugins.ale; 
          vimrc = '' 
          "vim plug. plugin 5
          '';
        }
      ];
    };
    }
  

