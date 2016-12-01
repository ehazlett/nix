# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "dm_snapshot" ];
  boot.kernelModules = [ "kvm-intel" "fuse" "tun" "virtio" ];
  boot.extraModulePackages = [ ];
  boot.initrd.luks.devices = [
    { name = "root"; device = "/dev/sda2"; preLVM = true; allowDiscards = true; }
    { name = "swap"; device = "/dev/sda2"; preLVM = true; }
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/eca1415e-8199-44aa-96fd-87dd5b83499b";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AA99-30F7";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/x1-vg/swap";  }  ];

  nix.maxJobs = lib.mkDefault 4;
}
