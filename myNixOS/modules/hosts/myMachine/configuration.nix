{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports = [
	self.nixosModules.myMachineHardware
	self.nixosModules.niri
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

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
	# kdePackages.kate
    thunderbird				# mail
    gimp				# picture editor
    libreoffice				# productivity
    discord				# communication
	# pandoc
	# joplin
    wine				# d
    bottles				# d
    obsidian				# structure system
    ];
  };

  environment.systemPackages = with pkgs; [
	firefox				# browser
	vim				# terminal editor
	kitty				# terminal
	xdg-desktop-portal-gtk		# I forgot what it does
	thunar				# file manager
	upower				# battery tracking
	mousepad			# gui editor
	brightnessctl			# brightness control
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
	# openssh.enable = true;		# OpenSSH daemon

	pulseaudio.enable = false;		# pipewire stuff
	pipewire = {
	  enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;
	  pulse.enable = true;
	# jack.enable = true;			# JACK applications?
	# media-session.enable = true;		# session manager

	libinput = {				# hardware input controls
	  touchpad = {
     	    tapping = true;
	    tapButtonMap = "leftmiddle";

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
	bluetooth.enable = true;
  };  


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  };
}
