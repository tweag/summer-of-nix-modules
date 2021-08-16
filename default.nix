{ lib, ... }: {

  options = {
    generate.script = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    generate.script = ''
      map size=640x640 scale=2 | icat
    '';
  };
  
}
