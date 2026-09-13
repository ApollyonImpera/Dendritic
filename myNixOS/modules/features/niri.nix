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
	"Mod+Down".focus-workspace-down = {};
	"Mod+Up".focus-workspace-up = {};
	# "Mod+Up".focus-window-up = {};			# not working
	# "Mod+Down".focus-window-down = {};			# not working

	# Window movement
	"Mod+Shift+Left".move-column-left = {};
	"Mod+Shift+Right".move-column-right = {};
	"Mod+Shift+Down".move-column-to-workspace-down = {};
	"Mod+Shift+Up".move-column-to-workspace-up = {};
	# "Mod+Shift+Up".move-window-up = {};			# not working
	# "Mod+Shift+Down".move-window-down = {};		# not working

	"Mod+Ssharp".show-hotkey-overlay = {};	
	"Mod+R".switch-preset-column-width = {};
	"Mod+F".maximize-column = {};
	"Mod+Comma".consume-or-expel-window-left = {};
	"Mod+Period".consume-or-expel-window-right = {};
	"Mod+V".toggle-window-floating = {};
	"Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
	"Mod+O".toggle-overview = {};
	"Mod+Shift+E".quit = {};
	# Screenshot
	"Mod+Print".spawn-sh = "grim - | satty --filename -";
	"Print".spawn-sh = "wayfreeze --hide-cursor & PID=$!; sleep 0.1; IMG=$(grim -g \"$(slurp)\" - | base64); kill $PID; echo \"$IMG\" | base64 -d | satty --filename -";
        };
      };
    };
  };
}
