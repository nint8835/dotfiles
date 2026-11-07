# MiniBook X U300 display firmware

`display-60hz.nix` generates the 60 Hz panel table from perdix's original
`original-50hz.vbt`, checks its hash, and includes it in the initramfs.
The generated firmware matches the table tested on perdix. No manual generation
or kernel compilation is needed.

The generator is from [minibookx-ctl](https://github.com/ishad0w/minibookx-ctl/tree/b4a9fbbd3635a33669307cf89c97c40c03262e87/contrib/vbt),
under Apache-2.0; see `GENERATOR-LICENSE`. It rejects unrecognised input tables.
This experimental timing is specific to the tested U300 panel and BIOS revision.

To restore stock 50 Hz timings, remove the `display-60hz.nix` import and rebuild.
