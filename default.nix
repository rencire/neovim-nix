{ pkgs ? import ./nix {} }:

with pkgs;

  let
    utils = callPackage ./utils.nix {};
  
    # Preprocesses args before passing in to `neovim.override`.
    #
    # Essentially, it translates our vim plugin schema to one accepted by `neovim.override`.
    # Currently all it does is remove `vimrc` from plugin lists, and combines them in `customRC`.
    wrapper = {
      ...
    } @args:
  
    let

      # Will sort packages via package name alphbetically.  This is default behavior of `lib.attrValues`.
      # - Structure of `packagesList`:
      # [
      #   # package one
      #   {
      #     start = [...];
      #     opt = [...];
      #   }
      #   # package two
      #   {
      #     ...
      #   }
      #   ...
      # ]
      packagesList = 
        lib.attrValues 
	  # return empty set of path does not exist
	  (lib.attrByPath ["configure" "packages"] {} args)  
      ;

      # - Structure of `pluginsList`:
      # [
      #   <plugin 1>
      #   {
      #     plugin = <plugin 2>;
      #     vimrc = ...;
      #   }
      #   ...
      # ]
      pluginsList = 
        lib.flatten
          (map 
            ( pkg: (pkg.start or []) ++ (pkg.opt or []) )
            packagesList)
      ;

      # Grab all the vimrc from 'start' and 'opt' for each packages.'<package_name>'
      #
      # Vimrc will be ordered alphabetically via package name in the override config.
      # i.e.; vimrc from plugins in `packages.a` will come before `packages.b`.
      customRC = 
        utils.combineVimRC 
	  pluginsList 
          (lib.attrByPath ["configure" "customRC"] "" args)
      ;

      # Implementation assumes:
      # - "start" and "opt" attributes are not of type Attribute Set (currently are Lists).
      # - If each item in "start" and "opt" list is an Attribute Set, assume it has "plugin" attribute
      #    with the corresponding plugin derivation as value.  Else, assume the item itself is the plugin derivation.
      packages = lib.mapAttrsRecursive
        (path: value: 
	  (map 
	    (p: if  (lib.isAttrs p) && !(lib.isDerivation p) 
		then p.plugin
		else p)
	    value))
        (lib.attrByPath ["configure" "packages"] {} args)
      ;


      # TODO handle vimPlug case later
      # plugPlugins = ;
  
      # Create a duplicate args tree structure with our new values.
      newArgs = {
        configure = {
          inherit customRC packages;
          # plug.plugins = plugPlugins;
        };
      };

      # Recursively merge new args with existing args
      overrides = lib.recursiveUpdate args newArgs; 

    in
      neovim.override overrides;

  in
    lib.makeOverridable wrapper {}

