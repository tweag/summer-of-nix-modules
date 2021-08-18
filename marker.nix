{ lib, config, ... }:
let
  # Returns the uppercased first letter
  # or number of a string
  firstUpperAlnum = str:
    lib.mapNullable lib.head
    (builtins.match "[^A-Z0-9]*([A-Z0-9]).*"
    (lib.toUpper str));

  # Either a color name or `0xRRGGBB`
  colorType = lib.types.either
    (lib.types.strMatching "0x[0-9A-F]{6}")
    (lib.types.enum [
      "black" "brown" "green" "purple" "yellow"
      "blue" "gray" "orange" "red" "white" ]);

  markerType = lib.types.submodule {
    options = {
      location = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      style.label = lib.mkOption {
        type = lib.types.nullOr
          (lib.types.strMatching "[A-Z0-9]");
        default = null;
      };

      style.color = lib.mkOption {
        type = colorType;
        default = "red";
      };

      style.size = lib.mkOption {
        type = lib.types.enum
          [ "tiny" "small" "medium" "large" ];
        default = "medium";
      };
    };
  };

  userType = lib.types.submodule ({ name, ... }: {
    options = {
      departure = lib.mkOption {
        type = markerType;
        default = {};
      };
    };

    config = {
      departure.style.label = lib.mkDefault
        (firstUpperAlnum name);
    };
  });

in {

  imports = [
    ./path.nix
  ];

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
          size = {
            tiny = "tiny";
            small = "small";
            medium = "mid";
            large = null;
          }.${marker.style.size};

          attributes =
            lib.optional
              (marker.style.label != null)
              "label:${marker.style.label}"
            ++ lib.optional
              (size != null)
              "size:${size}"
            ++ [
              "color:${marker.style.color}"
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
