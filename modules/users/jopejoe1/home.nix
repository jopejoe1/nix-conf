{ config, pkgs, ... }:

let hcfg = config.home-manager.users.jopejoe1;
in {
  home-manager.users.jopejoe1 = {
    home = {
      # Basic information for home-manager
      username = "jopejoe1";
      homeDirectory = "/home/${hcfg.home.username}";

      # Enviroment variables
      sessionVariables = {
        XCOMPOSECACHE = "${hcfg.xdg.cacheHome}/X11/xcompos";
        XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      };

      stateVersion = config.system.stateVersion;
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
      cacheHome = "${hcfg.home.homeDirectory}/.cache";
      configHome = "${hcfg.home.homeDirectory}/.config";
      dataHome = "${hcfg.home.homeDirectory}/.local/share";
      stateHome = "${hcfg.home.homeDirectory}/.local/state";
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${hcfg.home.homeDirectory}/Desktop";
        documents = "${hcfg.home.homeDirectory}/Documents";
        download = "${hcfg.home.homeDirectory}/Downloads";
        music = "${hcfg.home.homeDirectory}/Music";
        pictures = "${hcfg.home.homeDirectory}/Pictures";
        publicShare = "${hcfg.home.homeDirectory}/Public";
        templates = "${hcfg.home.homeDirectory}/Templates";
        videos = "${hcfg.home.homeDirectory}/Videos";
      };
    };
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userEmail = "johannes@joens.email";
        userName = "jopejoe1";
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {
          extraPolicies = {
            AppAutoUpdate = false;
            BackgroundAppUpdate = false;
            CaptivePortal = false;
            DefaultDownloadDirectory = "${hcfg.xdg.userDirs.download}";
            DisableAppUpdate = true;
            DisableFirefoxAccounts = true;
            DisableFirefoxStudies = true;
            DisableForgetButton = true;
            DisableFormHistory = true;
            DisableMasterPasswordCreation = true;
            DisablePasswordReveal = true;
            DisablePocket = true;
            DisableSetDesktopBackground = true;
            DisableSystemAddonUpdate = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            ExtensionUpdate = false;
            HardwareAcceleration = true;
            ManualAppUpdateOnly = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            PrimaryPassword = false;
            SearchBar = "unified";
            StartDownloadsInTempDirectory = true;
            EnableTrackingProtection = {
              Value = true;
              EmailTracking = true;
              Cryptomining = true;
              Fingerprinting = true;
              Locked = true;
            };
            FirefoxHome = {
              Highlights = false;
              Pocket = false;
              Search = true;
              Snippets = false;
              SponsoredPocket = false;
              SponsoredTopSites = false;
              TopSites = true;
              Locked = true;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };
          icon = "firefox-devedition";
          nameSuffix = "-devedition";
          pname = "firefox-devedition-bin";
          desktopName = "Firefox DevEdition";
          wmClass = "firefox-devedition";
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
              #fastforward
              return-youtube-dislikes
              sponsorblock
              augmented-steam
              steam-database
              refined-github
              plasma-integration
              #bypass-paywalls-clean
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
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }];
                  icon =
                    "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@nm" ];
                };
                "Nix Modules" = {
                  urls = [{
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }];
                  icon =
                    "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Wiki" = {
                  urls = [{
                    template = "https://nixos.wiki/index.php";
                    params = [{
                      name = "search";
                      value = "{searchTerms}";
                    }];
                  }];
                  icon =
                    "${hcfg.programs.firefox.profiles.default.search.engines."Nix Packages".icon}";
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
          dev-edition-default = {
            id = 1;
            isDefault = false;
            name = "dev-edition-default";
            path = "default";
          };
        };
      };
    };
  };
}
