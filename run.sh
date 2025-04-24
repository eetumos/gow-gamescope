#!/bin/sh
set -e

usage() {
    echo "usage: DISTRO STATE METHOD WAYLAND_TARGET"
    echo
    echo "DISTRO:         fedora|ubuntu"
    echo "STATE:          broken|fixed"
    echo "METHOD:         direct|gamescope"
    echo "WAYLAND_TARGET:   host|gst"

    exit 1
}

case "$1" in
    fedora|ubuntu) IMAGE=gow-$1 ;;
    *)             usage
esac

case "$2" in
    broken|fixed) IMAGE=$IMAGE:$2 ;;
    *)            usage
esac

case "$3" in
    direct)    CMD="vkcube --wsi wayland" ;;
    gamescope) CMD="gamescope vkcube"     ;;
    *)         usage
esac

case "$4" in
    host) TARGET_WAYLAND_DISPLAY=$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY ;;
    gst)  TARGET_WAYLAND_DISPLAY=$XDG_RUNTIME_DIR/wayland-1        ;;
    *)    usage
esac

./build.sh

if [ "$4" = "gst" ]
then
    GST_PLUGIN_PATH=$PWD/gst-wayland-display/target/x86_64-unknown-linux-gnu/debug gst-launch-1.0 waylanddisplaysrc ! 'video/x-raw,width=1280,height=720,format=RGBx,framerate=60/1' ! waylandsink &
    sleep 1
fi

podman run --rm --ipc=host -v $TARGET_WAYLAND_DISPLAY:/w:Z -e XDG_RUNTIME_DIR=/ -e WAYLAND_DISPLAY=/w --device=nvidia.com/gpu=all $IMAGE $CMD &

wait
