{ inputs, pkgs, system }:

{
  tela-icon-theme-git = pkgs.tela-icon-theme.overrideAttrs {
    src = inputs.tela-icon-theme;
  };

  libadwaita-follow-theme = pkgs.libadwaita.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./adwaita-theming-support.patch ];
    doCheck = false;
  });

  prismlauncher-withExtraStuff = inputs.prismlauncher.packages.${system}.prismlauncher.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./prism-ftb.patch
    ];
  });

  nixos-anywhere = inputs.nixos-anywhere.packages.${system}.nixos-anywhere;

  madara = pkgs.stdenv.mkDerivation rec {
    name = "madara";
    version = "1.7.4.1";
    src = pkgs.requireFile {
      name = "madara-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-JxfjZLoN6I9twAQMT60Q27CgJg22G7zEU5GDra9rROs=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-child = pkgs.stdenv.mkDerivation rec {
    name = "madara-child";
    version = "1.0.3";
    src = pkgs.requireFile {
      name = "madara-child-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-h9w2TmX1nXaoP27b9DQ1jf6z1hTS5+BWtlz+Fprk5dQ=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    unpackPhase = ''
      mkdir -p $out
      unzip $src "madara-child/*" -d $out
    '';
    installPhase = "mv $out/madara-child/* $out";
  };
  madara-core = pkgs.stdenv.mkDerivation rec {
    name = "madara-core";
    version = "1.7.4.1";
    src = pkgs.requireFile {
      name = "madara-core-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-r22hGCDlVeYTOFlhfKoc3r4TtpZExJ2E2QP9ssRoJco=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  madara-shortcodes = pkgs.stdenv.mkDerivation rec {
    name = "madara-shortcodes";
    version = "1.5.5.9";
    src = pkgs.requireFile {
      name = "madara-shortcodes-${version}.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-IW7C5DTzvt3ROFpfB21LY2wmdR45lNj9c8/THHCi6eY=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    unpackPhase = ''
      mkdir -p $out
      unzip $src "madara-shortcodes/*" -d $out
    '';
    installPhase = "mv $out/madara-shortcodes/* $out";
  };
  option-tree-lean = pkgs.stdenv.mkDerivation rec {
    name = "option-tree-lean";
    version = "0";
    src = pkgs.requireFile {
      name = "option-tree-lean.zip";
      url = "https://mangabooth.com/";
      hash = "sha256-9u+MGdOarNdLtARWiJpw/hsMR9X8r0h5qugGir+amUI=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  option-tree = pkgs.stdenv.mkDerivation rec {
    name = "option-tree";
    version = "2.7.3";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/option-tree.zip";
      hash = "sha256-+dPt8qJ4rkmSKrIXX5IiWO4zkFkR+Uapjlbx1g7KzKs=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  widget-logic = pkgs.stdenv.mkDerivation rec {
    name = "widget-logic";
    version = "5.10.4";
    src = pkgs.fetchzip {
      url = "https://downloads.wordpress.org/plugin/widget-logic.zip";
      hash = "sha256-J2NOth3q+IaPVhFT97arsNfjUPyTZF4Vvin1Cb+xnKw=";
    };
    nativeBuildInputs = [
      pkgs.unzip
    ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
}
