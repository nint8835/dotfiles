{
  description = "NixOS configuration for perdix";

  inputs = {
    # Follow release updates; flake.lock pins each reviewed revision.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Keep Noctalia's own nixpkgs input so its binary cache can be used.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-hardware, noctalia, noctalia-greeter, home-manager, ... }: {
    nixosConfigurations.perdix = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.chuwi-minibook-x
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
        home-manager.nixosModules.home-manager
        ./configuration.nix
      ];
    };
  };
}
