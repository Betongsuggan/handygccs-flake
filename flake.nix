{
  description = "A flake for providing HandyGCCS to Nix";

  inputs.handygccs = {
    url = "github:ShadowBlip/HandyGCCS/aya2_dev";
    flake = false;
  };
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs, handygccs }: 
  let 
    pkgs = import nixpkgs {
      inherit system;
    };
    xboxdrvConfig = ''
      [axismap]
      -Y1       = Y1
      -Y2       = Y2
      
      [evdev-absmap]
      ABS_HAT0X  = DPAD_X
      ABS_HAT0Y  = DPAD_Y
      
      ABS_X      = X1
      ABS_Y      = Y1
      
      ABS_RX     = X2
      ABS_RY     = Y2
      
      ABS_RZ     = RT
      ABS_Z      = LT
      
      [evdev-keymap]
      BTN_SOUTH  = A
      BTN_EAST   = B
      BTN_NORTH  = X
      BTN_WEST   = Y
      
      BTN_START  = start
      BTN_SELECT = back
      BTN_THUMBL = TL
      BTN_THUMBR = TR
      
      BTN_TR     = RB
      BTN_TL     = LB
      
      BTN_MODE   = guide
      
      # EOF #
    '';
    system = "x86_64-linux";
  in {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {
        name = "HandyGCCS";
        src = handygccs;
        buildInputs = [ i2c-tools ];
        buildPhase = ''echo "Copying python scripts to derivation"'';
        installPhase = ''
          mkdir -p $out/scripts
          mkdir -p $out/xboxdrv

          echo "${xboxdrvConfig}" > $out/xboxdrv/config

          cp usr/share/handygccs/scripts/constants.py $out/scripts
          cp usr/share/handygccs/scripts/handycon.py $out/scripts
        '';
      };

    nixosModules.handygccs = import ./modules/handygccs self.packages.x86_64-linux.default; 
    nixosModules.xboxdrv-handygccs = import ./modules/xboxdrv self.packages.x86_64-linux.default; 
  };
}
