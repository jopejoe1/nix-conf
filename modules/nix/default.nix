{ pkgs, self, ... }:

{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://prismlauncher.cachix.org"
        "https://nixos-search.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "prismlauncher.cachix.org-1:GhJfjdP1RFKtFSH3gXTIQCvZwsb2cioisOf91y/bK0w="
        "nixos-search.cachix.org-1:1HV3YF8az4fywnH+pAd+CXFEdpTXtv9WpoivPi+H70o="
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
    package = pkgs.nixVersions.nix_2_15;
    registry = {
      home-manager.flake = self.inputs.home-manager;
      nixos-hardware.flake = self.inputs.nixos-hardware;
      nur.flake = self.inputs.nur;
      nixpkgs.flake = self.inputs.nixpkgs;
    };
    nixPath = [ "nixpkgs=${self.inputs.nixpkgs}" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
  };

  environment.systemPackages = with pkgs; [
    deploy-rs
    nixfmt
    nix-index
    nix-prefetch-git
    nixpkgs-review
    nurl
    nix-init
  ];
}

