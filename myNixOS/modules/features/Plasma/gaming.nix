{ self, ... }: {
  flake.nixosModules.gaming = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    hardware.graphics.enable32Bit = true;
    hardware.steam-hardware.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
    };

   services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };
  };
}
