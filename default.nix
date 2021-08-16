{ lib, config, ... }: {

  options = {
    generate.script = lib.mkOption {
      type = lib.types.lines;
    };

    generate.requestParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config = {
    generate.script = ''
      map ${lib.concatStringsSep " "
            config.generate.requestParams
           } | icat
    '';

    generate.requestParams = [
      "size=640x640"
      "scale=2"
    ];
  };
  
}
