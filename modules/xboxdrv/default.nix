handygccs: { config, pkgs, lib ? pkgs.lib, ... }: 
with lib; 

let
  cfg = config.services.xboxdrv-handygccs;
  path = "${pkgs.coreutils}/bin:${pkgs.xorg.xinput}/bin";
in
{
  options.services.xboxdrv-handygccs = {
    enable = mkEnableOption "Enable Xboxdrv service for HandyGCCS controller";
  };
  
  config = mkIf cfg.enable {

    systemd.services.xboxdrv-handygccs = {
      description = "Maps HandyGCCS control outputs to a virtual Xbox Controller";
      after = [ "graphical-session.target" "dev-gamepad.device" ];
      requires = [ "dev-gamepad.device" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ConditionPathExists="/dev/gamepad";
        Environment = "PATH=${path}";
        Restart = "on-failure";
        ExecStart = ''
          ${pkgs.xboxdrv}/bin/xboxdrv --silent --evdev /dev/gamepad --config ${handygccs}/xboxdrv/config --evdev-no-grab
        '';
      };
    };
  };
}
