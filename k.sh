#!/usr/bin/env bash
rm -rf ~/.zshrc
cp ~/Downloads/inst/.zshrc ~/.zshrc
sudo pacman -S yay --noconfirm --needed
sudo systemctl stop cups
sudo systemctl disable cups.service cups.socket cups.path
sudo balooctl disable
sudo rm -rf ~/./local/share/baloo
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -R yakuake --noconfirm
sudo pacman -R elisa --noconfirm
sudo pacman -R thunderbird --noconfirm
sudo pacman -S binutils --noconfirm --needed
sudo pacman -S hiredis --noconfirm --needed
sudo pacman -S ccache --noconfirm --needed
sudo pacman -S make --noconfirm --needed
sudo pacman -S autoconf --noconfirm --needed
sudo pacman -S flex --noconfirm --needed
sudo pacman -S gcc --noconfirm --needed
sudo pacman -S patch --noconfirm --needed
sudo pacman -S automake --noconfirm --needed
sudo pacman -S bison --noconfirm --needed
sudo pacman -S fakeroot --noconfirm --needed
sudo pacman -S bind --noconfirm --needed
sudo pacman -S jdk-openjdk --noconfirm --needed
sudo pacman -S wine-gecko --noconfirm --needed
sudo pacman -S catfish --noconfirm --needed
sudo pacman -S notepadqq --noconfirm --needed
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
sudo pacman -S gparted --noconfirm --needed
sudo pacman -S gimp --noconfirm --needed
sudo pacman -S vlc --noconfirm --needed
sudo pacman -S celluloid --noconfirm --needed
sudo pacman -S conky --noconfirm --needed
sudo pacman -S burpsuite --noconfirm --needed
yay --sudoloop --save
yay -S --noconfirm stacer
yay -S --noconfirm dxvk-bin
yay -S --noconfirm key-mapper
yay -S --noconfirm spotify
yay -S --noconfirm brave-bin
yay -S --noconfirm ttf-ms-fonts
yay -S --noconfirm konsave
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
sudo bash -c 'echo -e "SCRIPTWHITELIST=/usr/bin/egrep\nSCRIPTWHITELIST=/usr/bin/fgrep\nSCRIPTWHITELIST=/usr/bin/ldd\nSCRIPTWHITELIST=/usr/bin/vendor_perl/GET" >> /etc/rkhunter.conf'
cd ~/Downloads/
wget https://mirror.pseudoform.org/community/os/x86_64/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst
sudo pacman -U ~/Downloads/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst --noconfirm --needed
sudo systemctl enable tor.service
sudo systemctl start tor.service
sudo ufw allow 80/tcp
sudo ufw limit 1716/tcp
sudo ufw allow 23232/tcp
sudo ufw default deny incoming  
sudo ufw default allow outgoing
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop
cd ~/Downloads/inst
konsave -i ~/Downloads/inst/kde.knsv
sleep 1
konsave -a kde
