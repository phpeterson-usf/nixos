# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hostname + networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone + locales
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11 + KDE Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # You explicitly disabled sway; leaving as-is
  programs.sway.enable = false;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Audio: PipeWire (with WirePlumber)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  # Optional, but often convenient:
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Shells / users
  programs.zsh.enable = true;

  users.users.phil = {
    isNormalUser = true;
    description = "Phil Peterson";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # per-user packages can go here, but Home Manager is usually better
    ];
  };

  # Firefox (module-managed)
  programs.firefox.enable = true;

  # Enable nix-ld to run dynamically linked binaries (e.g., uv's Python)
  programs.nix-ld.enable = true;

  # System packages (keep this small; prefer modules + Home Manager)
  environment.systemPackages = with pkgs; [
    curl
    git
    micro
    wl-clipboard
  ];

  # Nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Nix housekeeping
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Optional: enable SSH daemon for remote access (off by default)
  # services.openssh.enable = true;

  system.stateVersion = "25.11";
}
