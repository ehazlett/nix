{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "alice";
    firewall.enable = false;
    networkmanager.enable = true;
    localCommands =
      ''
        ${pkgs.vde2}/bin/vde_switch -tap tap0 -mod 660 -group kvm -daemon
      	ip addr add 10.255.0.1/24 dev tap0
      	ip link set dev tap0 up
        ${pkgs.procps}/sbin/sysctl -w net.ipv4.ip_forward=1
        ${pkgs.iptables}/sbin/iptables -t nat -A POSTROUTING -s 10.255.0.0/24 -j MASQUERADE
      '';
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

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

  users.extraGroups.kvm = {
    members = [ "hatter" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.hatter = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    extraGroups = [ "audio" "kvm" "vde2-net" "wheel" "networkmanager" ];
    initialPassword = "hatter";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

}
