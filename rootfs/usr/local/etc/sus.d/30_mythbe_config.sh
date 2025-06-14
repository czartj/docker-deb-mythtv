#!/bin/sh

echo "Setting up mythtv config..."

cat << EOF > /tmp/config.xml
<?xml version="1.0"?>
<Configuration>
  <LocalHostName>mbe</LocalHostName>
  <Database>
    <PingHost>true</PingHost>
    <Host>localhost</Host>
    <UserName>mythtv</UserName>
    <Password>mythtv</Password>
    <DatabaseName>mythconverg</DatabaseName>
    <Port>3306</Port>
  </Database>
</Configuration>
EOF

xmlstarlet ed -L -u "/Configuration/LocalHostName" -v "$HOSTNAME" /tmp/config.xml


if [ -n ${MYTH_DATABASE_HOST} ]; then
    xmlstarlet ed -L -u "/Configuration/Database/Host" -v "$MYTH_DATABASE_HOST" /tmp/config.xml
fi

if [ -n ${MYTH_DATABASE_NAME} ]; then
    xmlstarlet ed -L -u "/Configuration/Database/DatabaseName" -v "$MYTH_DATABASE_NAME" /tmp/config.xml
fi


if [ -n ${MYTH_DATABASE_PASSWORD} ]; then
    xmlstarlet ed -L -u "/Configuration/Database/Password" -v "$MYTH_DATABASE_PASSWORD" /tmp/config.xml 
fi

if [ -n ${MYTH_DATABASE_USER} ]; then
    xmlstarlet ed -L -u "/Configuration/Database/UserName" -v "$MYTH_DATABASE_USER" /tmp/config.xml
fi

if [ -n ${MYTH_DATABASE_PORT} ]; then
    xmlstarlet ed -L -u "/Configuration/Database/Port" -v "$MYTH_DATABASE_PORT" /tmp/config.xml
fi

mv /tmp/config.xml /home/mythtv/.mythtv


