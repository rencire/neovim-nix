# Notes

## Interface

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

# Base Starter w/ Nix

# Setup

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

Also see `lefthook.yml.sample` for a template of git hooks.

## 5) Add License

Dont' forget to add a license to your project. By default, an MIT license is provided; add your name to it.

## 6) Keep configuring, or start developing!
