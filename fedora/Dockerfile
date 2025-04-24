FROM quay.io/fedora/fedora:42 as broken
RUN dnf install -y gamescope vulkan-tools

FROM broken as fixed
RUN rm -r /usr/lib64/libdecor/plugins-1
