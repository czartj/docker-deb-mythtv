#!/bin/sh

echo "Starting mythbackend..."
/command/s6-svc -u /run/service/mythbackend
