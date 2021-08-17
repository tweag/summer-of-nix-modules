{ lib, config, ... }:
let

  markerType = lib.types.submodule {
    options = {
      location = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };
in {

  options = {
    map.markers = lib.mkOption {
      type = lib.types.listOf markerType;
    };
  };

  config = {

    map.markers = [
      { location = "new york"; }
    ];

    generate.requestParams = let
      paramForMarker = marker:
        let
          attributes =
            [
              "$(geocode ${
                lib.escapeShellArg marker.location
              })"
            ];
        in "markers=${
          lib.concatStringsSep "\\|" attributes
        }";
    in map paramForMarker config.map.markers;

  };

}
