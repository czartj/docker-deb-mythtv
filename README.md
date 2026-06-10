# docker-deb-mythtv

A MythTV backend (v35.0) docker image built with: Debian trixie-slim, s6-overlay & Debian Multimedia Packages
<br>

Uses the **Environment variables** to configure the connection to the database:

    MYTH_DATABASE_NAME
    MYTH_DATABASE_HOST
    MYTH_DATABASE_PORT
    MYTH_DATABASE_USER
    MYTH_DATABASE_PASSWORD
    MYTH_DATABASE_NAME

<br>

Extra **Environment variables** to set user/group (defaults to 1111/1111) ownership:

    PUID
    PGID

An example use:

```
docker run --name mythbackend \
        -v /srv/nfs/mythtv/dvr1:/srv/nfs/mythtv/dvr1 \
        -v /srv/nfs/mythtv/dvr0:/srv/nfs/mythtv/dvr0 \
        -v /srv/nfs/mythtv/dvr3:/srv/nfs/mythtv/dvr3 \
        -v /data/syncthing/data/xmltv/:/xmltv \
        -v /etc/localtime:/etc/localtime \
        -e "MYTH_DATABASE_HOST=odh2p" \
        -e "MYTH_DATABASE_PORT=3306" \
        -e "MYTH_DATABASE_USER=mythtv" \
        -e "MYTH_DATABASE_PASSWORD=mythtv" \
        -e "MYTH_DATABASE_NAME=mythconverg" \
        --network="host" \
        czartj/docker-deb-mythtv:latest   
```

<br>

For testing I use this docker-compose.yml:
```

version: "3"

services:
  mythtvt:
    image: czartj/docker-deb-mythtv:latest
    container_name: mythtvt
    hostname: mythtvt
    networks:
      macvlan:
        ipv4_address: 192.168.3.10
    environment:
      - MYTH_DATABASE_HOST=192.168.3.11
      - MYTH_DATABASE_PORT=3306
      - MYTH_DATABASE_USER=mythtv
      - MYTH_DATABASE_PASSWORD=mythtv
      - MYTH_DATABASE_NAME=mythconverg
      - MYTH_WEB_PORT=80 # for testing with image: czartj/docker-deb-mythtv-mythweb:latest
    volumes:
      - ./xmltv:/xmltv:z # used for guide data testing
      - /etc/localtime:/etc/localtime
      - /srv/nfs/mythtv/dvr1/mythtv_t1/:/srv/nfs/mythtv/dvr1/mythtv_t1/ # tmp recordings

  mariadb:
    image: mariadb:latest
    container_name: mythtvt_db
    environment:
      - MYSQL_ROOT_PASSWORD=msrootpassword
      - MYSQL_DATABASE=mythconverg
      - MYSQL_USER=mythtv
      - MYSQL_PASSWORD=mythtv
    volumes:
      - ./mysql/:/var/lib/mysql:z
    networks:
      macvlan:
        ipv4_address: 192.168.3.11

networks:
  macvlan:
    driver: macvlan
    name: mythtvt
    driver_opts:
      parent: br0  # Use host's network interface
    ipam:
      config:
        - subnet: 192.168.3.0/24
          gateway: 192.168.3.1

```
I allows me to test it on the same machine as the existing installation, but in a separate network space.  The web-setup should be available at http://192.168.3.10:6544 from another machine on the same network. If you need to test it on the same host you must create a macvlan to bridge to the hosts physical NIC to get around the 'macvlan' bridge/private mode.
```
# 1️⃣ Create a macvlan interface that bridges to your physical NIC
ip link add macvlan0 link br0 type macvlan mode bridge

# 2️⃣ Give the host an IP on the same subnet (any address not used by containers)
ip addr add 192.168.3.254/24 dev macvlan0

# 3️⃣ Bring the interface up
ip link set macvlan0 up
```