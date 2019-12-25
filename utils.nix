{ lib }:
{
  # plugins:  List
  # customRC: String
  combineVimRC = plugins: customRC:
    let
      pluginsVimrc =  
        (builtins.map 
          # TODO use `attrByPath` to avoid using filter ("" as default value if "vimrc" doesn't exist)
          ( x: x.vimrc ) 
          (builtins.filter 
            (x: x ? "vimrc")
            plugins) 
        );
    in
      builtins.concatStringsSep 
        "\n"
        ( [ customRC ] ++ pluginsVimrc )
    ;


#  filterVimPlugPlugins = plugins:
#    builtins.map 
#      (x: x.plugin)
#      (builtins.filter 
#        (x: builtins.hasAttr "manager" x && x.manager == "plug")
#        plugins)
#    ;


  

  # plugins: List
  #
  # Returns
  # - List of derivations
 # getPluginDerivations = plugins:
 #   builtins.map
 #     (p: if lib.isDerivation 
 #           then p
 #         else if (builtins.isAttrs p && builtins.hasAttr "plugin" p) 
 #           then p.plugin)
 #     builtins.filter 
 #       (p: lib.isDerivation p || (builtins.isAttrs p && builtins.hasAttr "plugin" p))
 #   ;
	  
}
