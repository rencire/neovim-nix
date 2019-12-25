{ pkgs ? import ./nix {} }:
with pkgs;
  let
    neovim = import ./default.nix {};
  in
    neovim.override {
      configure = {
        customRC = ''
          "from customrc
        '';
        packages.a = {
          start = [
            {
	      plugin = vimPlugins.vim-tmux-navigator;
	      vimrc = '' "package a. start. plugin 1 \
	      "fdafd
	      '';
	    }
          ];
          opt = [
            {
	      plugin = vimPlugins.vim-commentary;
	      vimrc = ''
	        "package a. opt. plugin 1
	      '';
	    }
          ];
        };
        packages.b = {
          start = [
	    vimPlugins.syntastic
            {
	      plugin = vimPlugins.nerdtree;
	      vimrc = ''
	        "package b. start. plugin 1
	      '';
	    }
          ];
          opt = [
            {
	      plugin = vimPlugins.tagbar;
	      vimrc = ''
	        "package b. opt. plugin 1
	      '';
	    }
          ];
        };
      };
    }
  

