{
  description = "A flake for providing HandyGCCS to Nix";

  inputs.handygccs = {
    url = "github:ShadowBlip/HandyGCCS/aya2_dev";
    flake = false;
  };
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs, handygccs }: {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {
        name = "HandyGCCS";
        src = handygccs;
        buildInputs = [ i2c-tools ];
        buildPhase = ''echo "Copying python scripts to derivation"'';
        installPhase = ''
          mkdir -p $out/scripts

          cp usr/share/handygccs/scripts/constants.py $out/scripts
          cp usr/share/handygccs/scripts/handycon.py $out/scripts
        '';
      };

    nixosModules.handygccs = import ./modules/handygccs self.packages.x86_64-linux.default; 
  };
}
