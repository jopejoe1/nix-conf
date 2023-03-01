{
  inputs = {
    # nixpkgs (Packges and modules)
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    # Nix Hardware (Hardware configs)
    nixos-hardware.url = github:NixOS/nixos-hardware;

    # NUR (User Packges)
    nur.url = github:nix-community/NUR;

    # Home Manger (Dot files)
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    # Nix Darwin (Mac OS support)
    nix-darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Image generators
    nixos-generators = {
      url = github:nix-community/nixos-generators;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "nixlib";
    };

    # PrismLauncher (git version of PrismLauncher)
    prismlauncher = {
      url = github:PrismLauncher/PrismLauncher;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.libnbtplusplus.follows = "libnbtplusplus";
    };
    libnbtplusplus = {
      url = github:PrismLauncher/libnbtplusplus;
      flake = false;
    };

    # vscode extensions
    nix-vscode-extensions = {
      url = github:nix-community/nix-vscode-extensions;
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = github:snowfallorg/lib;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils-plus.follows = "flake-utils-plus";
    };

    snowfall-flake = {
      url = github:snowfallorg/flake;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };

    comma = {
      url = github:nix-community/comma;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
      inputs.naersk.follows = "naersk";
    };

    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
    };

    peerix = {
      url = github:cid-chan/peerix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };

    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };

    # Dependcies
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
    flake-utils.url = github:numtide/flake-utils;
    nixlib.url = github:nix-community/nixpkgs.lib;
    naersk = {
      url = github:nix-community/naersk;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils-plus = {
      url = github:gytis-ivaskevicius/flake-utils-plus;
      inputs.flake-utils.follows = "flake-utils";
    };

    # Nix registery
    agda = {
      url = github:agda/agda;
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = github:hercules-ci/arion;
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.haskell-flake.follows = "haskell-flake";
    };
    haskell-flake.url = github:srid/haskell-flake;
    blender-bin = {
      url = github:edolstra/nix-warez?dir=blender;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    composable = {
      url = github:ComposableFi/composable;
      inputs.arion-src.follows = "arion";
      inputs.bundlers.follows = "bundlers";
      inputs.crane.follows = "crane";
      inputs.devenv.follows = "devenv";
      inputs.flake-parts.follows = "flake-parts";
      inputs.helix.follows = "helix";
      inputs.nix-std.follows = "nix-std";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-working-nixops.follows = "nixpkgs";
      inputs.npm-buildpackage.follows = "npm-buildpackage";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    crane = {
      url = github:ipetkov/crane;
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = github:oxalica/rust-overlay;
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = github:cachix/devenv;
      inputs.flake-compat.follows = "flake-compat";
      inputs.nix.follows = "nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    pre-commit-hooks = {
      url = github:cachix/pre-commit-hooks.nix;
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.gitignore.follows = "gitignore";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    gitignore = {
      url = github:hercules-ci/gitignore.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    npm-buildpackage = {
      url = github:serokell/nix-npm-buildpackage;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-std.url = github:chessai/nix-std;
    dreampkgs = {
      url = github:nix-community/dreampkgs;
      inputs.dream2nix.follows = "dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.src_amber.follows = "amber";
      inputs.src_eureka.follows = "eureka";
      inputs.src_httpie.follows = "httpie";
      inputs.src_labelme.follows = "labelme";
      inputs.src_mattermost-desktop.follows = "mattermost-desktop";
      inputs.src_mattermost-webapp.follows = "mattermost-webapp";
    };
    amber = {
      url = github:dalance/amber;
      flake = false;
    };
    eureka = {
      url = github:simeg/eureka;
      flake = false;
    };
    httpie = {
      url = github:httpie/httpie;
      flake = false;
    };
    labelme = {
      url = github:wkentaro/labelme;
      flake = false;
    };
    mattermost-desktop = {
      url = github:mattermost/desktop;
      flake = false;
    };
    mattermost-webapp = {
      url = github:mattermost/mattermost-webapp;
      flake = false;
    };
    dream2nix = {
      url = github:nix-community/dream2nix;
      inputs.alejandra.follows = "alejandra";
      inputs.crane.follows = "crane";
      inputs.devshell.follows = "devshell";
      inputs.flake-utils-pre-commit.follows = "flake-utils";
      inputs.gomod2nix.follows = "gomod2nix";
      inputs.mach-nix.follows = "mach-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.node2nix.follows = "node2nix";
      inputs.poetry2nix.follows = "poetry2nix";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakeCompat.follows = "flake-compat";
    };
    devshell.url = github:numtide/devshell;
    gomod2nix.url = github:tweag/gomod2nix;
    node2nix.url = github:svanderburg/node2nix;
    dwarffs.url = github:edolstra/dwarffs;
    emacs-overlay.url = github:nix-community/emacs-overlay;
    fenix.url = github:nix-community/fenix;
    flake-parts.url = github:hercules-ci/flake-parts;
    gemini.url = github:nix-community/flake-gemini;
    hercules-ci-effects.url = github:hercules-ci/hercules-ci-effects;
    hercules-ci-agent.url = github:hercules-ci/hercules-ci-agent;
    hydra.url = github:NixOS/hydra;
    mach-nix.url = github:DavHau/mach-nix;
    nimble.url = github:nix-community/flake-nimble;
    nix.url = github:NixOS/nix;
    nixops.url = github:NixOS/nixops;
    nixos-homepage.url = github:NixOS/nixos-homepage;
    nixos-search.url = github:NixOS/nixos-search;
    templates.url = github:NixOS/templates;
    patchelf.url = github:NixOS/patchelf;
    poetry2nix.url = github:nix-community/poetry2nix;
    nix-serve.url = github:edolstra/nix-serve;
    nickel.url = github:tweag/nickel;
    bundlers = {
      url = github:NixOS/bundlers;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-bundle.follows = "nix-bundle";
      inputs.nix-utils.follows = "nix-utils";
    };
    nix-bundle = {
      url = github:matthewbauer/nix-bundle;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-utils = {
      url = github:juliosueiras-nix/nix-utils;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    pridefetch.url = github:SpyHoodle/pridefetch;
    helix.url = github:helix-editor/helix;
    sops-nix.url = github:Mic92/sops-nix;
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
      };
    in
    lib.mkFlake {
      package-namespace = "custom";

      channels-config.allowUnfree = true;

      overlays = with inputs; [
        nur.overlay
        snowfall-flake.overlay
        prismlauncher.overlay
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        peerix.nixosModules.peerix
        agenix.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          system.stateVersion = "23.05";
          nix.registry = {
            agda.flake = agda;
            arion.flake = arion;
            blender-bin.flake = blender-bin;
            composable.flake = composable;
            dreampkgs.flake = dreampkgs;
            dwarffs.flake = dwarffs;
            emacs-overlay.flake = emacs-overlay;
            fenix.flake = fenix;
            flake-parts.flake = flake-parts;
            flake-utils.flake = flake-utils;
            gemini.flake = gemini;
            hercules-ci-effects.flake = hercules-ci-effects;
            hercules-ci-agent.flake = hercules-ci-agent;
            home-manager.flake = home-manager;
            hydra.flake = hydra;
            mach-nix.flake = mach-nix;
            nimble.flake = nimble;
            nix.flake = nix;
            nix-darwin.flake = nix-darwin;
            nixops.flake = nixops;
            nixos-hardware.flake = nixos-hardware;
            nixos-homepage.flake = nixos-homepage;
            nixos-search.flake = nixos-search;
            nur.flake = nur;
            nixpkgs.flake = nixpkgs;
            templates.flake = templates;
            patchelf.flake = patchelf;
            poetry2nix.flake = poetry2nix;
            nix-serve.flake = nix-serve;
            nickel.flake = nickel;
            bundlers.flake = bundlers;
            pridefetch.flake = pridefetch;
            helix.flake = helix;
            sops-nix.flake = sops-nix;
          };
          nix.nixPath = [ "nixpkgs=/etc/channels/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
          environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;
        }

      ];

      systems.hosts.yokai.modules = with inputs; [
        nixos-hardware.nixosModules.pine64-pinebook-pro
      ];

      deploy = lib.mkDeploy { inherit (inputs)  self; };

      checks =
        builtins.mapAttrs
          (system: deploy-lib:
            deploy-lib.deployChecks inputs.self.deploy)
          inputs.deploy-rs.lib;
    };
}
