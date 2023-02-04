handygccs: { config, pkgs, lib ? pkgs.lib, ... }: 
with lib; 

let
  cfg = config.services.handygccs;
  python = pkgs.python310.withPackages(p: with p; [ evdev ]);
  path = "${pkgs.coreutils}/bin:${pkgs.gawk}/bin";

in
{
  options.services.handygccs = {
    enable = mkEnableOption "Enable HandyGCCS service";
  };
  
  config = mkIf cfg.enable {
    systemd.services.handygccs = {
      description = "Handheld Game Console Controller Support (Handy Geeks) for Linux";
      documentation = [ "https://github.com/ShadowBlip/HandyGCCS" ];
      after = [ "graphical-session.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = "PATH=${path}";
        Restart = "on-failure";
        ExecStart = "${python}/bin/python3 ${handygccs}/scripts/handycon.py";
      };
    };
  };
}
