#!/usr/bin/env bash
sudo pacman -S yay --noconfirm --needed
sudo systemctl stop cups
sudo systemctl disable cups.service cups.socket cups.path
sudo balooctl disable
sudo rm -rf ~/./local/share/baloo
sudo pacman -R yakuake --noconfirm --needed
sudo pacman -R elisa --noconfirm --needed
sudo pacman -S jdk-openjdk --noconfirm --needed
sudo pacman -S wine-gecko --noconfirm --needed
sudo pacman -S vim --noconfirm --needed
sudo pacman -S wine-mono --noconfirm --needed
sudo pacman -S winetricks --noconfirm --needed
sudo pacman -S gufw --noconfirm --needed
sudo pacman -S proxychains --noconfirm --needed
sudo pacman -S tor --noconfirm --needed
sudo pacman -S pkgconf --noconfirm --needed
sudo pacman -S terminator --noconfirm --needed
sudo pacman -S gamemode --noconfirm --needed
sudo pacman -S hardinfo --noconfirm --needed
sudo pacman -S audacious --noconfirm --needed
sudo pacman -S leafpad --noconfirm --needed
sudo pacman -S lutris --noconfirm --needed
sudo pacman -S neofetch --noconfirm --needed
sudo pacman -S net-tools --noconfirm --needed
sudo pacman -S rkhunter --noconfirm --needed
sudo pacman -S unrar --noconfirm --needed
sudo pacman -S gimp --noconfirm --needed
sudo pacman -S vlc --noconfirm --needed
sudo pacman -R onlyoffice-desktopeditors --noconfirm --needed
sudo pacman -S libreoffice-fresh --noconfirm --needed
sudo pacman -S celluloid --noconfirm --needed
yay -S --noconfirm stacer
yay -S --noconfirm brave-bin
yay -S --noconfirm mangohud
yay -S --noconfirm mangohud-common
yay -S --noconfirm ttf-msfonts
yay -S --noconfirm eiskaltdcpp-qt
yay -S --noconfirm zenmap
yay -S --noconfirm konsave    
cd ~/Downloads/
wget https://mirror.pseudoform.org/community/os/x86_64/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst
sudo pacman -U ~/Downloads/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst --noconfirm --needed
sudo systemctl enable tor.service
sudo systemctl start tor.service
sudo systemctl start ufw
sudo ufw enable
konsave -i ~/Downloads/inst/kde.knsv
sleep 1
konsave -a kde
