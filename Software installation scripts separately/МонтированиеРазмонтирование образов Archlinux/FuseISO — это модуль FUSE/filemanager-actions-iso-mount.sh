#!/bin/sh

FILE=$(basename "$1")
MOUNTPOINT="$HOME/Desktop/$FILE"

fuseiso -p "$1" "$MOUNTPOINT"