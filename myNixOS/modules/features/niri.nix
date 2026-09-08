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
        "Ctrl+Alt+T".spawn-sh = lib.getExe pkgs.kitty;
        "Alt+F4".close-window = _:{};
        "Mod".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
	"Mod+Return".toggle-fullscreen = _:{};
	"Mod+Space".toggle-floating = _:{};
	"Mod+E".toggle-layout = _:{};
	"XF86PowerOff".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call session-menu toggle";
	# managing Windows
	"Mod+H".focus-direction = "left";
	"Mod+J".focus-direction = "down";
	"Mod+K".focus-direction = "up";
	"Mod+L".focus-direction = "right";
	"Mod+Shift+H".move-direction = "left";
	"Mod+Shift+J".move-direction = "down";
	"Mod+Shift+K".move-direction = "up";
	"Mod+Shift+L".move-direction = "right";
	"Mod+Ctrl+H".resize-direction = "left";
	"Mod+Ctrl+J".resize-direction = "down";
	"Mod+Ctrl+K".resize-direction = "up";
	"Mod+Ctrl+L".resize-direction = "right";
        };
      };
    };
  };
}
