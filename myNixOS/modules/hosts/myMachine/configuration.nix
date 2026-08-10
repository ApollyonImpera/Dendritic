# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
  imports = [
    self.nixosModules.myMachineHardware
    self.nixosModules.niri
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Flakes
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the Desktop Environment.
  # services.displayManager.sddm.enable = true;	# Plasma
  # services.desktopManager.plasma6.enable = false;	# Plasma
  # services.desktopManager.gnome.enable = true;	# Gnome
  # services.displayManager.gdm.enable = true;		# Gnome

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "dsb_qwertz";
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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	kdePackages.kate
	thunderbird
	gimp
	libreoffice
	discord
	pandoc
	joplin
	neovim
	wine
	bottles
	obsidian
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow libraries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged programs here, NOT in environment.systemPackages
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	# Powermanagment
	powertop
	htop
	usbutils
	jdk	# Java
	vlc	# video player
	xdg-desktop-portal-wlr
        dbus
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  powerManagement.powertop.enable = false;
  services = {
    power-profiles-daemon.enable = false;
    irqbalance.enable = false;
    tlp = {
      enable = true;
	# Intel-CPU
      settings = {
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
	TLP_POWER_PROFILE_ON_AC = "power";
	TLP_POWER_PROFILE_ON_BAT = "power";
	GPU_POWER_ON_BAT = 0;
	GPU_POWER_ON_AC = 0;
	CPU_HWP_DYN_BOOST_ON_AC = 1;	# unknown
	CPU_HWP_DYN_BOOST_ON_BAT = 0;	# unknown
	CPU_MIN_PERF_ON_BAT = 0;	# limits power agressively
	CPU_MAX_PERF_ON_BAT = 50;	# limits power agressively
	RUNTIME_PM_ON_BAT = "auto";
	PCIE_ASPM_ON_BAT = "powersupersave";
	USB_AUTOSUSPEND = 1;
	USB_AUTOSUSPEND_DISABLE_ON_BAT = 0;
	USB_AUTOSUSPEND_DISABLE_ON_AC = 0;
	USB_BLACKLIST = "";		# enter exceptions here
	USB_EXCLUDE_AUDIO = 1;
	USB_EXCLUDE_HID = 0;
	WIFI_PWR_ON_BAT = 1;
	WIFI_PWR_ON_AC = 1;
	DISK_APM_LEVEL_ON_BAT = "128";
	DISK_SPINDOWN_TIMEOUT_ON_BAT = "10 10";
	KERNEL_LATENCY_TUNING = 1;
      };
    };
  };

  # intel iGPU
  boot.kernelParams = [
  # GPU/CPU
  "i915.enable_psr=2"
  "i915.enable_fbc=1"
  "i915.enable_dc=4"
  "i915.enable_rc6=1"
  "i915.enable_rc6p=1"
  "i915.low_power_mode=1"
  "i915.enable_guc=3"
  "i915.enable_huc=1"
  "intel_pstate=active"
  "i915.enable_guc_submission=1"	# ?
  # energy optimisation
  "pcie_aspm=force"
   "nmi_watchdog=0"
   "snd_hda_intel.power_save=1"
   "iwlwifi.power_save=1"
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
 
  };
}
