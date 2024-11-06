{
  ...
}:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1cae8f88-5db6-4c97-88e4-350c35275d5c";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/8569ee66-b939-4ce8-a94a-dca7df5e301b"; } ];
}
