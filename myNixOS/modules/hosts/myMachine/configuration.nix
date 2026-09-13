{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports = [
	self.nixosModules.myMachineHardware
	self.nixosModules.niri
    ];

  boot = {
	loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
	};
	kernelPackages = pkgs.linuxPackages_latest;		# newest Kernel
	kernelParams = [
		 "i915.enable_dc=2"     # display C-states
		 "i915.enable_fbc=1"    # framebuffer compression
		 "i915.enable_psr=2"    # panel self-refresh — biggest idle win; can flicker on some panels
		 "pcie_aspm=powersave"  # PCIe active-state power management
 	 ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
	networkmanager.enable = true;
	networkmanager.wifi.powersave = true;			# suspending wifi
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  system.stateVersion = "26.05";

  # Select internationalisation properties.
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

  # Configure console keymap
  console.keyMap = "de";
  environment.sessionVariables = {
    XKB_DEFAULT_VARIANT = "dsb_qwertz";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."valeria" = {
    isNormalUser = true;
    description = "Valeria";
    extraGroups = [ "networkmanager" "wheel" "seat" "power" "bluetooth" ];
    packages = with pkgs; [
	kdePackages.kate				# gui code editor
	thunderbird			# mail
	gimp				# picture editor
	libreoffice			# productivity
	discord				# communication
	wine				# Wine is not an emulator
	bottles				# Wine manager
	obsidian			# structure system: Markdown
	pandoc				# file converter mostly from Markdown to X
	glow				# markdown in terminal:: glow ~/filename.md
	git				# saving stuff
	curl				# fetch file from terminal
	zathura				# PDF Reader keyboard
	kdePackages.okular				# PDF reader mouse
	keepassxc			# password manager
	restic				# backup
    ];
  };

  environment.systemPackages = with pkgs; [
	firefox				# browser
	vim				# terminal editor
	neovim				# newer terminal editor
	helix				# batteries included terminal editor
	kitty				# terminal
	xdg-desktop-portal-gtk		# I forgot what it does
	thunar				# file manager
	upower				# battery tracking
	mousepad			# gui editor
	brightnessctl			# brightness control
	btop				# systemmonitor
	# Screenshot tools
	grim
	slurp
	satty
	wl-clipboard
	wayfreeze
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow libraries
  # programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs here, NOT in environment.systemPackages
  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  security = {
	polkit.enable = true;
	rtkit.enable = true;			# pipewire part
  };

  services = {
	dbus.enable = true;
	upower.enable = true;
	seatd.enable = true;
	gnome.gnome-keyring.enable = true;
	printing.enable = true;			# printer (through CUPS?)
	fwupd.enable = true;			# linux FirmWare UPdate Demon > slimbook updates
	power-profiles-daemon.enable = true;	# energy managment daemon
	# openssh.enable = true;		# OpenSSH daemon

	pulseaudio.enable = false;		# pipewire stuff
	pipewire = {
	  enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;
	  pulse.enable = true;
	# jack.enable = true;			# JACK applications?
	# media-session.enable = true;		# session manager
	};

	libinput = {				# hardware input controls
	  touchpad = {
     	    tapping = true;
	    tappingButtonMap = "leftmiddle";
	};
	};

	greetd = {
	  enable = true;
	  settings = {
	    default_session = {
	      command = "${lib.getExe pkgs.tuigreet} --time --cmd niri-session";
	      user = "valeria";
	};
	};
 	};
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  hardware = {
	graphics.enable = true;
	bluetooth = {
		enable = true;				# starts daemon
		powerOnBoot = false;			# blocks power on start up
	};
	enableRedistributableFirmware = true;		# newest hardware support
  };  

  powerManagement.powertop.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  };

}
