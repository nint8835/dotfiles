# Display firmware

`display-60hz.nix` generates and hash-checks a 60 Hz panel table from
`original-50hz.vbt`, then includes it in the initramfs. This experimental override
is specific to perdix's tested U300 panel and BIOS revision.

The generator comes from [minibookx-ctl](https://github.com/ishad0w/minibookx-ctl/tree/b4a9fbbd3635a33669307cf89c97c40c03262e87/contrib/vbt)
under Apache-2.0; see `GENERATOR-LICENSE`.

To restore stock 50 Hz timings, remove the `display-60hz.nix` import and rebuild.
