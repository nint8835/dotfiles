# perdix

Chuwi MiniBook X U300 running NixOS, Niri and Noctalia.

## Apply

From a checkout at `~/dotfiles` on perdix, initialize once with
`chezmoi --source ~/dotfiles init`. Then:

```sh
cd ~/dotfiles
git pull --ff-only
nix flake check --no-build ./nixos
sudo nixos-rebuild switch --flake ./nixos#perdix
chezmoi apply
```

Stage new files with `git add` before building.

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

Panel timing override and recovery: [display firmware](firmware/u300/README.md).
