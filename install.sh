#!/bin/bash

echo "Installer started!"
echo "Creating xrandr config"
echo "Is this the laptop? [y/n]"
read isLaptop

cd .screenlayout || mkdir .screenlayout && cd .screenlayout
[[ $isLaptop == "y" ]] && echo "#!/bin/sh\n xrandr -s 1920x1080 --primary" >> layout.sh || echo "#!/bin/sh\n xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate right --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-4 --off --output DP-5 --off" >> layout.sh

sudo chmod +x layout.sh



