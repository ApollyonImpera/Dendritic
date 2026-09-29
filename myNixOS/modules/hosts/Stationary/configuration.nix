{ self, inputs, ... }: {

  flake.nixosModules.StationaryConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.StationaryHardware
      self.nixosModules.plasma
      self.nixosModules.gaming
    ];

  boot = {
	loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
	};
	kernelPackages = pkgs.linuxPackages_latest;
	kernelParams = [ "preempt=full" "threadirqs" ];
	kernel.sysctl."vm.max_map_count" = 2147483642;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;   # needed for NVIDIA driver + Steam

  networking.hostName = "Stationary";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
	LC_ADDRESS = "de_DE.UTF-8";
	LC_IDENTIFICATION = "de_DE.UTF-8";
	LC_MEASUREMENT = "de_DE.UTF-8";
	LC_MONETARY = "de_DE.UTF-8";
	LC_NAME = "de_DE.UTF-8";
	LC_NUMERIC = "de_DE.UTF-8";
	LC_PAPER = "de_DE.UTF-8";
	LC_TELEPHONE = "de_DE.UTF-8";
	LC_TIME = "de_DE.UTF-8";
  };

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "de";
  };

  users.users."apollyon" = {
    isNormalUser = true;
    description = "apollyon";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [
	firefox
	wine
	bottles
	thunderbird
	discord
	heroic
	lutris
	keepassxc
	obsidian
	git
	kitty
	btop
      ];
    };

    environment.systemPackages = with pkgs; [
      vim
      neovim
    ];

  security = {
	polkit.enable = true;
	rtkit.enable = true;
  };
  services = {
	dbus.enable = true;
	fstrim.enable = true;          # periodic TRIM for both SSDs
	printing.enable = true;
	fwupd.enable = true;
	scx = {
	  enable = true;
	  scheduler = "scx_lavd";
	};

	pipewire = {
	  enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;    # 32-bit game audio
	  pulse.enable = true;
	};
  };

  hardware = {
	graphics.enable = true;
	enableRedistributableFirmware = true;  # default, explicit for clarity
  };

  system.stateVersion = "26.05";  # keep same as your laptop; don't change later
  };
}
