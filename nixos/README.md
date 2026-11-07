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

## PragmataPro

Before the first rebuild, download your purchased [PragmataPro archive](https://fsd.it/shop/fonts/pragmatapro/)
outside this checkout and import it on perdix:

```sh
nix-store --add-fixed sha256 ~/Downloads/PragmataPro-fialk8-6rjkhe.zip
```

For updates, change the filename, version and hash in
[the package](packages/pragmatapro.nix), then import the new archive. Get its hash
with `nix hash file /path/to/archive.zip`.

Keep the archive and packaged font out of Git and public binary caches.
Restart applications after rebuilding.

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
