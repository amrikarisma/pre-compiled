#!/bin/sh
printf '\nStart Installing ccminer precompiled....\n'

yes | pkg update && pkg upgrade
yes | pkg install libjansson wget nano screen

mkdir ccminer && cd ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/config.json
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/start.sh
chmod +x ccminer start.sh

nano config.json
~/ccminer/start.sh
