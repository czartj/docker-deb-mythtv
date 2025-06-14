#!/bin/bash

set -e
set -x
DEBIAN_FRONTEND=noninteractive

cd /tmp/build

apt-get update && apt-get dist-upgrade -y && apt-get install -y \
    ca-certificates \
    wget \
    locales \
    xz-utils

#    tmux \
#    ncdu \
#    tree \
#    nano \
#    screen \

#sed -i '/en_US.UTF-8/s/^#\s*//' /etc/locale.gen
#locale-gen 
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

#Add 'mythtv' user & group
groupadd -rg 1111 mythtv && useradd -ru 1111 -md /home/mythtv -g mythtv mythtv && usermod -aG sudo mythtv

wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb
dpkg -i deb-multimedia-keyring_2024.9.1_all.deb
cat << EOF > /etc/apt/sources.list.d/dmo.sources
Types: deb
URIs: https://www.deb-multimedia.org
Suites: bookworm
Components: main non-free
Signed-By: /usr/share/keyrings/deb-multimedia-keyring.pgp
Enabled: yes

Types: deb
URIs: https://www.deb-multimedia.org
Suites: bookworm-backports
Components: main
Signed-By: /usr/share/keyrings/deb-multimedia-keyring.pgp
Enabled: yes
EOF

rm deb-multimedia-*

apt-get update && apt-get dist-upgrade -y && \
apt-get clean && rm -rf /var/lib/apt/lists/*  /var/tmp/*
