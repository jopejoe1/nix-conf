{
  treefmt,
  nixfmt,
}:

treefmt.withConfig {
  runtimeInputs = [
    nixfmt
  ];
  settings = {
    tree-root-file = ".git/index";
    formatter = {
      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };
    };
  };
}
