{
  description = "My custom Neovim setup";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.neovim.url = "github:neovim/neovim?dir=contrib";
  inputs.neovimConfigureWrapper.url = "github:rencire/neovim-nix";

  outputs = { self, flake-utils, nixpkgs, neovim, neovimConfigureWrapper }: 
    flake-utils.lib.eachDefaultSystem (system:
      with nixpkgs.legacyPackages.${system};
        let
	  neovim-unwrapped = neovim.defaultPackage.${system};
          wrapNeovimConfigure = neovimConfigureWrapper.wrapNeovimConfigure.${system};
          neovim-wrapped = wrapNeovimConfigure (pkgs.wrapNeovim neovim-unwrapped {}); 
        in
          {
            defaultPackage = neovim-wrapped.override {
              withNodeJs = true;
              configure = {
                customRC = ''
		" Insert custom vimrc settings here
		'';
                packages.main = {
                  start = [
	            {
	              plugin = surround;
	              vimrc = ''
	              "specific config for surround plugin
                      '';
	            }
                    {
                      plugin = vim-commentary;
		      vimrc = ''
		      "config for vim-commentary
		      '';
                    }
		    { 
		      plugin = coc-nvim;
		    }
		    { 
		      plugin = coc-tsserver; 
		      settings = {
		        "tsserver.log" = "verbose";
		      };
		    }
		  ]
                };
		plug.plugins = [];
              };
            };
          }
    );
      
}

