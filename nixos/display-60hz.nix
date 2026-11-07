# MiniBook X U300 panel timings, validated on perdix at 60 Hz.
# Original VBT, generation details, and validation: firmware/u300/README.md.
{ pkgs, ... }:

let
  panelFirmware = pkgs.runCommand "minibook-x-u300-panel-firmware" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    python3 ${./firmware/u300/build_vbt.py} \
      --input ${./firmware/u300/original-50hz.vbt} \
      --output generated

    # Require byte identity with the 60 Hz table tested on perdix.
    echo "2f04a83ff7f10ab339cda63642958e58273d842c70c59a704c4056ae51a03567  generated/chuwi-u300-60.bin" \
      | sha256sum --check --status
    install -Dm644 generated/chuwi-u300-60.bin \
      "$out/lib/firmware/i915/chuwi-u300-60.bin"
  '';
in
{
  hardware.firmware = [ panelFirmware ];
  boot.initrd.extraFirmwarePaths = [ "i915/chuwi-u300-60.bin" ];
  boot.kernelParams = [ "i915.vbt_firmware=i915/chuwi-u300-60.bin" ];
}
