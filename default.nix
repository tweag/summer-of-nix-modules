{ lib, ... }: {

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
      map size=640x640 scale=2 | icat
    '';

    generate.requestParams = [
      "size=640x640"
      "scale=2"
    ];
  };
  
}
