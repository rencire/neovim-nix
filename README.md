# Neovim Nix

This is a nix package of neovim, with a slight enhancement to the override api.  This adds the ability to organize `vimrc` at the "plugin attribute set" level.

# Quick Start

## Niv (recommended)
In a [niv][] project:

```bash
niv init try-neovim
niv add rencire/neovim.nix
cd try-neovim
```

`try-neovim/default.nix`
```
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
  sources.neovim.override {
    configure = {
      customRC = ''
	set number
      '';
      packages.main = with pkgs.vimPlugins; [
        start = [
          
          { 
            plugin = ;
            vimrc = ''
              "Specific vimrc config for plugin 1
            '';
          }
        ];
      }
  }

```








# Interface

Before:
```
{pkgs ? import <nixpkgs>}:

with pkgs;

neovim.override {
  configure = {
    customRC = ''
      "General vimrc config

      "Specific vimrc config for plugin 1

      "Specific vimrc config for plugin 2

      "Specific vimrc config for plugin 3

      "Specific vimrc config for plugin 4
    '';
    packages.main = with vimPlugins; {
      start = [
        plugin-0-deriv
        plugin-1-deriv
        plugin-2-deriv
      ];
      opt = [ plugin-3-deriv ]
    };
    plug.plugins = with vimPlugins; [
      plugin-4-deriv
    ];
  };
}
```

After:

```
{pkgs ? import <nixpkgs>}:

with pkgs;

neovim.override {
  configure = {
    customRC = ''
      "General vimrc config
    '';
    packages.main = with vimPlugins; [
      start = [
        plugin-0-deriv
        { 
          plugin = plugin-1-deriv;
          vimrc = ''
            "Specific vimrc config for plugin 1
          '';
        }
        { 
          plugin = plugin-2-deriv;
          vimrc = ''
            "Specific vimrc config for plugin 2
          '';
        }
      ];
      opt = [
        { 
          plugin = plugin-3-deriv;
          vimrc = ''
            "Specific vimrc config for plugin 3
          '';
        }
      ];
    ];

    plug.plugins = with vimPlugins; 
      [
        { 
          plugin = plugin-4-deriv;
          vimrc = ''
            "Specific vimrc config for plugin 4
          '';
        }
      ];
  };
}
```





# Notes

```
neovim.override {
  ... # can still override top level fields of attribute set
  configure = {

    # Vim Plug plugins
    plug.plugins = [];

    # Native vim plugins
    packages.BasePackage = {
      start = [
        <plugin-1>
	{
	  plugin = plugin2;
	  vimrc = ''
	    <insert vimrc for this plugin here>
	  '';
	}
      ];
      opt = [];
    };

  };
}


```

```
plugins = [
  <plugin_deriv>
  {
    plugin = <plugin_deriv>;
    vimrc = ''
      <insert vimscript specific to plugin here>
    '';
  }
  ...
]

```

# TODO

- [x] create initial interface for specifying plugins
- [] doc: formalize plugin grammar
- [x] feat: vimrc from 'packages' generated in order of declaration (ordered via package attribute name).
  - to debug generated vimrc: nix-build example.nix && ./result/bin/nvim +scr1
- [x] fix: extra leading whitespace in vimrc declared in configuration
- [x] feat: vimrc from 'vimPlug'
- [] doc: add quick start


# Development

## 0) Prerequisites

- [Nix](https://nixos.org/nix/)
- [Niv](https://github.com/nmattia/niv)
- [direnv](https://github.com/direnv/direnv) (optional)
  - allows auto loading packages when navigating to this directory
  - can install via nix: `nix-env -i direnv`

## 1) Update nixpkgs version to latest branch.

linux:

```
niv update nixpkgs -b nixpkgs-19.09
```

macos:

```
niv update nixpkgs -b nixpkgs-19.09-darwin
```

## 2) Add project packages

If package is available in nix, add it to `shell.nix`

```bash
with import ./nix;
  mkShell {
    buildInputs = [
      lefthook # for managing git hooks
      <insert pkg1 here>
      <insert pkg2 here>
    ];
  }
```

## 3) Install packages

With `direnv` installed:

1. Uncomment `use_nix` line in `.envrc`.
2. Enable direnv:

```
direnv allow
```

Alternatively, without using `direnv`, just use `nix-shell`:

```
nix-shell
```

## 4) Setup git hooks

Run:

```
lefthook install
```


