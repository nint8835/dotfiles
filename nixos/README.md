# perdix

NixOS configuration for `nint8835@192.168.1.90`, a Chuwi MiniBook X U300
(`x86_64-linux`). The `nixos/` directory in this Git repository is the source
of truth. ChezMoi ignores it; deploy directly from a checkout on perdix.
The previous `/etc/nixos` copy is retained as a migration backup.

| File | Purpose |
| --- | --- |
| `flake.nix`, `flake.lock` | Pinned inputs and `nixosConfigurations.perdix` |
| `configuration.nix` | Machine services, user account, bootloader and desktop |
| `hardware-configuration.nix` | Generated disk and hardware configuration |
| `home.nix` | Home Manager user settings |
| `niri.kdl` | Niri layout, startup and keyboard shortcuts |
| `display-60hz.nix`, `firmware/u300/` | Working panel timing override and reproduction files |

## Rebuild and deploy

Clone `git@github.com:nint8835/dotfiles.git` to `~/dotfiles` on perdix and check
out the branch containing this configuration. From the repository root:

```sh
cd ~/dotfiles
git pull --ff-only
nix flake check --no-build ./nixos
nix build --dry-run ./nixos#nixosConfigurations.perdix.config.system.build.toplevel
sudo nixos-rebuild switch --flake "$HOME/dotfiles/nixos#perdix"
```

Both system and Home Manager changes are applied by this command. Git-backed
flakes include only tracked files: run `git add` for new files before evaluating
or building, including any newly added firmware or configuration files. Commit
`flake.lock` so every machine uses the same input revisions. Review and commit
changes on a working branch before deploying them.

The flat layout is intentional; relative imports and the display firmware paths
remain unchanged. ChezMoi and Home Manager must not manage the same destination
files. Noctalia's generated colours and mutable UI settings remain outside Git.

## Release updates

Nixpkgs tracks `nixos-26.05`, with the selected revision pinned in `flake.lock`.
On perdix, update just this release input as your normal user:

```sh
cd ~/dotfiles/nixos
nix flake update nixpkgs
nix flake check --no-build
nix build --dry-run .#nixosConfigurations.perdix.config.system.build.toplevel
git diff -- flake.lock
git add flake.lock
git commit -m "Update NixOS release packages"
sudo nixos-rebuild switch --flake "$HOME/dotfiles/nixos#perdix"
```

Review the build plan first; stock kernels should be fetched from the binary
cache. Push the commit and pull it in other checkouts instead of copying lock
files between folders. Other inputs remain locked unless explicitly updated.
Updates are manual. Keep both `system.stateVersion` and `home.stateVersion` at
`26.05` during ordinary upgrades.

## Desktop and user configuration

Noctalia Greeter starts Niri after sign-in; Niri starts Noctalia. NetworkManager,
Bluetooth, Tuned, UPower and PipeWire are configured explicitly. Noctalia keeps
its own nixpkgs input so its official binary cache can be used.

Home Manager follows the system nixpkgs input and manages
`~/.config/niri/config.kdl` from `niri.kdl`. Edit user settings in `home.nix` and
apply them with the system rebuild command above. The standalone Home Manager
CLI is not installed. Conflicting unmanaged files are backed up with a
`.hm-backup` suffix. Noctalia's UI settings remain editable under
`~/.config/noctalia/`.

When Noctalia's Niri colour integration is enabled, it writes
`~/.config/niri/noctalia.kdl`. The managed main config includes that file last
and optionally, so generated colours override the defaults without Home Manager
managing or replacing the generated file.

Greeter appearance follows Noctalia using its Auto-Sync Greeter setting
(Settings → Security → Noctalia Greeter). The NixOS module permits appearance
sync for `nint8835` in an active local session and selects the Synced scheme.
Synced wallpaper and colours live under `/var/lib/noctalia-greeter/`; the
greeter's panel rotation and scaling remain declared in `configuration.nix`.

Noctalia's wallpaper picker scans `~/Pictures` by default. Home Manager provides
four NixOS wallpapers there, including a red colour-generation test option;
add your own images alongside them, then reopen
the picker. You can choose another wallpaper directory in Noctalia's settings.

| Shortcut | Action |
| --- | --- |
| Super+D or Super+Space | Launcher |
| Super+S | Control center |
| Super+Shift+Comma | Noctalia settings |
| Super+Alt+L | Lock screen |
| Super+Shift+/ | Niri shortcuts; startup popup is disabled |
| Media, volume and brightness keys | Noctalia controls |

The retained Super+T binding expects Alacritty, which is not installed yet.
Choose/install a terminal through Home Manager before relying on that binding.

## Display and boot menu

The 60 Hz VBT override uses the stock kernel. Its exact supported input table,
generator, license, checksums and validation details are in
[firmware/u300/README.md](firmware/u300/README.md). Keep those files for
reproduction and recovery. No custom kernel patch is needed.

Limine renders the generation menu with a `1200x1920` framebuffer rotated 90°.
It installs at `/EFI/BOOT/BOOTX64.EFI` because firmware resets custom boot-order
preferences. Removing the competing systemd-boot registration and using this
standard path was confirmed across an ordinary reboot. No boot-selection
startup service or one-time override is used. The BIOS itself is already upright.

## Recovery

Previous generations remain available in Limine. `systemd-boot (fallback)`
chains into the preserved `/EFI/systemd/systemd-bootx64.efi` recovery menu;
that menu is a snapshot of the pre-migration generations.

```sh
sudo nixos-rebuild switch --rollback
```

Rollback changes the active generation, not the files in the Git checkout. Earlier
50 Hz generations can recover stock panel timings; removing the
`display-60hz.nix` import and rebuilding also restores them.

Migration backups remain outside the active configuration at `/etc/nixos.pre-*`
and `/var/backups/nixos-*`. Firmware-loader backups include
`/var/backups/nixos-limine-selection-20261031-155523`. The original Niri file was
also saved at `~/.config/niri/config.kdl.pre-home-manager-20261031-160349`.

## References

- [Home Manager NixOS integration](https://github.com/nix-community/home-manager/blob/release-26.05/docs/manual/nix-flakes/nixos.md)
- [Noctalia NixOS setup](https://docs.noctalia.dev/noctalia/getting-started/nixos/)
- [Noctalia Greeter](https://docs.noctalia.dev/greeter/installation/)
- [Limine configuration](https://github.com/Limine-Bootloader/Limine/blob/v12.x/CONFIG.md)
