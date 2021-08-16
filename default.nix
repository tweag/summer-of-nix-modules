{ lib, ... }: {

  options = {
    generate.script = lib.mkOption {
      type = lib.types.lines;
    };
  };

  config = {
    generate.script = 42;
  };
  
}
