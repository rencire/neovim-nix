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
        cocPlugins = {
          start = [
	    { 
	      plugin = vimPlugins.coc-nvim;
	    }
	    { 
	      plugin = vimPlugins.coc-tsserver; 
	      settings = {
	        "tsserver.log" = "verbose";
	      };
	    }
          ];
	};
      };
    };
  }
  

