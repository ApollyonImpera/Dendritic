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

	# Workspaces
	"Mod+Page_Down".focus-workspace-down = {};
	"Mod+Page_Up".focus-workspace-up = {};
	"Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
	"Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};

	# Column widths and maximization
	"Mod+R".switch-preset-column-width = {};
	"Mod+F".maximize-column = {};

	# Consume / expel windows between columns
	"Mod+Comma".consume-or-expel-window-left = {};
	"Mod+Period".consume-or-expel-window-right = {};

	# Floating <-> tiling
	"Mod+V".toggle-window-floating = {};
	"Mod+Shift+V".switch-focus-between-floating-and-tiling = {};

	# Overview and session
	"Mod+O".toggle-overview = {};
	"Mod+Shift+E".quit = {};

	# Help overlay (Mod+ß on de/dsb_qwertz; ß is the ? key shifted)
	"Mod+Ssharp".show-hotkey-overlay = {};
        };
      };
    };
  };
}
