{ pkgs, ... }:

{
  # Initial Home Manager compatibility version; keep this on future upgrades.
  home.stateVersion = "26.05";

  xdg.enable = true;

  # Noctalia scans Pictures by default. Keep individual files managed so users
  # can add their own images alongside this starter collection.
  home.file = {
    "Pictures/NixOS-dark.png".source =
      pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
    "Pictures/NixOS-blue.png".source =
      pkgs.nixos-artwork.wallpapers.simple-blue.gnomeFilePath;
    "Pictures/NixOS-red.png".source =
      pkgs.nixos-artwork.wallpapers.simple-red.gnomeFilePath;
    "Pictures/NixOS-nineish.png".source =
      pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
  };
}
