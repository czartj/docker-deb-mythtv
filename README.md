# docker-deb-mythtv

A MythTV backend docker image built with: Debian slim, s6-overlay & Debian Multimedia Packages
<br>

Uses the **Environment variables** to configure the connection to the database:

    MYTH_DATABASE_NAME
    MYTH_DATABASE_HOST
    MYTH_DATABASE_PORT
    MYTH_DATABASE_USER
    MYTH_DATABASE_PASSWORD
    MYTH_DATABASE_NAME

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
