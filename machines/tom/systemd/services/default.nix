# https://github.com/systemd/systemd
{ pkgs }:
{
  systemd.services = {
    nvidia-control-devices = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
      };
    };
  };
  systemd.user.services = {
    "github:etime" = {
      documentation = [ "https://github.com/zimeg/emporia-time" ];
      wantedBy = [ "default.target" ];
      path = [ pkgs.git pkgs.nix pkgs.time ];
      serviceConfig = {
        ExecStart = "${pkgs.nix}/bin/nix develop .#gh --command bash -c \"run.sh\"";
        Restart = "always";
        RestartSec = 2;
        WorkingDirectory = /home/ez/programming/etime/.github/runners;
      };
      unitConfig = {
        ConditionPathExists = /home/ez/programming/etime/.github/runners/.gitignore;
        StartLimitBurst = 12;
        StartLimitIntervalSec = 24;
      };
    };
    "minecraft:server" = {
      documentation = [ "https://github.com/zimeg/minecraft" ];
      wantedBy = [ "default.target" ];
      path = [ pkgs.git pkgs.nix pkgs.time ];
      serviceConfig = {
        ExecStart = "${pkgs.nix}/bin/nix develop --command bash -c \"minecraft-server\"";
        Restart = "always";
        RestartSec = 2;
        WorkingDirectory = /home/ez/games/minecraft/server;
      };
      unitConfig = {
        ConditionPathExists = /home/ez/games/minecraft/server/server.properties;
        StartLimitBurst = 12;
        StartLimitIntervalSec = 24;
      };
    };
    "slack:snaek" = {
      documentation = [ "https://github.com/zimeg/slack-sandbox" ];
      wantedBy = [ "default.target" ];
      path = [ pkgs.git ];
      serviceConfig = {
        EnvironmentFile = /home/ez/programming/slack/sandbox/py.bolt.snaek/.env.production;
        ExecStart = "${pkgs.nix}/bin/nix develop --command bash -c \"python3 app.py\"";
        Restart = "always";
        RestartSec = 2;
        WorkingDirectory = /home/ez/programming/slack/sandbox/py.bolt.snaek;
      };
      unitConfig = {
        ConditionPathExists = /home/ez/programming/slack/sandbox/py.bolt.snaek/slack.json;
        StartLimitBurst = 12;
        StartLimitIntervalSec = 24;
      };
    };
  };
}
