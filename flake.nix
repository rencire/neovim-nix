{
  description = "Wrap Neovim Configuration";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          wrapNeovimConfigure = import ./. {inherit (pkgs) lib;};
        }
    );

}
