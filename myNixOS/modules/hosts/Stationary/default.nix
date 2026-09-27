  { self, inputs, ... }: {
  flake.nixosConfigurations.Stationary = inputs.nixpkgs.lib.nixosSystem {
	modules = [
	  self.nixosModules.StationaryConfiguration
      ];
    };
  }
