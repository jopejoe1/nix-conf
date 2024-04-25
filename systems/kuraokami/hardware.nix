# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.nvidia.prime = {
    offload.enable = true;
    sync.enable = false;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  zramSwap.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ "enp6s0" ];
      dhcp-range = [ "10.0.0.2,10.0.0.255,255.255.255.0,24h" ];
      listen-address = "10.0.0.1";
    };
  };

  networking = {
    wireless = {
      enable = true;
      networks = {

      };
    };
    firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
    nameservers = [ "2a07:a8c0::fe:e334" "2a07:a8c1::fe:e334" ];
    useDHCP = lib.mkDefault true;
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.enable = lib.mkForce false;
    nftables = {
      enable = true;
      ruleset = ''
        table ip nat {
          chain postrouting {
            type nat hook postrouting priority 100;
            oifname "wlo1" masquerade
          }
        }
      '';
    };
  };

  systemd.network = {
    enable = true;
    networks = {
      # Connect the bridge ports to the bridge
      "30-enp6s0" = {
        matchConfig.Name = "enp6s0";
        networkConfig = {
          Address = "10.0.0.1/24";
        };
      };
      "30-wlo1" = {
        matchConfig.Name = "wlo1";
        networkConfig = {
          DHCP = "yes";
          IgnoreCarrierLoss = "3s";
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ec151a68-5886-4747-b5e3-2f9bdb89e162";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/8EED-43E3";
      fsType = "vfat";
    };
    "/media/gaming" = {
      device = "/dev/disk/by-uuid/4038F97238F966F6";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" ];
    };
  };

  swapDevices = [ ];

  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
