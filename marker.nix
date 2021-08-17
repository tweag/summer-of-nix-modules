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

  userType = lib.types.submodule {
    options = {
      departure = lib.mkOption {
        type = markerType;
        default = {};
      };
    };
  };

in {

  options = {

    users = lib.mkOption {
      type = lib.types.attrsOf userType;
    };

    map.markers = lib.mkOption {
      type = lib.types.listOf markerType;
    };
  };

  config = {

    map.markers = lib.filter
      (marker: marker.location != null)
      (lib.concatMap (user: [
        user.departure
      ]) (lib.attrValues config.users));

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
