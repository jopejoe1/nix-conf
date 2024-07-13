{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.jopejoe1.firefox;
  lock = value: {
    Value = value;
    Status = "locked";
  };
in
{
  options.jopejoe1.firefox = {
    enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
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
            Title = "Config";
            URL = "https://codeberg.org/jopejoe1/nix-conf";
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
          Preferences = {
            "privacy.resistFingerprinting" = lock true;
            "privacy.trackingprotection.fingerprinting.enabled" = lock true;
            "privacy.trackingprotection.cryptomining.enabled" = lock true;
            "dom.event.clipboardevents.enabled" = lock false;
            "dom.battery.enabled" = lock false;
            "browser.safebrowsing.phishing.enabled" = lock false;
            "browser.safebrowsing.malware.enabled" = lock false;
            "browser.zoom.siteSpecific" = lock true;
            "config.trim_on_minimize" = lock true;
            "pdfjs.annotationEditorMode" = lock 0;
            "pdfjs.annotationMode" = lock 2;
            "font.name-list.emoji" = lock (
              lib.strings.concatStringsSep ", " config.jopejoe1.common.fonts.emoji
            );

            # Theming
            "widget.gtk.overlay-scrollbars.enabled" = lock false;

            ## Arkenfox Stuff
            "browser.aboutConfig.showWarning" = lock false;
            "browser.newtabpage.activity-stream.showSponsored" = lock false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock false;
            "extensions.getAddons.showPane" = lock false;
            "extensions.htmlaboutaddons.recommendations.enabled" = lock false;
            "browser.discovery.enabled" = lock false;
            "browser.shopping.experience2023.enabled" = lock false;
            "datareporting.policy.dataSubmissionEnabled" = lock false;
            "datareporting.healthreport.uploadEnabled" = lock false;
            "toolkit.telemetry.unified" = lock false;
            "toolkit.telemetry.enabled" = lock false;
            "toolkit.telemetry.server" = lock "data:,";
            "toolkit.telemetry.archive.enabled" = lock false;
            "toolkit.telemetry.newProfilePing.enabled" = lock false;
            "toolkit.telemetry.shutdownPingSender.enabled" = lock false;
            "toolkit.telemetry.updatePing.enabled" = lock false;
            "toolkit.telemetry.bhrPing.enabled" = lock false;
            "toolkit.telemetry.firstShutdownPing.enabled" = lock false;
            "toolkit.telemetry.coverage.opt-out" = lock true;
            "toolkit.coverage.opt-out" = lock true;
            "toolkit.coverage.endpoint.base" = lock "";
            "browser.ping-centre.telemetry" = lock false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = lock false;
            "browser.newtabpage.activity-stream.telemetry" = lock false;
            "app.shield.optoutstudies.enabled" = lock false;
            "app.normandy.enabled" = lock false;
            "app.normandy.api_url" = lock "";
            "breakpad.reportURL" = lock "";
            "browser.tabs.crashReporting.sendReport" = lock false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock false;
            "captivedetect.canonicalURL" = lock "";
            "network.captive-portal-service.enabled" = lock false;
            "network.connectivity-service.enabled" = lock false;
            "network.prefetch-next" = lock false;
            "network.dns.disablePrefetch" = lock true;
            "network.predictor.enabled" = lock false;
            "network.predictor.enable-prefetch" = lock false;
            "network.http.speculative-parallel-limit" = lock 0;
            "browser.places.speculativeConnect.enabled" = lock false;
            "browser.urlbar.speculativeConnect.enabled" = lock false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = lock false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = lock false;
            "browser.formfill.enable" = lock false;
            "browser.download.start_downloads_in_tmp_dir" = lock true;
            "browser.uitour.enabled" = lock false;
            "browser.tabs.inTitlebar" = lock 0;
          };
          "3rdparty" = {
            Extensions = {
              "uBlock0@raymondhill.net".adminSettings = {
                userSettings = {
                  uiTheme = "dark";
                  uiAccentCustom = true;
                  uiAccentCustom0 = "#b4befe";
                  cloudStorageEnabled = false;
                };
                selectedFilterLists = [
                  "adguard-generic"
                  "adguard-annoyance"
                  "adguard-cookies"
                  "adguard-social"
                  "adguard-spyware"
                  "adguard-spyware-url"
                  "adguard-popup-overlays"
                  "adguard-other-annoyances"
                  "adguard-widgets"
                  "block-lan"
                  "curben-phishing"
                  "dpollock-0"
                  "easylist"
                  "easylist-chat"
                  "easylist-newsletters"
                  "easylist-notifications"
                  "easylist-annoyances"
                  "easyprivacy"
                  "fanboy-cookiemonster"
                  "fanboy-social"
                  "fanboy-thirdparty_social"
                  "FIN-0"
                  "plowe-0"
                  "ublock-abuse"
                  "ublock-badware"
                  "ublock-cookies-adguard"
                  "ublock-cookies-easylist"
                  "ublock-filters"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                  "ublock-annoyances"
                  "urlhaus-1"
                ];
              };
              filters = [ ''stackoverflow.com##.sm\:fd-column.flex__allitems6.d-flex.mx-auto.wmx9'' ];
            };
          };
        };
        profiles = {
          default = {
            extensions = with pkgs.firefox-addons; [
              ublock-origin
              bitwarden
              clearurls
              libredirect
              #languagetool
              return-youtube-dislikes
              sponsorblock
              augmented-steam
              steam-database
              refined-github
              plasma-integration
              #bypass-paywalls-clean
              skip-redirect
              terms-of-service-didnt-read
              unpaywall
              modrinthify
              stylus
              multi-account-containers
            ];
            id = 0;
            isDefault = true;
            name = "default";
            search = {
              default = "DuckDuckGo";
              force = true;
              engines = {
                "Nix Packages" = {
                  urls = [
                    {
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
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Modules" = {
                  urls = [
                    {
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
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@nm" ];
                };
                "Home Manager Modules" = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master";
                        }
                      ];
                    }
                  ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@hm" ];
                };
                "Repology" = {
                  urls = [
                    {
                      template = "https://repology.org/projects";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://raw.githubusercontent.com/repology/repology-webapp/master/repologyapp/static/repology40x40.v1.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@repo" ];
                };
                "NixOS Wiki" = {
                  urls = [
                    {
                      template = "https://wiki.nixos.org/w/index.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${config.programs.firefox.profiles.default.search.engines."Nix Packages".icon}";
                  definedAliases = [ "@nw" ];
                };
                "Arch Wiki" = {
                  urls = [
                    {
                      template = "https://wiki.archlinux.org/index.php";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://upload.wikimedia.org/wikipedia/commons/1/13/Arch_Linux_%22Crystal%22_icon.svg";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@arch" ];
                };
                "Minecraft Wiki" = {
                  urls = [
                    {
                      template = "https://minecraft.wiki/";
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://minecraft.wiki/images/Wiki.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@mc" ];
                };
                "Warframe Wiki" = {
                  urls = [
                    {
                      template = "https://warframe.fandom.com/wiki/Special:Search";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://static.wikia.nocookie.net/warframe/images/e/e6/Site-logo.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@wf" ];
                };
                "MusicBrainz Artis" = {
                  urls = [
                    {
                      template = "https://musicbrainz.org/search";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "type";
                          value = "artis";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://musicbrainz.org/static/images/favicons/apple-touch-icon-180x180.png";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@mb" ];
                };
                "DuckDuckGo" = {
                  urls = [
                    {
                      template = "https://duckduckgo.com";
                      params = [
                        {
                          name = "q";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  iconUpdateURL = "https://duckduckgo.com/assets/logo_header.v109.svg";
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
