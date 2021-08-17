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

    map.center = lib.mkIf
      (lib.length config.map.markers >= 1)
      null;

    map.zoom = lib.mkIf
      (lib.length config.map.markers >= 2)
      null;

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
