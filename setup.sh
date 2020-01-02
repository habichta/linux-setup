#!/bin/sh
set -e

# Update & Upgrade
sudo apt update
sudo apt upgrade -y
# Add PPA Repositories
# VS Code
echo "****************************************"
echo "Adding Code"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
# Spotify
echo "****************************************"
echo "Adding Spotify"
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
# Brave Browser
echo "****************************************"
echo "Adding Brave"
sudo apt install -y apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
# Polybar
echo "****************************************"
echo "Adding Polybad"
sudo add-apt-repository -y ppa:kgilmer/speed-ricer
sudo apt update
# NextCloud
echo "****************************************"
echo "Adding NextCloud"
sudo add-apt-repository -y ppa:nextcloud-devs/client
sudo apt update

# Do all work in the tmp directory
mkdir ~/temporary-linux-setup
cd ~/temporary-linux-setup

# Clone this repository
git clone https://github.com/polaroidkidd/linux-setup.git
# update permissions
sudo chmod -R a+rw linux-setup

# Init Submodules
cd linux-setup
git checkout feature/additional-tools
git submodule update --init --recursive


# get the path to this script
WORK_PATH=`dirname "$0"`
WORK_PATH=`( cd "$WORK_PATH" && pwd )`


# i3 & i3-gaps
sudo apt install -y xorg i3 i3lock-fancy xserver-xorg xutils-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake 

cd $WORK_PATH/xcb-util-xrm
git submodule update --init --recursive 
./autogen.sh --prefix=/usr
sudo make install

# i3
sudo apt install -y libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev

cd $WORK_PATH/i3
autoreconf --force --install
rm -rf build
mkdir build
cd build
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

# Compton
sudo apt install -y asciidoc pkg-config make gcc libev-libevent-dev libdbus-1-dev libgl1-mesa-dev libgles2-mesa-dev libxcb-present-dev libxcb-sync-dev libxcb-damage0-dev libx11-xcb-dev libev4 libev-dev uthash-dev libxdg-basedir-dev libconfig-dev meson libx11-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-shape0-dev libxcb-xkb-dev pkg-config xcb-proto libxcb-xrm-dev libxcb-composite0-dev xcb libxcb-ewmh2 libxcb1-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcomposite-dev libxrandr-dev libxinerama-dev make cmake automake autoconf xdotool
cd $WORK_PATH/compton
make
make docs
sudo make install

# Light
mkdir -p $WORK_PATH/light
cd $WORK_PATH/light
wget https://github.com/haikarainen/light/releases/download/v1.2/light-1.2.tar.gz
tar xf light-1.2.tar.gz 
cd light-1.2 
./configure 
make
sudo make install


# Fusuma
sudo gpasswd -a $USER input
sudo apt install -y libinput-tools ruby
sudo gem install fusuma

# Etra Tools
sudo apt install -y rofi ranger terminator

# Copy dot-files
mkdir -p ~/.config/
cp -r $WORK_PATH/dot-files/* ~/.config/
mkdir -p ~/.local/share/applications/
cp -r $WORK_PATH/desktop-entries/* ~/.local/share/applications/

# Copy Intel Driver
sudo mkdir -p /usr/share/X11/xorg.conf.d/
sudo cp $WORK_PATH/dot-files/intel/20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf


cp $WORK_PATH/dot-files/oh-my-zsh/.zshrc ~/.zshrc

# polybar
sudo apt install -y polybar

# wallpaper
sudo apt install -y feh
cp $WORK_PATH/assets/mountains.jpg ~/.config/i3/

# VS Code
sudo apt install apt-transport-https code

# pulse audio
sudo apt install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils

# bluetooth
sudo apt install -y blueman bluez bluez-obexd bluez-tools libbluetooth3

# Brave Browser
sudo apt install -y apt-transport-https curl brave-browser brave-keyring

# FireFox
sudo apt install -y firefox

# Intellij
mkdir -p ~/DevTools/IntelliJ
wget https://download.jetbrains.com/idea/ideaIU-2019.3.1.tar.gz
tar xzvf ideaIU-2019.3.1.tar.gz -C ~/DevTools/IntelliJ

# nextcloud
sudo apt install nextcloud-client


# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash


# MiniCOnda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $WORK_PATH/miniconda.sh
bash $WORK_PATH/miniconda.sh -b -p $HOME/miniconda

# Spotify
sudo apt -y install spotify-client

# github cli
sudo snap install hub --classic


# google chrome
cd $WORK_PATH
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# CopyQ
sudo apt install -y copyq

# keepassX
sudo apt install -y keepassx

# Install Roboto Mono
unzip  $WORK_PATH/Roboto_Mono.zip -d ${HOME}/.fonts  
sudo fc-cache -f -v


# Network-Manager
cd $WORK_PATH
sudo apt install -y network-manager network-manager-config-connectivity-ubuntu network-manager-gnome
sudo cp $WORK_PATH/network-manager/globally-managed-devices.conf /usr/lib/NetworkManager/conf.d/globally-managed-devices.conf

# zsh
sudo apt install -y zsh
echo "y" | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo chsh -s /usr/bin/zsh root
sudo chsh -s /usr/bin/zsh $USER

# CleanUp
cd ~/
sudo rm -rf ~/temporary-linux-setupsudo 

# Complete
echo "Installation Completed! Rebooting in 10"
sleep 10
sudo reboot