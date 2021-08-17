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

    map.paths = map (user: {
      locations = [
        user.departure.location
        user.arrival.location
      ];
    }) (lib.filter (user:
      user.departure.location != null
      && user.arrival.location != null
    ) (lib.attrValues config.users));

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
