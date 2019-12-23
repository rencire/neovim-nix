{ sources ? import ./sources.nix }:
let
  overlay = selfpkgs: superpkgs:
      { sources = sources;
        lefthook = superpkgs.callPackage ./lefthook.nix {}; 
      };
in
  import sources.nixpkgs
    { overlays = [ overlay ] ; config = {}; }

