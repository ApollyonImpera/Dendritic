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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."valeria" = {
    isNormalUser = true;
    description = "Valeria";
    extraGroups = [ "networkmanager" "wheel" "seat" "power" ];
    packages = with pkgs; [
	# kdePackages.kate
    thunderbird
    gimp
    libreoffice
    discord
	# pandoc
	# joplin
    wine
    bottles
    obsidian
    ];
  };

  environment.systemPackages = with pkgs; [
	firefox
	vim
	kitty
	xdg-desktop-portal-gtk
	thunar
	upower
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

  security.polkit.enable = true;

  services = {
	dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;  # Für Wayland-Screensharing/Clipboard
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];  # Für Dateidialoge etc.
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --cmd niri-session";
        user = "valeria";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.seatd.enable = true;
  hardware.graphics.enable = true;

  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
