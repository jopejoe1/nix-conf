{ config, pkgs, ... }:

{
  home = {
    # Basic information for home-manager
    username = "jopejoe1";
    homeDirectory = "/home/${config.home.username}";
    
    # Enviroment variables
    sessionVariables = {
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompos";
      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    };

    # Do not change this version unless 100% sure updatet evrything to the new version
    stateVersion = "23.05";
  };

  accounts.email.accounts = {
    main = {
      address = "johannes@joens.email";
      flavor = "gmail.com";
      primary = true;
      realName = "Johannes Joens";
      thunderbird.enable = true;
    };
  };

  # XDG base dirs
  xdg = {
    enable = true;
    mime.enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  gtk = {
    enable = true;
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-button-images = true;
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
        gtk-menu-images = true;
        gtk-modules = "colorreload-gtk-module";
        gtk-primary-button-warps-slider = false;
        gtk-toolbar-style = 3;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = false;
      };
    };
    cursorTheme = {
      package = pkgs.libsForQt5.breeze-icons;
      name = "breeze_cursors";
      size = 24;
    };
    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
      size = 10;
    };
    theme = {
      package = pkgs.libsForQt5.breeze-gtk;
      name = "breeze-dark";
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name  = "Tela-purple";
    };
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userEmail = "johannes@joens.email";
      userName = "jopejoe1";
    };
    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
      shellAliases = {
        gc = "sudo nix store gc";
        rb = "sudo nix flake update /etc/nixos/ && sudo nixos-rebuild switch";
      };
    };
    zsh.shellAliases = config.programs.bash.shellAliases;
    fish.shellAbbrs = config.programs.bash.shellAliases;
    thunderbird = {
      enable = false;
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;
          DisableAppUpdate = true;
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          DisableFormHistory = true;
          DefaultDownloadDirectory = "${config.xdg.userDirs.download}";
          DontCheckDefaultBrowser = true;
          ExtensionUpdate = false;
          NoDefaultBookmarks = true;
          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          EnableTrackingProtection = {
            Value = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          FirefoxHome = {
            Search = true;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            TopSites = true;
            SponsoredTopSites = false;
            Highlights = false;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
      };
      profiles = {
        default = {
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            privacy-badger
            bitwarden
            clearurls
            decentraleyes
            duckduckgo-privacy-essentials
            ghostery
            libredirect
            privacy-badger
            languagetool
            fastforward
            return-youtube-dislikes
            sponsorblock
            augmented-steam
            steam-database
            refined-github
            plasma-integration
            bypass-paywalls-clean
            lovely-forks
            search-by-image
            skip-redirect
            terms-of-service-didnt-read
            unpaywall
            wappalyzer
            wayback-machine
            modrinthify
          ];
          id = 0;
          isDefault = true;
          name = "default";
          search = {
            default = "DuckDuckGo";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                   params = [
                     { name = "type"; value = "packages"; }
                     { name = "query"; value = "{searchTerms}"; }
                   ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                icon = "${config.programs.firefox.profiles.default.search.engines."Nix Packages".icon}";
                definedAliases = [ "@nw" ];
              };
              "Bing".metaData.hidden = true;
              "Google".metaData.hidden = true;
              "eBay".metaData.hidden = true;
              "Amazon.de".metaData.hidden = true;
              "Wikipedia (en)".metaData.alias = "@wiki";
            };
          };
          settings = {
            "privacy.resistFingerprinting" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "dom.event.clipboardevents.enabled" = false;
            "dom.battery.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.zoom.siteSpecific" = true;
            "config.trim_on_minimize" = true;
            "pdfjs.annotationEditorMode" = 0;
            "pdfjs.annotationmode" = 2;
          };
        };
      };
    };
  };
}
