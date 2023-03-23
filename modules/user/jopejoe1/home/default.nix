{ options, config, pkgs, lib, ... }:

with lib;
#with lib.internal;
let
  cfg = config.custom.user.jopejoe1.home;
  hcfg = config.home-manager.users.jopejoe1;
in
{
  options.custom.user.jopejoe1.home = with types; {
    enable = mkBoolOpt false "Enable the home-manger for jopejoe1";
  };

  config = mkIf cfg.enable {
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
          createDirectories = false;
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
        firefox = {
          enable = true;
          package = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {
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
              DefaultDownloadDirectory = "${hcfg.xdg.userDirs.download}";
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
                    icon = "${hcfg.programs.firefox.profiles.default.search.engines."Nix Packages".icon}";
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
  };
}
