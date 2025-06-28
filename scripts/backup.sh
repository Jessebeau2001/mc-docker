#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <INPUT FOLDER> <OUTPUT FOLDER> [PREFIX]"
  exit 1
fi

IN_FOLDER="$1"
OUT_FOLDER="$2"
PREFIX="$3"

if [ ! -d "$IN_FOLDER" ]; then
    echo "Error: Input folder '$IN_FOLDER' does not exist."
    exit 2
fi

if [ ! -d "$OUT_FOLDER" ]; then
    echo "Error: Output folder '$OUT_FOLDER' does not exist."
    exit 2
fi

# Set prefix or generate one
BASENAME="$(basename "$IN_FOLDER")"
if [ -z "$PREFIX" ]; then
    PREFIX="${BASENAME}-"
fi

DATE=$(date +"%Y-%m-%d")
COUNTER=1

# Find first available index for today
while :; do
    if [ "$COUNTER" -eq 1 ]; then
        FILENAME="${PREFIX}${DATE}.tar.gz"
    else
        FILENAME="${PREFIX}${DATE}-${COUNTER}.tar.gz"
    fi
    OUT_FILE="$OUT_FOLDER/$FILENAME"
    if [ ! -f "$OUT_FILE" ]; then
        break
    fi
    COUNTER=$((COUNTER + 1))
done

IN_DIR="$(dirname "$IN_FOLDER")"
IN_BASE="$(basename "$IN_FOLDER")"

tar cvzf "$OUT_FILE" -C "$IN_DIR" "$IN_BASE"
echo "Backup created at: $OUT_FILE"