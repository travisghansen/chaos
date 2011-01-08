#!/bin/bash

# helper function

die() {
	echo $1
	exit 1
}

echo_pound_line() {
	local i=0
	local width=80
	while [ $i -lt $(($width+1)) ];do
		echo -n "#"
		i=$(($i+1))
	done
	echo ""
}

handle_signal() {
	echo ""
	echo "Goodbye!"
	exit 1
}

trap handle_signal SIGINT SIGTERM

HANDBRAKE_BINARY="HandBrakeCLI"
HANDBRAKE_OPTIONS=""

SAVE_PATH=$(realpath `pwd`)

DEFAULT_PRESET="High Profile"
DEFAULT_SOURCE="/dev/sr0"
DEFAULT_FORMAT="mkv"
DEFAULT_SHOW_TITLE="Unknown"
DEFAULT_SEASON="XX"
DEFAULT_TITLE_NUMBERS="1"

echo -n "Enter the source (eg /dev/sr0 default: ${DEFAULT_SOURCE}): "
read -r SOURCE
if [ -z "${SOURCE}" ];then
	SOURCE="${DEFAULT_SOURCE}"
fi
echo ""

echo -n "Enter show title (eg \"Arrested.Development\", default: ${DEFAULT_SHOW_TITLE}): "
read -r SHOW_TITLE
if [ -z "${SHOW_TITLE}" ];then
	SHOW_TITLE="${DEFAULT_SHOW_TITLE}"
fi
echo ""

echo -n "Enter a season number (default: ${DEFAULT_SEASON}): "
read -r SEASON
if [ -z "${SEASON}" ];then
	SEASON="${DEFAULT_SEASON}"
fi
echo ""

echo "Scanning source \"${SOURCE}\" for source info"
SCAN_DATA=$("${HANDBRAKE_BINARY}" -i "${SOURCE}" --title "0" --scan 2>&1 || die "cannot scan ${SOURCE}")
echo "${SCAN_DATA}"
echo ""
echo ""

echo -n "Select the titles you want to encode (space separated default: ${DEFAULT_TITLE_NUMBERS}): "
read -r TITLE_NUMBERS
if [ -z "${TITLE_NUMBERS}" ];then
	TITLE_NUMBERS="${DEFAULT_TITLE_NUMBERS}"
fi
for TITLE_NUMBER in ${TITLE_NUMBERS};do
	if [ -n "${COMMA_SEPARATED_TITLE_NUMBERS}" ];then
		COMMA_SEPARATED_TITLE_NUMBERS="${COMMA_SEPARATED_TITLE_NUMBERS},${TITLE_NUMBER}"
	else
		COMMA_SEPARATED_TITLE_NUMBERS="${TITLE_NUMBER}"
	fi
done
echo ""

echo -n "Place the matching episode numbers for the above titles (space separated)
	make sure to prefix 1 eg with 01 etc: "
read -r EPISODE_NUMBERS
for EPISODE_NUMBER in ${EPISODE_NUMBERS};do
	if [ -n "${COMMA_SEPARATED_EPISODE_NUMBERS}" ];then
		COMMA_SEPARATED_EPISODE_NUMBERS="${COMMA_SEPARATED_EPISODE_NUMBERS},${EPISODE_NUMBER}"
	else
		COMMA_SEPARATED_EPISODE_NUMBERS="${EPISODE_NUMBER}"
	fi
done
echo ""

echo -n "Select a format (mp4/mkv default: ${DEFAULT_FORMAT}): "
read -r FORMAT
if [ -z "${FORMAT}" ];then
	FORMAT="${DEFAULT_FORMAT}"
fi
echo ""


echo -n "Select audio tracks (comma-separated): "
read -r AUDIO_TRACKS
echo ""

echo -n "Select audio encoders (faac/lame/vorbis/ac3/copy/copy:ac3/copy:dts)
	copy, copy:ac3 and copy:dts meaning passthrough.
	copy will passthrough either ac3 or dts.
	Separated by commas for more than one audio track.
	(default: faac for mp4, lame for mkv): "
read -r AUDIO_ENCODES
echo ""

echo -n "Select subtitle tracks (comma-separated): "
read -r SUBTITLE_TRACKS
echo ""

#echo -n "Select an encoder (ffmpeg,x264,theora): "
#read -r ENCODER
#echo ""

#ENCODER="x264"

#if [ "${ENCODER}" == "x264" ];then
#	echo -n "Enter x264 extra opts: "
#	read -r X264_OPTS
#	echo ""
#fi

#exit

echo -n "Enter a preset (default: ${DEFAULT_PRESET}): "
read -r PRESET
if [ -z "${PRESET}" ];then
	PRESET="${DEFAULT_PRESET}"
fi

ACCEPTED=false

echo_pound_line
echo "### SOURCE:               ${SOURCE}"
echo "### SHOW:                 ${SHOW_TITLE}"
echo "### SEASON:               ${SEASON}"
echo "### TITLES:               ${TITLE_NUMBERS}"
echo "### EPISODES:             ${EPISODE_NUMBERS}"
echo "### FORMAT:               ${FORMAT}"
echo "### PRESET:               ${PRESET}"
echo "### AUDIO TRACKS:         ${AUDIO_TRACKS}"
echo "### AUDIO ENCODES:        ${AUDIO_ENCODES}"
echo "### SUBTITLE TRACKS:      ${SUBTITLE_TRACKS}"
echo "### SAVE PATH:            ${SAVE_PATH}"
echo "### FILENAME PATTERN:     ${SHOW_TITLE}.S${SEASON}E{${COMMA_SEPARATED_EPISODE_NUMBERS}}.x264.${FORMAT}"
echo_pound_line

while [ ${ACCEPTED} == false ];do
	echo -n "Are you ready (y/n): "
	read -r READY
	if [ "${READY}" == "y" ];then
		ACCEPTED=true
	elif [ "${READY}" == "n" ];then
		echo "Goodbye!"
		exit 1
	fi
done

echo "Starting batch"

i=1
for TITLE in ${TITLE_NUMBERS};do
	echo_pound_line
	echo "### Start processing title ${TITLE}"
	echo_pound_line

	EPISODE=$(echo "${EPISODE_NUMBERS}" | cut -d " " -f "${i}")
	if [ -z "${EPISODE}" ];then
		EPISODE="__${i}__"
	fi
	FILE_NAME="${SHOW_TITLE}.S${SEASON}E${EPISODE}.x264.${FORMAT}"
	"${HANDBRAKE_BINARY}" -i "${SOURCE}" --preset="${PRESET}" --title "${TITLE}" -a "${AUDIO_TRACKS}" -E "${AUDIO_ENCODES}" --subtitle "${SUBTITLE_TRACKS}" -o "${FILE_NAME}" || die "Failed encode"
	
	echo_pound_line
	echo "### Done processing title ${TITLE}"
	echo_pound_line

	i=$(($i+1))
done

echo "Ending batch"
exit
