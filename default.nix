{ lib, config, ... }: {

  options = {
    generate.script = lib.mkOption {
      type = lib.types.lines;
    };

    generate.requestParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    map = {
      zoom = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 2;
      };
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
      (lib.mkIf (config.map.zoom != null)
        "zoom=${toString config.map.zoom}")
    ];
  };
  
}
