{ pkgs, ... }: 
''
  #Fetches the device id of the evdev controller created by handycon
  CONTROLLER_DEVICE_ID=${pkgs.xorg.xinput}/bin/xinput | ${pkgs.coreutils}/bin/grep -Eow "Handheld\sController\s+id=[0-9]+" | ${pkgs.coreutils}/bin/grep -Eow "[0-9]+"
  ${pkgs.xboxdrv}/bin/xboxdrv --silent --evdev /dev/input/event''${CONTROLLER_DEVICE_ID} --config $out/xboxdrv/config;
''
