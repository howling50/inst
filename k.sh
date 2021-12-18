#!/usr/bin/env bash
sudo pacman -S powerline --noconfirm --needed
sudo rm -rf /root/.zshrc
sudo rm -rf /root/.bashrc
sudo cp ~/Downloads/inst/.zshrc /root/.zshrc
sudo cp ~/Downloads/inst/.bashrc /root/.bashrc
sudo rm -rf ~/.zshrc
sudo rm -rf ~/.bashrc
sudo cp ~/Downloads/inst/.zshrc ~/.zshrc
sudo cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo pacman -S yay --noconfirm --needed
sudo systemctl stop cups
sudo systemctl disable cups.service cups.socket cups.path
balooctl disable
sudo rm -rf ~/./local/share/baloo
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -R elisa --noconfirm
sudo pacman -R thunderbird --noconfirm
sudo pacman -S binutils --noconfirm --needed
sudo pacman -S hiredis --noconfirm --needed
sudo pacman -S ccache --noconfirm --needed
sudo pacman -S nmap --noconfirm --needed
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
sudo pacman -S vim --noconfirm --needed
sudo pacman -S pkgconf --noconfirm --needed
sudo pacman -S kitty --noconfirm --needed
sudo pacman -S gamemode --noconfirm --needed
sudo pacman -S hardinfo --noconfirm --needed
sudo pacman -S audacious --noconfirm --needed
sudo pacman -S leafpad --noconfirm --needed
sudo pacman -S lutris --noconfirm --needed
sudo pacman -S neofetch --noconfirm --needed
sudo pacman -S net-tools --noconfirm --needed
sudo pacman -S zip --noconfirm --needed
sudo pacman -S unzip --noconfirm --needed
sudo pacman -S unrar --noconfirm --needed
sudo pacman -S rkhunter --noconfirm --needed
sudo pacman -S unrar --noconfirm --needed
sudo pacman -S gparted --noconfirm --needed
sudo pacman -S gimp --noconfirm --needed
sudo pacman -S celluloid --noconfirm --needed
sudo pacman -S conky --noconfirm --needed
sudo pacman -S burpsuite --noconfirm --needed
sudo pacman -S brave-browser --noconfirm --needed
yay --sudoloop --save
yay -S --noconfirm stacer
yay -S --noconfirm dxvk-bin
yay -S --noconfirm key-mapper
yay -S --noconfirm sejda-desktop
yay -S --noconfirm ttf-meslo
yay -S --noconfirm spotify
yay -S --noconfirm ttf-ms-fonts
yay -S --noconfirm konsave
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
sudo bash -c 'echo -e "SCRIPTWHITELIST=/usr/bin/egrep\nSCRIPTWHITELIST=/usr/bin/fgrep\nSCRIPTWHITELIST=/usr/bin/ldd\nSCRIPTWHITELIST=/usr/bin/vendor_perl/GET" >> /etc/rkhunter.conf'
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq'
sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
cd ~/Downloads/
wget https://mirror.pseudoform.org/community/os/x86_64/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst
sudo pacman -U ~/Downloads/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst --noconfirm --needed
sudo ufw allow 80/tcp
sudo ufw limit 1716/tcp
sudo ufw allow 23232/tcp
sudo ufw default deny incoming  
sudo ufw default allow outgoing
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
cd ~/Downloads/inst
chmod +x install.sh
sudo ./install.sh
cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop
cp ~/Downloads/inst/.conkyrc ~/.conkyrc
cp -r ~/Downloads/inst/files/* ~/.config/
konsave -i ~/Downloads/inst/kde.knsv
sleep 1
konsave -a kde
conky -c ~/.conkyrc
