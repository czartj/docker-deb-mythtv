#!/bin/sh

echo "------ init.sh ----------"
env
echo "-------------------------\n"

echo "starting simple-user-scripts..."
/usr/local/bin/sus /usr/local/etc/sus.d

echo "Something is wrong, we should never reach this point!!!"

