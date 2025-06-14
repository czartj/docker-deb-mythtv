#!/bin/sh


export PUID=$(echo "${PUID}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')
if [ ! -z "${PUID}" ]; then
        echo "[info] PUID defined as '${PUID}'"
else
        echo "[warn] PUID not defined (via -e PUID), defaulting to '1111'"
        export PUID="1111"
fi

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" mythtv &>/dev/null

export PGID=$(echo "${PGID}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')
if [ ! -z "${PGID}" ]; then
        echo "[info] PGID defined as '${PGID}'"
else
        echo "[warn] PGID not defined (via -e PGID), defaulting to '1111'"
        export PGID="1111"
fi

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" mythtv &>/dev/null

chown -R mythtv:mythtv /home/mythtv
