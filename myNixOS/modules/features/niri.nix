{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "de";
	    input.keyboard.xkb.variant = "dsb_qwertz";

        layout.gaps = 5;

        binds = {
        "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
        "Mod+Q".close-window = _:{};
        "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

	"XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
	"XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
	"XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

	"XF86MonBrightnessDown".spawn-sh = "brightnessctl set 5%-";
	"XF86MonBrightnessUp".spawn-sh = "brightnessctl set +5%";

	# Focus movement
	"Mod+Left".focus-column-left = {};
	"Mod+Right".focus-column-right = {};
	"Mod+Up".focus-window-up = {};
	"Mod+Down".focus-window-down = {};

	# Window movement
	"Mod+Shift+Left".move-column-left = {};
	"Mod+Shift+Right".move-column-right = {};
	"Mod+Shift+Up".move-window-up = {};
	"Mod+Shift+Down".move-window-down = {};
        };
      };
    };
  };
}
