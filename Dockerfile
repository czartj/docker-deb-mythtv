FROM debian:trixie-slim
ARG S6_OVERLAY_VERSION=3.2.1.0

#ENV TERM=xterm
#ENV LANG=en_US.UTF-8
#ENV LANGUAGE=en_US:en
#ENV LC_ALL=en_US.UTF-8

COPY build/ /tmp/build
RUN /tmp/build/setup.sh

RUN \
    apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mythtv-backend xmlstarlet

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

# Add our files...
ADD rootfs /

EXPOSE 6544/tcp
EXPOSE 6543/tcp
EXPOSE 6549/tcp
EXPOSE 6554/tcp
EXPOSE 6744/tcp
EXPOSE 1900/udp

ENV S6_CMD_USE_TERMINAL=1
ENV PATH="/command:${PATH}"
ENTRYPOINT ["/init"]

