{ lib, config, ... }:
let

  pathStyleType = lib.types.submodule {
    options = {
      weight = lib.mkOption {
        type = lib.types.ints.between 1 20;
        default = 5;
      };
    };
  };

  pathType = lib.types.submodule {

    options = {
      locations = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

      style = lib.mkOption {
        type = pathStyleType;
        default = {};
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
            [
              "weight:${toString path.style.weight}"
            ]
            ++ map attrForLocation path.locations;
        in "path=${
            lib.concatStringsSep "\\|" attributes
          }";
      in map paramForPath config.map.paths;
  };
}
