{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let cfg = config.custom.nix;
in
{
  options.custom.nix = with types; {
    enable = mkBoolOpt true "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nix "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      deploy-rs
      nixfmt
      nix-index
      nix-prefetch-git
      nixpkgs-review
      nurl
      nix-init
      haskellPackages.nixpkgs-update
    ];

    nix = {
      package = cfg.package;
      settings = {
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://prismlauncher.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
        ];
        trusted-users = [ "root" ];
        sandbox = true;
        require-sigs = true;
        max-jobs = "auto";
        auto-optimise-store = true;
        allowed-users = [ "*" ];
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
