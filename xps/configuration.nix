{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  networking = {
    hostName = "xps";
    firewall.enable = false;
    networkmanager.enable = true;
    localCommands =
      ''
        ${pkgs.vde2}/bin/vde_switch -tap vm0 -mod 660 -group kvm -daemon
      	ip addr add 10.255.0.1/24 dev vm0
      	ip link set dev vm0 up
        ${pkgs.procps}/sbin/sysctl -w net.ipv4.ip_forward=1
        ${pkgs.iptables}/sbin/iptables -t nat -A POSTROUTING -s 10.255.0.0/24 -j MASQUERADE
      '';
  };
}
