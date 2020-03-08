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
}
