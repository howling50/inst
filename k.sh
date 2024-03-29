#!/usr/bin/env bash
##################### git clone in ~/Downloads ####################################################
SECONDS=0
#sudo pacman -R timeshift-autosnap-manjaro --noconfirm
sudo pacman -S caffeine-ng --noconfirm --needed
caffeine & 2>/dev/null
#git clone https://github.com/howling50/Top-5-Bootloader-Themes
sudo mkdir -p /etc/crontab
sudo mkdir -p /etc/cron.minutely
sudo cp ~/Downloads/inst/mycronjobs /etc/cron.d/
chmod +x ~/Downloads/inst/scripts/*
sudo cp ~/Downloads/inst/scripts/timer /usr/bin/
sudo cp ~/Downloads/inst/scripts/saferm /usr/bin/
sudo cp ~/Downloads/inst/scripts/checkerror /usr/bin/
caffeine &
#-------
#btrfs subvol create ~/.local/share/Steam
#btrfs subvol create ~/.wine
#sudo mv ~/Downloads ~/Downloads.old
#btrfs subvol create ~/Downloads
#sudo mv ~/Downloads.old/* ~/Downloads/
#sudo rmdir ~/Downloads.old
#--------
cd
cd ~/Downloads/inst/
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
sudo pacman-mirrors --fasttrack 15 && sudo pacman -Syyu --noconfirm --needed
sudo pacman -S powerline-fonts --noconfirm --needed
sudo rm -rf /root/.zshrc
sudo rm -rf /root/.bashrc
sudo cp ~/Downloads/inst/.zshrc /root/.zshrc
sudo cp ~/Downloads/inst/.bashrc /root/.bashrc
sudo rm -rf ~/.zshrc
sudo rm -rf ~/.bashrc
cp ~/Downloads/inst/.zshrc ~/.zshrc
cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo pacman -S yay --noconfirm --needed
sudo systemctl stop cups
sudo systemctl disable cups.service cups.socket cups.path
balooctl disable
sudo rm -rf ~/./local/share/baloo
mkdir -p ~/.config/neofetch/
sudo mkdir -p /root/.config/neofetch/
#-----------------------------------------------------
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
sudo pacman -S neovim --noconfirm --needed
sudo pacman -S pkgconf --noconfirm --needed
sudo pacman -S kitty --noconfirm --needed
sudo pacman -S gamemode --noconfirm --needed
sudo pacman -S hardinfo --noconfirm --needed
sudo pacman -S audacious --noconfirm --needed
sudo pacman -S mousepad --noconfirm --needed
sudo pacman -S lutris --noconfirm --needed
sudo pacman -S neofetch --noconfirm --needed
sudo pacman -S masscan --noconfirm --needed
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
sudo pacman -S ventoy --noconfirm --needed
sudo pacman -S downgrade --noconfirm --needed
#-----------------------------------------------------------------
yay --sudoloop --save
yay -S --noconfirm stacer-bin
yay -S --noconfirm dxvk-bin
yay -S --noconfirm input-remapper-git
yay -S --noconfirm sejda-desktop
yay -S --noconfirm nerd-fonts-fira-code
yay -S --noconfirm ttf-meslo
yay -S --noconfirm protonup-qt
yay -S --noconfirm ttf-ms-fonts
yay -S --noconfirm konsave
#------------Remote -----------------------------------
sudo pacman -S remmina --noconfirm --needed
yay -S --noconfirm remmina-plugin-teamviewer
yay -S --noconfirm remmina-plugin-ultravnc
yay -S --noconfirm remmina-plugin-rdesktop
yay -S --noconfirm remmina-plugin-url
yay -S --noconfirm remmina-plugin-open
yay -S --noconfirm remmina-plugin-folder
#------------------------------------------------------------------
neofetch >/dev/null
sleep 1
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo cp ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local 
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq'
sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
echo 'export VISUAL="nvim"' | sudo tee -a /root/.bash_profile  >/dev/null
echo 'export VISUAL="nvim"' | tee -a ~/.bash_profile  >/dev/null
sed -i 's/^image_size="auto"/image_size="none"/' ~/.config/neofetch/config.conf
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo sed -i 's/^#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent/' /etc/pacman.conf
sudo touch /etc/cron.weekly/balance
#sudo bash -c 'echo -e "#!/usr/bin/env bash\nbtrfs scrub start / >> /home/howling/scrub.txt" >> /etc/cron.weekly/balance'
#-----------------
echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile
echo '    source ~/.bashrc' >> ~/.bash_profile
echo 'fi' >> ~/.bash_profile
echo 'if [ -f /root/.bashrc ]; then' | sudo tee -a /root/.bash_profile
echo '    source /root/.bashrc' | sudo tee -a /root/.bash_profile
echo 'fi' | sudo tee -a /root/.bash_profile
#-----------------
sudo chmod +x /etc/cron.weekly/balance
echo vm.swappiness=10 | sudo tee -a /etc/sysctl.d/100-manjaro.conf  >/dev/null
#sudo systemctl enable fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/
mkdir -p ~/.config/nvim/
cp ~/Downloads/inst/init.vim ~/.config/nvim/
wget https://i.imgur.com/N51R4iT.jpg
cp  ~/Downloads/inst/N51R4iT.jpg ~/.config/neofetch/
sudo mkdir -p /root/.config/nvim/
sudo cp ~/Downloads/inst/init.vim /root/.config/nvim/
cd ~/Downloads/inst/
wget https://mirror.pseudoform.org/community/os/x86_64/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst
sudo pacman -U ~/Downloads/inst/grub-customizer-5.1.0-3-x86_64.pkg.tar.zst --noconfirm --needed
#---------------Firewall--------------
#sudo ufw enable
#sudo ufw allow 80/tcp
#sudo ufw allow 443/tcp
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1714:1764
sudo ufw allow proto udp from 192.168.0.0/24 to any port 1714:1764
sudo ufw allow 23232/tcp
sudo ufw allow 23232/udp
sudo ufw default deny incoming 
sleep 1
sudo ufw default allow outgoing
sleep 1
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
#------------------------------------
cp -r ~/Downloads/inst/files/* ~/.config/
cd ~/Downloads/inst/
git clone https://github.com/yeyushengfan258/Win11OS-kde 
sudo bash ~/Downloads/inst/Win11OS-kde/install.sh
lookandfeeltool -a com.github.yeyushengfan258.Win11OS-dark 2>/dev/null
sleep 2
# --------- Snapshots ------------------------
#sudo systemctl enable grub-btrfs.path
#sudo systemctl start grub-btrfs.path
#sudo bash ~/Downloads/inst/scripts/1
# ----------------------------------------------
konsave -i ~/Downloads/inst/kde2.knsv
sleep 1
konsave -a kde2
#cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop
#cp ~/Downloads/inst/.conkyrc ~/.conkyrc
cp ~/Downloads/inst/1.mp3 ~/1.mp3
caffeine kill
sudo pacman -R caffeine-ng --noconfirm
#conky -c ~/.conkyrc &
sed -i 's/"sudoloop": true/"sudoloop": false/' ~/.config/yay/config.json
cd
#sudo chattr -R +C ~/Downloads
#sudo chattr -R +C ~/.local/share/Steam
#sudo chattr -R +C ~/.wine
mpg123 ~/1.mp3 > /dev/null 2>&1
if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
else
    echo "Completed in $SECONDS seconds"
fi
