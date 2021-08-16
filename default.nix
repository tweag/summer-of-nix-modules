{ lib, ... }: {

  options = {
    generate.script = lib.mkOption {
      type = lib.types.lines;
    };
  };
  
}
