{ config, pkgs, lib, ... }:

let
  cfg = config.jopejoe1.jopejoe1;
  hcfg = config.home-manager.users.jopejoe1;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.jopejoe1 = {
      home = {
        # Basic information for home-manager
        username = config.users.users.jopejoe1.name;
        homeDirectory = config.users.users.jopejoe1.home;

        # Enviroment variables
        sessionVariables = {
          XCOMPOSECACHE = "${hcfg.xdg.cacheHome}/X11/xcompos";
          XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
          ANDROID_HOME = "${hcfg.xdg.dataHome}/android";
          CUDA_CACHE_PATH = "${hcfg.xdg.cacheHome}/nv";
          GRADLE_USER_HOME = "${hcfg.xdg.dataHome}/gradle";
          KODI_DATA = "${hcfg.xdg.dataHome}/kodi";
          _JAVA_OPTIONS =
            "-Djava.util.prefs.userRoot=${hcfg.xdg.configHome}/java";
          WINEPREFIX = "${hcfg.xdg.dataHome}/wine";
        };

        stateVersion = config.system.stateVersion;
      };

      accounts.email.accounts = {
        main = {
          address = "johannes@joens.email";
          flavor = "gmail.com";
          primary = true;
          realName = "Johannes Jöns";
          thunderbird.enable = true;
        };
      };

      gtk = {
        enable = false;
        gtk2.configLocation = "${hcfg.xdg.configHome}/gtk-2.0/gtkrc";
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
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
          historyFile = "${hcfg.xdg.stateHome}/bash/history";
        };
        git = {
          enable = true;
          package = pkgs.git;
          userEmail = "johannes@joens.email";
          userName = "jopejoe1";
          extraConfig = {
            core = {
              whitespace = [ "blank-at-eol" "blank-at-eof" "space-before-tab" ];
            };
          };
        };
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
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
            DefaultDownloadDirectory = "${hcfg.xdg.userDirs.download}";
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
            # Extension Settings
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
                    icon =
                      "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "@nm" ];
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
                "font.name-list.emoji" = lib.strings.concatStringsSep ", "
                  config.fonts.fontconfig.defaultFonts.emoji;

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
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          clang-tools
          gcc
          gopls
          nixd
          nodePackages.bash-language-server
          vscode-langservers-extracted
          yaml-language-server
          python3Packages.python-lsp-server
          shellcheck
        ];

        plugins = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
          nvim-lspconfig
        ];
      };
    };
  };
}
