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

}
