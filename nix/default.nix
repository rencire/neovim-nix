{ sources ? import ./sources.nix }:
let
  unstable = import sources.nixpkgs-unstable {};

  # use unstable version of packages
  overlay = selfpkgs: superpkgs:
    { 
      lefthook = unstable.lefthook;
      neovim = unstable.neovim; 
      vimPlugins = unstable.vimPlugins; # using unstable since it has working coc plugins
    };

  nixpkgs = import sources.nixpkgs-stable
    { 
      overlays = [ overlay ];
      config = {};
    };
in
  nixpkgs

