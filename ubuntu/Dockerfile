FROM docker.io/ubuntu:25.04 as broken
RUN apt-get update  -y                        && \
    apt-get install -y gamescope vulkan-tools && \
    rm -r /var/lib/apt/lists/*
ENV PATH=/usr/games:$PATH

FROM broken as fixed
RUN rm -r /usr/lib/x86_64-linux-gnu/libdecor/plugins-1
