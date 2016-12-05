{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  hardware.enableKSM = true;

  # Set your time zone.
  time.timeZone = "UTC";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    curl
    git
    i3
    i3lock
    i3status
    bashCompletion
    slim
    vde2
    qemu
    dmenu
    vim
    cryptsetup
    wpa_supplicant
    networkmanager
    tunctl
    greybird
    gnupg1compat
    pkgs._9pfs
    pkgs.bridge-utils
    pkgs.xfce.terminal
    pkgs.xfce.xfce4settings
    pkgs.xfce.xfwm4
    pkgs.gnome3.adwaita-icon-theme
    pkgs.gtk-engine-murrine
  ];
  environment.sessionVariables.TERMINAL = "xfce4-terminal";
  environment.sessionVariables.GPG_TTY = "tty";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.hatter = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    extraGroups = [ "audio" "kvm" "vde2-net" "wheel" "networkmanager" ];
    initialPassword = "hatter";
  };

  users.extraGroups.kvm = {
    members = [ "hatter" ];
  };

  users.extraGroups.hatter = {
    members = [ "hatter" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  security.sudo.extraConfig =
    ''
    hatter * = (root) NOPASSWD: /usr/local/bin/screen-backlight, /usr/local/bin/keyboard-backlight, /usr/local/bin/keyboard-i3-switch, /run/current-system/sw/bin/wpa_supplicant, /run/current-system/sw/bin/pkill, /run/current-system/sw/bin/tee, /run/current-system/sw/bin/chvt, /usr/local/bin/runc, /usr/local/bin/containerd, /usr/local/bin/ocitools, /run/current-system/sw/bin/qemu-img, /run/current-system/sw/bin/qemu-system-x86_64
    '';
}
