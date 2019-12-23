with import ./nix {};
  mkShell { 
    buildInputs = [ 
      lefthook
    ];
  }
