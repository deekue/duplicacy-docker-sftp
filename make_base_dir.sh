#!/bin/sh

[ -n "$1" -a -d "$1" ] || exit 1

STORAGE="$1/inbound"
KEY_DIR="$1/keys"

mkdir "$STORAGE" "$KEY_DIR"
