#!/bin/sh
printf '\nStart Installing ccminer precompiled....\n'

# Cek apakah parameter 'user' dan 'threads' disediakan
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <user_value> <threads>"
    echo "Example: $0 RYKyE46iY7hrzJyC3d8ksKVxEg1tdUfpf6.Kentos 8"
    exit 1
fi

# Simpan parameter ke dalam variable
user_value=$1
threads_value=$2

# Lanjutkan instalasi paket dan setup
pkg update && pkg upgrade -y
pkg install libjansson wget nano screen openssh -y

mkdir ccminer && cd ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/ccminer
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/config.json
wget https://raw.githubusercontent.com/amrikarisma/pre-compiled/generic/start.sh
chmod +x ccminer start.sh

# Update config.json dengan nilai user_value dan threads_value dari parameter
sed -i "s/\"user\": \".*\"/\"user\": \"$user_value\"/" config.json
sed -i "s/\"threads\": [0-9]*/\"threads\": $threads_value/" config.json

# Setup Termux boot scripts untuk SSH dan miner
mkdir -p ~/.termux/boot/

cat << EOF > ~/.termux/boot/start-sshd
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
EOF

cat << EOF > ~/.termux/boot/start-miner
#!/data/data/com.termux/files/usr/bin/sh
# Exit any existing CCminer screens
screen -S CCminer -X quit 1>/dev/null 2>&1
# Wipe dead screens
screen -wipe 1>/dev/null 2>&1
# Create a new detached screen session for CCminer
screen -dmS CCminer 1>/dev/null 2>&1
# Run the miner
screen -S CCminer -X stuff "~/ccminer/ccminer -c ~/ccminer/config.json\n" 1>/dev/null 2>&1
printf '\nMining started.\n'
printf '===============\n'
printf '\nManual:\n'
printf 'start: ~/.ccminer/start.sh\n'
printf 'stop: screen -X -S CCminer quit\n'
printf '\nMonitor mining: screen -x CCminer\n'
printf "Exit monitor: 'CTRL-a' followed by 'd'\n\n"
EOF

chmod +x ~/.termux/boot/start-*

# Run the miner startup script
~/ccminer/start.sh

# Clean up install script
rm -rf ~/install.sh
