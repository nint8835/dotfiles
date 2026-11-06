# MiniBook X U300 panel timings, validated on perdix at 60 Hz.
# Original VBT, generation details, and validation: firmware/u300/README.md.
{ pkgs, ... }:

let
  panelFirmware = pkgs.runCommand "minibook-x-u300-panel-firmware" { } ''
    install -Dm644 ${./firmware/u300/chuwi-u300-60.bin} \
      "$out/lib/firmware/i915/chuwi-u300-60.bin"
  '';
in
{
  hardware.firmware = [ panelFirmware ];
  boot.initrd.extraFirmwarePaths = [ "i915/chuwi-u300-60.bin" ];
  boot.kernelParams = [ "i915.vbt_firmware=i915/chuwi-u300-60.bin" ];
}
