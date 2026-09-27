{ self, ... }: {
  flake.nixosModules.StationaryHardware = { ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";   # ← add this line

    # ...rest of the placeholder unchanged:
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/PLACEHOLDER-ROOT-UUID";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/PLACEHOLDER-BOOT-UUID";
      fsType = "vfat";
    };

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
  };
}

