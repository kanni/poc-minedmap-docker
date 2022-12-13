#!/usr/bin/env sh

set -e

SAVEGAME_DIR=/savegame
VIEWER_DIR=/home/minecraft/minedmap-source/viewer
MAPDATA_DIR=${VIEWER_DIR}/data

if [ ! -d "${SAVEGAME_DIR}" ]; then
	echo "No savegame found at ${SAVEGAME_DIR}, exiting." 
	exit 1
fi

echo "Ensuring map data directory exists..."
mkdir -p "${MAPDATA_DIR}"

echo "Running inital map generation..."
/usr/local/bin/MinedMap "${SAVEGAME_DIR}" "${MAPDATA_DIR}"

echo "Adding cronjob..."
echo "*/5 * * * * /usr/local/bin/MinedMap \"${SAVEGAME_DIR}\" \"${MAPDATA_DIR}\"" > /etc/crontabs/minecraft

echo "Starting crond..."
crond &

echo "Starting webserver..."
caddy file-server --root "${VIEWER_DIR}" --listen 0.0.0.0:80

