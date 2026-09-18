# Diagnostics for the recurring Xid 62 (GPU micro-controller halt) crashes in
# games. Same fault across 580/595 proprietary+open drivers.
#
# 2026-09-15: crashed at a 250 W cap with power flat -> PSU ruled out. Core was
# pegged at 83 C (Ampere thermal target) with fans stuck at 61%; GDDR6X likely
# 100+ C. Now suspecting cooling / thermal pads. Three pieces:
#   1. LACT: aggressive fan curve (nvidia-smi can't drive fans on Wayland) and
#      a 200 W cap so the card runs well below its thermal limit.
#   2. nvidia-smi oneshot as a fallback for the cap in case LACT's GPU id is
#      wrong and its settings silently don't apply.
#   3. Log power/temps/clocks/fan once a second (fdatasync'd) so a crash leaves
#      telemetry on disk: /var/log/nvidia-telemetry.csv
{
  config,
  pkgs,
  ...
}: let
  nvidia-smi = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi";
  powerLimitW = 320;
  logFile = "/var/log/nvidia-telemetry.csv";
  fields = "timestamp,power.draw,power.limit,temperature.gpu,clocks.sm,clocks.mem,utilization.gpu,utilization.memory,memory.used,fan.speed,pstate,clocks_event_reasons.active,pcie.link.gen.current,pcie.link.width.current";

  # Written by hand rather than via `services.lact.settings`: nixpkgs' YAML
  # writer quotes the numeric curve keys ('40': 0.3) and LACT's parser rejects
  # quoted scalars as integers, which would make the whole config fail to load.
  # GPU id is from /sys/bus/pci/devices/0000:2d:00.0/{vendor,device,subsystem_*};
  # verify with `lact cli list-gpus` if settings don't seem to apply.
  lactConfig = pkgs.writeText "lact-config.yaml" ''
    # version 7 = current schema; skips migrations that would try to rewrite
    # the (read-only) config. log_level is required despite docs saying otherwise.
    version: 7
    daemon:
      log_level: info
      admin_group: wheel
    gpus:
      10DE:2206-10DE:1467-0000:2d:00.0:
        power_cap: ${toString powerLimitW}.0
        fan_control_enabled: true
        fan_control_settings:
          mode: curve
          temperature_key: edge
          interval_ms: 500
          curve:
            40: 0.3
            55: 0.45
            65: 0.65
            72: 0.85
            78: 1.0
          spindown_delay_ms: 5000
          change_threshold: 2
  '';
in {
  services.lact.enable = true;
  environment.etc."lact/config.yaml".source = lactConfig;
  systemd.services.lactd.restartTriggers = [lactConfig];

  systemd.services.nvidia-power-limit = {
    description = "Cap NVIDIA GPU power limit to ${toString powerLimitW} W";
    wantedBy = ["multi-user.target" "post-resume.target"];
    after = ["systemd-modules-load.service" "post-resume.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nvidia-smi} --power-limit=${toString powerLimitW}";
    };
  };

  systemd.services.nvidia-telemetry = {
    description = "Log NVIDIA GPU power/thermal/clock telemetry to ${logFile}";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      ExecStart = pkgs.writeShellScript "nvidia-telemetry" ''
        set -u
        f=${logFile}
        [ -s "$f" ] || echo "${fields}" > "$f"
        while :; do
          ${nvidia-smi} --query-gpu=${fields} --format=csv,noheader >> "$f"
          ${pkgs.coreutils}/bin/sync --data "$f"
          ${pkgs.coreutils}/bin/sleep 1
        done
      '';
    };
  };

  services.logrotate.settings.nvidia-telemetry = {
    files = logFile;
    frequency = "daily";
    rotate = 7;
    compress = true;
    missingok = true;
    notifempty = true;
  };
}
