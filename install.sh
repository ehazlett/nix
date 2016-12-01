#!/usr/bin/env bash
FLAVOR=$1
if [ -z "$FLAVOR" ]; then
    echo "Usage: $0 <flavor>"
    exit 1
fi

cp -f $FLAVOR/configuration.nix /etc/nixos/configuration.nix
cp -f $FLAVOR/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
