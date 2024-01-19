{ config, lib, pkgs, ... }:

let cfg = config.jopejoe1.firefox;
in {
  options.jopejoe1.firefox = {
    enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {
          icon = "firefox-devedition";
          nameSuffix = "-devedition";
          pname = "firefox-devedition";
          desktopName = "Firefox DevEdition";
          wmClass = "firefox-devedition";
        };
        policies = {
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;
          CaptivePortal = false;
          DefaultDownloadDirectory = "${config.xdg.userDirs.download}";
          DisableAccounts = true;
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
          DNSOverHTTPS = {
            Enabled = false;
            Locked = true;
          };
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
          FirefoxSuggest = {
            WebSuggestions = false;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
            Locked = true;
          };
          PDFjs = {
            Enabled = true;
            EnablePermissions = false;
          };
          SupportMenu = {
            Title = "Localhost";
            URL = "http://localhost";
          };
          UserMessaging = {
            WhatsNew = false;
            ExtensionRecommendations = false;
            FeatureRecommendations = false;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
            Locked = true;
          };
          Extensions.Uninstall = [
            "1und1@search.mozilla.org"
            "allegro-pl@search.mozilla.org"
            "amazon@search.mozilla.org"
            "amazondotcn@search.mozilla.org"
            "amazondotcom@search.mozilla.org"
            "azerdict@search.mozilla.org"
            "baidu@search.mozilla.org"
            "bing@search.mozilla.org"
            "bok-NO@search.mozilla.org"
            "ceneji@search.mozilla.org"
            "coccoc@search.mozilla.org"
            "daum-kr@search.mozilla.org"
            "ddg@search.mozilla.org"
            "ebay@search.mozilla.org"
            "ecosia@search.mozilla.org"
            "eudict@search.mozilla.org"
            "faclair-beag@search.mozilla.org"
            "gmx@search.mozilla.org"
            "google@search.mozilla.org"
            "gulesider-NO@search.mozilla.org"
            "leo_ende_de@search.mozilla.org"
            "longdo@search.mozilla.org"
            "mailcom@search.mozilla.org"
            "mapy-cz@search.mozilla.org"
            "mercadolibre@search.mozilla.org"
            "mercadolivre@search.mozilla.org"
            "naver-kr@search.mozilla.org"
            "odpiralni@search.mozilla.org"
            "pazaruvaj@search.mozilla.org"
            "priberam@search.mozilla.org"
            "prisjakt-sv-SE@search.mozilla.org"
            "qwant@search.mozilla.org"
            "qwantjr@search.mozilla.org"
            "rakuten@search.mozilla.org"
            "readmoo@search.mozilla.org"
            "salidzinilv@search.mozilla.org"
            "seznam-cz@search.mozilla.org"
            "twitter@search.mozilla.org"
            "tyda-sv-SE@search.mozilla.org"
            "vatera@search.mozilla.org"
            "webde@search.mozilla.org"
            "wikipedia@search.mozilla.org"
            "wiktionary@search.mozilla.org"
            "wolnelektury-pl@search.mozilla.org"
            "yahoo-jp-auctions@search.mozilla.org"
            "yahoo-jp@search.mozilla.org"
            "yandex@search.mozilla.org"
          ];
          # Extension Settings does work currently
          "3rdparty" = {
            Extensions = {
              "uBlock0@raymondhill.net" = {
                #adminSettings = {
                userSettings = {
                  uiTheme = "dark";
                  autoUpdate = true;
                  cloudStorageEnabled = false;
                  webrtcIPAddressHidden = true;
                };
                toOverwrite = [
                  "user-filters"
                  "ublock-filters"
                  "ublock-badware"
                  "ublock-privacy"
                  "ublock-abuse"
                  "ublock-unbreak"
                  "ublock-quick-fixes"
                  "adguard-generic"
                  "adguard-mobile"
                  "easylist"
                  "adguard-spyware-url"
                  "adguard-spyware"
                  "block-lan"
                  "easyprivacy"
                  "urlhaus-1"
                  "curben-phishing"
                  "adguard-social"
                  "adguard-cookies"
                  "ublock-cookies-adguard"
                  "adguard-popup-overlays"
                  "adguard-mobile-app-banners"
                  "adguard-other-annoyances"
                  "adguard-widgets"
                  "fanboy-thirdparty_social"
                  "easylist-annoyances"
                  "easylist-chat"
                  "fanboy-cookiemonster"
                  "ublock-cookies-easylist"
                  "easylist-newsletters"
                  "easylist-notifications"
                  "fanboy-social"
                  "ublock-annoyances"
                  "dpollock-0"
                  "plowe-0"
                  "DEU-0"
                ];
              };
              #};
            };
          };
        };
        profiles = {
          default = {
            extensions = with pkgs.firefox-addons; [
              ublock-origin
              privacy-badger
              bitwarden
              clearurls
              decentraleyes
              duckduckgo-privacy-essentials
              ghostery
              libredirect
              privacy-badger
              #languagetool
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
              #wappalyzer
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
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Modules" = {
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
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@nm" ];
                };
                "Home Manager Modules" = {
                  urls = [{
                    template = "https://mipmip.github.io/home-manager-option-search";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@hm" ];
                };
                "Repology" = {
                  urls = [{
                    template = "https://repology.org/projects";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }];
                  iconUpdateURL = "https://raw.githubusercontent.com/repology/repology-webapp/master/repologyapp/static/repology40x40.v1.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@repo" ];
                };
                "NixOS Wiki" = {
                  urls = [{
                    template = "https://nixos.wiki/index.php";
                    params = [{
                      name = "search";
                      value = "{searchTerms}";
                    }];
                  }];
                  icon = "${config.programs.firefox.profiles.default.search.engines."Nix Packages".icon}";
                  definedAliases = [ "@nw" ];
                };
                "Arch Wiki" = {
                  urls = [{
                    template = "https://wiki.archlinux.org/index.php";
                    params = [{
                      name = "search";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL = "https://upload.wikimedia.org/wikipedia/commons/1/13/Arch_Linux_%22Crystal%22_icon.svg";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@arch" ];
                };
                "Minecraft Wiki" = {
                  urls = [{
                    template = "https://minecraft.wiki/";
                    params = [{
                      name = "search";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL = "https://minecraft.wiki/images/Wiki.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@mc" ];
                };
                "Warframe Wiki" = {
                  urls = [{
                    template =
                      "https://warframe.fandom.com/wiki/Special:Search";
                    params = [{
                      name = "query";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL =
                    "https://static.wikia.nocookie.net/warframe/images/e/e6/Site-logo.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@wf" ];
                };
                "DuckDuckGo" = {
                  urls = [{
                    template =
                      "https://duckduckgo.com";
                    params = [{
                      name = "q";
                      value = "{searchTerms}";
                    }];
                  }];
                  iconUpdateURL =
                    "https://duckduckgo.com/assets/logo_header.v109.svg";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "ddg" ];
                };
                "Bing".metaData.hidden = true;
                "Google".metaData.hidden = true;
                "eBay".metaData.hidden = true;
                "Amazon.de".metaData.hidden = true;
                "ToS;DR Search".metaData.hidden = true;
                "LibRedirect".metaData.hidden = true;
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
              "pdfjs.annotationMode" = 2;
              "font.name-list.emoji" = lib.strings.concatStringsSep ", " config.jopejoe1.common.fonts.emoji;

              ## Arkenfox Stuff
              "browser.aboutConfig.showWarning" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" =
                false;
              "extensions.getAddons.showPane" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "browser.discovery.enabled" = false;
              "browser.shopping.experience2023.enabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";
              "browser.ping-centre.telemetry" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "app.shield.optoutstudies.enabled" = false;
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";
              "breakpad.reportURL" = "";
              "browser.tabs.crashReporting.sendReport" = false;
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
              "captivedetect.canonicalURL" = "";
              "network.captive-portal-service.enabled" = false;
              "network.connectivity-service.enabled" = false;
              "network.prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.predictor.enabled" = false;
              "network.predictor.enable-prefetch" = false;
              "network.http.speculative-parallel-limit" = 0;
              "browser.places.speculativeConnect.enabled" = false;
              "browser.urlbar.speculativeConnect.enabled" = false;
              "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              "browser.formfill.enable" = false;
              "browser.download.start_downloads_in_tmp_dir" = true;
              "browser.uitour.enabled" = false;
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

