# U300 60 Hz panel timings

This directory contains perdix's original VBT and the generator used to derive
the tested panel table during the Nix build. The normal NixOS configuration
enables this tested override through `display-60hz.nix`.
No BIOS flashing is involved; the existing i915 driver loads the table at boot.

The upstream guide reports that a 60 Hz timing eliminated startup corruption
on its tested U300. It is experimental: the panel's rated maximum is unknown,
and its pixel clock rises about 20% compared with stock 50 Hz. An exact input
match is a compatibility check, not a guarantee of safety or reliability.

- Source: https://github.com/ishad0w/minibookx-ctl
- Generator revision: `b4a9fbbd3635a33669307cf89c97c40c03262e87`
- Generator: `contrib/vbt/build_vbt.py`, copied here with its Apache-2.0 license.
- Original table: `original-50hz.vbt` (10,752 bytes).
- Original SHA-256: `0d6ab7c6349a8845969cc04561beee5d96de0cd566dacd5747605346d598d7cd`.
- Generated 60 Hz table: `chuwi-u300-60.bin` (not committed).
- 60 Hz SHA-256: `2f04a83ff7f10ab339cda63642958e58273d842c70c59a704c4056ae51a03567`.
- The generator emits `manifest.json` with the modes and byte changes; it is
  generated alongside the firmware and is not committed.

The reviewed generator accepted the exact stock input and verified its output
hash and checksum. Only offsets 26, 8035, and 8036 change in the 60 Hz table.
Only the 60 Hz table is installed; the other generated outputs are discarded.

To reproduce the files without touching hardware, run from the repository root:

```sh
python3 nixos/firmware/u300/build_vbt.py --input nixos/firmware/u300/original-50hz.vbt --output /tmp/perdix-vbt-new
```

NixOS equivalent of the guide's firmware/initramfs steps is in
`../../display-60hz.nix`: run the generator in a sandbox with Python, verify the
60 Hz output hash, package it under `lib/firmware`, add its relative
path to `boot.initrd.extraFirmwarePaths`, and select it using
`i915.vbt_firmware`. The existing orientation arguments are preserved.

`configuration.nix` imports this module directly. Use the normal Git-based
rebuild workflow from `nixos/README.md`; no manual generation step is needed.
The build needs only the committed original VBT and generator, with no hardware
access or network fetch for the firmware.
This reuses the stock kernel and does not enable `boot.kernelPatches`.

The normal configuration no longer defines a separate `panel-60hz` entry.
Earlier generations and their historical variants remain available in Limine;
the systemd-boot fallback also retains the earlier normal 50 Hz entries.
To return to stock timings, remove the `display-60hz.nix` import
and rebuild, or boot one of those earlier generations. The override is read
at boot.

Validation: the compatibility check passed for perdix; the optional system built
with the exact installed stock kernel, and the final initramfs was inspected.
Its compressed `chuwi-u300-60.bin.zst` decompresses to the expected SHA-256 above.
On 2026-10-31 the user confirmed the physical display was working with the
60 Hz entry. The active kernel command line selected this VBT, Intel display
diagnostics reported 1200×1920 at 60 Hz (165920 kHz pixel clock), and the boot
log contained no `DSI link not ready` error. Repeated cold starts and
suspend/resume validation have not been recorded.

On 2026-11-06 the Nix generation derivation and full system build passed on
perdix. Both its firmware output and the firmware extracted from the new
initramfs matched the tested 60 Hz SHA-256 byte-for-byte. The existing stock
kernel was reused.
