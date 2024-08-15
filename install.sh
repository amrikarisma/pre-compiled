#!/bin/sh
printf '\nStart Installing ccminer precompiled....\n'

pkg update && pkg upgrade -y
pkg install libjansson wget nano screen openssh -y

mkdir ccminer && cd ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/config.json
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/start.sh
chmod +x ccminer start.sh

nano config.json

mkdir ~/.termux/boot/

cat << EOF > ~/.termux/boot/start-sshd
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
EOF

cat << EOF > ~/.termux/boot/start-miner
#!/data/data/com.termux/files/usr/bin/sh
#exit existing screens with the name CCminer
screen -S CCminer -X quit 1>/dev/null 2>&1
#wipe any existing (dead) screens)
screen -wipe 1>/dev/null 2>&1
#create new disconnected session CCminer
screen -dmS CCminer 1>/dev/null 2>&1
#run the miner
screen -S CCminer -X stuff "~/ccminer/ccminer -c ~/ccminer/config.json\n" 1>/dev/null 2>&1
printf '\nMining started.\n'
printf '===============\n'
printf '\nManual:\n'
printf 'start: ~/.ccminer/start.sh\n'
printf 'stop: screen -X -S CCminer quit\n'
printf '\nmonitor mining: screen -x CCminer\n'
printf "exit monitor: 'CTRL-a' followed by 'd'\n\n"
EOF

chmod +x ~/.termux/boot/start-*

~/ccminer/start.sh

rm -rf ~/install.sh
