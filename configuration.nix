{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  # i3wm hotkeys https://i3wm.org/docs/refcard.html
  services.xserver = {
    enable = true;
    autorun = false;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      startx.enable = true;
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        xclip
      ];
    };
    xkbModel = "microsoft";
    layout = "us,ru(winkeys)";
    xkbOptions = "grp:caps_toggle,grp_led:caps";
    xkbVariant = "winkeys";
  };

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.karen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "sound" "video" "networkmanager" "input" "tty" "docker" ];
    shell="/run/current-system/sw/bin/zsh";
  };

  nix.trustedUsers = [ "root" "karen" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    rxvt_unicode
    htop
    mc
    git
    google-chrome
    tdesktop
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "21.05";
}
