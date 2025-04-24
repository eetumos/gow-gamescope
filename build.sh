#!/bin/sh
set -e

podman build --target=broken -t gow-fedora:broken "$@" fedora/
podman build --target=fixed  -t gow-fedora:fixed  "$@" fedora/

podman build --target=broken -t gow-ubuntu:broken "$@" ubuntu/
podman build --target=fixed  -t gow-ubuntu:fixed  "$@" ubuntu/

if ! [ -d gst-wayland-display ]
then
    git clone https://github.com/games-on-whales/gst-wayland-display
fi

cd gst-wayland-display
cargo cbuild
