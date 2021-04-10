#!/bin/bash

echo "Installer started!"

echo "Updating"

sudo pacman -Su && yay -Su && echo "Update finished, reboot recommended" || "Failed to update"


echo "Creating xrandr config"
echo "Is this the laptop? [y/n]"
read isLaptop

cd .screenlayout || mkdir .screenlayout && cd .screenlayout
( [[ $isLaptop == "y" ]] || [[ -z $isLaptop ]] ) && echo "#!/bin/sh\n xrandr -s 1920x1080 --primary" >> layout.sh || echo "#!/bin/sh\n xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate right --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-4 --off --output DP-5 --off" >> layout.sh

sudo chmod +x layout.sh
cd

echo "Installing extra software"

yay -S intellij-idea-ultimate-edition pycharm-ultimate clion webstorm
sudo pacman -S jdk-openjdk python-pip spotify alacritty nitrogen

cd awesome-gruvbox

#add awesome-wm-widgets, spicetify-cli, spicetify-themes, rofi-themes, 
echo "Copying config files"
cp alacritty ~/.config/. && cp awesome ~/.config/. && copy .Xresources ../. && copy .zshrc ../. || echo "Failed to copy config files" && exit 1
cd
echo "Installing awesome-wm widgets"
cd ~/.config/awesome && git clone https://github.com/streetturtle/awesome-wm-widgets.git || echo "Failed to install awesome-wm-widgtes" && exit 1
cd 

echo "Installing spicetify-cli"
yay -S spicetify-cli 
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify && spicetify backup apply enable-devtool

echo "Installing spicetify-themes"
cd ~/.config
git clone https://github.com/morpheusthewhite/spicetify-themes.git
cd spicetify-themes
cp -r * ~/.config/spicetify/Themes
cd

echo "Applying Gruvbox theme to Spotify"
cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish"
mkdir -p ../../Extensions
cp dribbblish.js ../../Extensions/.
spicetify config extensions dribbblish.js
spicetify config current_theme Dribbblish color_scheme gruvbox
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify apply
cd

echo "Installing rofi themes"
git clone --depth=1 https://github.com/adi1090x/rofi.git || echo "Failed to clone the repo" && exit 1
cd rofi
sudo chmod +x setup .sh
./setup.sh
cd 

echo "Downloading wallpapers"
cd Pictures || mkdir Pictures && cd Pictures
git clone https://gitlab.com/dwt1/wallpapers.git