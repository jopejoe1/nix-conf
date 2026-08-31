{
  hardware.facter.reportPath = ./facter.json;

  jopejoe1 = {
    ssh.enable = true;
    user.jopejoe1.enable = true;
    boot.systemd.enable = true;
  };

  disko.devices = {
    disk = {
      some-disk = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            nyoom = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
