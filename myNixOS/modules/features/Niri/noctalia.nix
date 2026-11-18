{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {

    packages.myNoctalia =
      let
        configDir = pkgs.runCommand "noctalia-config" { } ''
          mkdir -p $out/noctalia
          cp ${./noctalia.toml} $out/noctalia/config.toml
        '';
      in
      pkgs.symlinkJoin {
        name = "noctalia-wrapped";
        paths = [ pkgs.noctalia ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/noctalia \
            --set NOCTALIA_CONFIG_HOME ${configDir}
        '';
        meta.mainProgram = "noctalia";   # <-- diese Zeile hinzufügen
      };
  };
}
