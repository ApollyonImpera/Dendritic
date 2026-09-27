{ self, ... }: {
  flake.nixosModules.plasma = { pkgs, ... }: {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    programs.partition-manager.enable = true;
  };
}
