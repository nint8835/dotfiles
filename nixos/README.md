# perdix

NixOS configuration for a Chuwi MiniBook X U300, using Niri, Noctalia and Home
Manager. ChezMoi ignores this directory.

## Apply

On perdix, from a checkout at `~/dotfiles`:

```sh
cd ~/dotfiles
git pull --ff-only
nix flake check --no-build ./nixos
sudo nixos-rebuild switch --flake "$HOME/dotfiles/nixos#perdix"
```

Run `git add` for new files before building. Home Manager owns `niri.kdl`;
Noctalia's generated colours and UI settings remain mutable.

## Update packages

```sh
cd ~/dotfiles/nixos
nix flake update nixpkgs
nix flake check --no-build
nix build --dry-run .#nixosConfigurations.perdix.config.system.build.toplevel
```

Review and commit `flake.lock`, then rebuild. Keep both `stateVersion` values
at `26.05`.

## Recovery

Select an earlier generation in Limine, or run:

```sh
sudo nixos-rebuild switch --rollback
```

The [60 Hz display override](firmware/u300/README.md) fixes panel corruption.
Remove the `display-60hz.nix` import and rebuild to return to stock timings.
