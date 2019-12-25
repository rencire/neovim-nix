{ pkgs ? import ./nix {} }:

with pkgs;

  let
    utils = import ./utils.nix {inherit (pkgs) lib;};
  
    wrapper = {
      ...
    } @args:
  
    let
      # for each package listed in `configure.packages`, transform the plugin format to be compatible with nixpkgs's neovim derivation.
  
      # for start and opt, 
      #   - return { pluginsList, vimrc }

      # packagesList:
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
      #
      # TODO need better mechannism to handle default values?
      packagesList = 
        lib.attrValues 
	  # return empty set of path does not exist
	  (lib.attrByPath ["configure" "packages"] {} args)  
      ;

      # TODO don't want to do this, want to keep order of packages in vimrc
      # Group of all plugins from all packages, grouped by 'start' and 'opt'
      # {
      #   start = [...];
      #   opt = [..];
      #   ...
      # }
      pluginsAttrSet = lib.foldAttrs (val: accum: val ++ accum ) [] packagesList;

      # full plugins list
      # [
      #   <plugin derivation>
      #   {
      #     plugin = <plugin derivation>;
      #     vimrc = "..."; 
      #   }
      #   ...
      # ]
      pluginsList = (pluginsAttrSet.start or []) ++ (pluginsAttrSet.opt or []);
  
      ## Alternatively, just use `catAttrs` w/ specific keys 'start' and 'opt'

      ## grab all plugins from all packages
      #pluginsList = (lib.catAttrs "start" packagesList) ++ (lib.catAttrs "opt" packagesList);

      # grab all the vimrc from 'start' and 'opt' for each packages.'<package_name>'
      customRC = 
        utils.combineVimRC 
	  pluginsList 
          (lib.attrByPath ["configure" "customRC"] "" args)
      ;

      # TODO 
      # map over each <package> attr set:
      #   map over each 'start' and 'opt':
      #      if item is an attrSet, return "plugin" attribute.  
      #      else return item (we assume its a derivation).

      # Note:
      # - implementation assumes:
      #   - "start" and "opt" attributes are not of type Attribute Set (currently are Lists).
      #   - If each item in "start" and "opt" list is an Attribute Set, assume it has "plugin" attribute with the corresponding plugin derivation as value.  Else, assume the item itself is the plugin derivation.
      packages = lib.mapAttrsRecursive
        (path: value: 
	  (map 
	    (p: if  (lib.isAttrs p) && !(lib.isDerivation p) 
		then p.plugin
		else p)
	    value))
        (lib.attrByPath ["configure" "packages"] {} args)
      ;


      # TODO handle this case later
      # plugPlugins = ;
  
      newArgs = {
        configure = {
          inherit customRC packages;
          # TODO handle this case later
          # plug.plugins = plugPlugins;

        };
      };

      overrides = lib.recursiveUpdate args newArgs; 

    in
      neovim.override overrides;

  in
    lib.makeOverridable wrapper {}

