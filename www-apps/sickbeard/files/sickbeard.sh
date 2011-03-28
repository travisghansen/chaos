#!/bin/bash

SICKBEARD_PATH="/usr/share/sickbeard/SickBeard.py"
DEFAULT_DATADIR="${HOME}/.config/sickbeard"

python2 "${SICKBEARD_PATH}" --datadir="${DEFAULT_DATADIR}" $@
