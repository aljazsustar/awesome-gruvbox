#!/bin/bash

echo "Installer started!"

echo "Updating"

sudo pacman -Su && yay -Su && echo "Update finished, reboot recommended" || "Failed to update"
echo "Reboot now? [y/n]"
read reboot

if [[ -z $reboot ]] || [[ $reboot == "y" ]]; then
    reboot
fi


echo "Creating xrandr config"
echo "Is this the laptop? [y/N]"
read isLaptop

cd ~
#cd .screenlayout || mkdir .screenlayout && cd .screenlayout
#if [[ $isLaptop == "y" ]]
#then
#    printf "#!/bin/sh\n xrandr -s 1920x1080" >> layout1.sh
#else
#    printf "#!/bin/sh\n xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate right --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-4 --off --output DP-5 --off" >> layout1.sh
#fi

#sudo chmod +x layout1.sh
#./layout1.sh
cd || exit 1

echo "Installing extra software"

yay -S intellij-idea-ultimate-edition pycharm-professional clion webstorm oh-my-zsh-git 
sudo pacman -S jdk-openjdk python-pip spotify alacritty nitrogen feh picom visual-studio-code-bin zsh brave-bin rofi lightdm lightdm-webkit2-greeter luarocks emacs fd ripgrep

sudo systemctl enable lightdm

echo "Installing awestore"
sudo luarocks --lua-version 5.3 install awestore

cd awesome-gruvbox || exit 1

#add awesome-wm-widgets, spicetify-cli, spicetify-themes, rofi-themes, 
echo "Copying config files"
cp -r alacritty ~/.config/. && cp -r awesome ~/.config/. && cp .Xresources ../. && cp .zshrc ../. || echo "Failed to copy config files"
cd || exit 1
echo "Installing awesome-wm widgets"
cd ~/.config/awesome && git clone https://github.com/streetturtle/awesome-wm-widgets.git || echo "Failed to install awesome-wm-widgtes" 
cd ~

echo "Installing Doom Emacs"
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

cp awesome-gruvbox/init.el .doom.d/ && cp awesome-gruvbox/config.el .doom.d/
~/.emacs.d/bin/doom sync

echo "Do you want to install spicetify? [y/N]"
read installSpicetify

if [[ $installSpicetify == "y" ]]
then
    #spotify must be ran for spicetify to work
    spotify &

    echo "Installing spicetify-cli"
    yay -S spicetify-cli
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    spicetify && spicetify backup apply enable-devtool

    echo "Installing spicetify-themes"
    cd ~/.config || exit 1
    git clone https://github.com/morpheusthewhite/spicetify-themes.git
    cd spicetify-themes || exit 1
    cp -r * ~/.config/spicetify/Themes
    cd || exit 1

    echo "Applying Gruvbox theme to Spotify"
    cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish" || exit 1
    mkdir -p ../../Extensions
    cp dribbblish.js ../../Extensions/.
    spicetify config extensions dribbblish.js
    spicetify config current_theme Dribbblish color_scheme gruvbox
    spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
    spicetify apply
    cd || exit 1
fi

echo "Installing lightdm theme"

cd .config
git clone https://github.com/lveteau/lightdm-webkit-modern-arch-theme.git
sudo cp lightdm.conf /etc/lightdm/lightdm.conf
sudo cp lightdm-webkit2-greeter.conf /etc/lightdm/lightdm-webkit2-greeter.conf
cd

echo "Changes will take effect after reboot"


echo "Installing rofi themes"
git clone --depth=1 https://github.com/adi1090x/rofi.git || echo "Failed to clone the repo"
cd rofi || exit 1
sudo chmod +x setup .sh
./setup.sh
cd ~/awesome-gruvbox
cp launcher.sh /home/aljaz/.config/rofi/launchers/misc/
cp powermenu.sh home/aljaz/.config/rofi/applets/android/
cp colors.rasi /home/aljaz/rofi/applets/android
cd || exit 1

echo "Downloading wallpapers"
cd Pictures || mkdir Pictures && cd Pictures
git clone "https://gitlab.com/dwt1/wallpapers.git"

echo "Changing default shell to zsh"
chsh -s /bin/zsh

echo "Copying zsh theme"
sudo cp macos.zsh-theme /usr/share/oh-my-zsh/themes

echo "Logout for changes to take effect"
