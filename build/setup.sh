#!/bin/bash

set -e
set -x
export DEBIAN_FRONTEND=noninteractive

cd /tmp/build

# needed for update-locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/environment

apt-get update && apt-get dist-upgrade -y && apt-get install -y \
    ca-certificates \
    wget \
    locales \
    gpgv \
    xmlstarlet \
    xz-utils

#Add 'mythtv' user & group
groupadd -rg 1111 mythtv && useradd -ru 1111 -md /home/mythtv -g mythtv mythtv && usermod -aG sudo mythtv

# for '/usr/share/mythtv/mythconverg_backup.pl' to work without TLS/SSL...
cat << EOF > /home/mythtv/.my.cnf
[client]
skip-ssl = true
EOF
chown mythtv:mythtv /home/mythtv/.my.cnf

wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb
dpkg -i deb-multimedia-keyring_2024.9.1_all.deb
cat << EOF > /etc/apt/sources.list.d/dmo.sources
Types: deb
URIs: https://www.deb-multimedia.org
Suites: trixie
Components: main non-free
Signed-By: /usr/share/keyrings/deb-multimedia-keyring.pgp
Enabled: yes

Types: deb
URIs: https://www.deb-multimedia.org
Suites: trixie-backports
Components: main
Signed-By: /usr/share/keyrings/deb-multimedia-keyring.pgp
Enabled: yes
EOF

rm deb-multimedia-*

apt-get update && apt-get dist-upgrade -y && \
apt-get clean && rm -rf /var/lib/apt/lists/*  /var/tmp/*
