{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./display-60hz.nix
  ];

  # Limine renders the portrait panel's boot menu in landscape.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    biosSupport = false;
    # The firmware prioritizes the standard EFI path over custom entries.
    efiInstallAsRemovable = true;
    style.interface.resolution = "1200x1920";
    extraConfig = ''
      interface_rotation: 90
    '';
    extraEntries = ''
      /systemd-boot (fallback)
        protocol: chainload
        path: boot():/EFI/systemd/systemd-bootx64.efi
    '';
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "perdix";
  networking.networkmanager.enable = true;
  time.timeZone = "America/St_Johns";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.xkb.layout = "us";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  users.users.nint8835 = {
    isNormalUser = true;
    description = "Riley Flynn";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;

  environment.systemPackages = [ pkgs.chezmoi ];

  programs.niri.enable = true;
  # Niri autostarts Noctalia; its dependencies are configured explicitly below.
  programs.noctalia.enable = true;
  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "nint8835" ];
    settings = {
      session.default = "niri";
      user.default = "nint8835";
      appearance = {
        scheme = "Synced";
      };
      output = {
        # Keep the panel orientation independent of appearance sync.
        use_synced_settings = false;
        transforms = "DSI-1:270";
        scales = "DSI-1:1.5";
      };
      keyboard.layout = "us";
      cursor = {
        theme = "Adwaita";
        size = 24;
        path = pkgs.adwaita-icon-theme;
      };
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    users.nint8835 = import ./home.nix;
  };

  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Initial installation compatibility version; keep this during upgrades.
  system.stateVersion = "26.05";
}
