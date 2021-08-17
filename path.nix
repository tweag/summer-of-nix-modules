{ lib, config, ... }:
let
  pathType = lib.types.submodule {

    options = {
      locations = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };

  };
in {
  options = {
    map.paths = lib.mkOption {
      type = lib.types.listOf pathType;
    };
  };

  config = {
    generate.requestParams = let
      attrForLocation = loc:
        "$(geocode ${lib.escapeShellArg loc})";
      paramForPath = path:
        let
          attributes =
            map attrForLocation path.locations;
        in "path=${
            lib.concatStringsSep "\\|" attributes
          }";
      in map paramForPath config.map.paths;
  };
}
