#!/usr/bin/env bash
##################### git clone in ~/Downloads, then chmod +x s.sh and then ./s.sh ####################################################
#https://github.com/howling50/Top-5-Bootloader-Themes
SECONDS=0
sudo zypper update
sudo zypper install -y -n git
#----Swap-------
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 8G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#------------
sudo mkdir -p /etc/cron.minutely && sudo cp ~/Downloads/inst/mycronjobs /etc/cron.d/ && chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/1 /usr/bin/ && sudo cp ~/Downloads/inst/scripts/2 /usr/bin/ && sudo cp ~/Downloads/inst/scripts/timer /usr/bin/ && sudo cp ~/Downloads/inst/scripts/saferm /usr/bin/ && sudo cp ~/Downloads/inst/scripts/mp4decrypt /usr/bin/ && sudo cp ~/Downloads/inst/scripts/checkerror /usr/bin/
#-------
sudo btrfs subvol create ~/Media && sudo chown $(whoami):$(whoami) ~/Media && sudo chmod 755 ~/Media && sudo btrfs subvol create ~/.wine && sudo chown $(whoami):$(whoami) ~/.wine && sudo chmod 755 ~/.wine
#--------
sudo zypper install -y -n powerline-fonts
sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc &&sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path && mkdir -p ~/.config/neofetch/ && sudo mkdir -p /root/.config/neofetch/
#-----------------------------------------------------
sudo zypper remove -y kwalletmanager kmail
sudo zypper install -y -n neofetch binutils hiredis ccache nmap make autoconf flex gcc patch automake bison fakeroot bind yast2-theme-oxygen
sudo zypper install -y -n wine-gecko catfish notepadqq wine-mono winetricks steam proxychains-ng tor neovim kitty gamemode audacious lutris zip unrar
sudo zypper install -y -n ffmpeg-7
sudo zypper install -y -n mkvtoolnix-tools mkvtoolnix-gui gparted
sudo zypper install -y -n gimp celluloid mediainfo flac filezilla aegisub virtualbox qbittorrent putty calibre kdialog shotcut aria2 google-roboto-fonts fuseiso android-tools yakuake osc
#-----------------------------------------------------------------
#handbrake,protonup-qt,protontricks,brave-bin,ventoy-bin virtualbox-ext-oracle hardinfo2 dxvk-bin input-remapper-git ttf-meslo bdinfo-git ttf-ms-fonts konsave
sudo flatpak install --noninteractive flathub org.kde.peruse
sudo flatpak install --noninteractive flathub com.usebottles.bottles
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep linux_amd64.rpm | cut -d\" -f4)
sudo zypper install -y ~/Downloads/inst/autobrr*.rpm
mkdir -p ~/.othercrap
wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage
chmod +x Stacer-1.1.0-x64.AppImage
cp Stacer-1.1.0-x64.AppImage ~/.othercrap/
mkdir -p ~/.local/share/applications/
echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop
chmod +x ~/.local/share/applications/stacer.desktop
mkdir -p ~/.local/share/kservices5/ServiceMenus/
cp ~/Downloads/inst/scripts/mediainfo.sh ~/.othercrap/
cp ~/Downloads/inst/scripts/mediainfo.desktop ~/.local/share/kservices5/ServiceMenus/
#------------------------------------------------------------------
neofetch >/dev/null
sleep 1
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf' && echo 'export VISUAL="nvim"' | sudo tee -a /root/.bash_profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.bash_profile  >/dev/null
sed -i 's/^image_size="auto"/image_size="none"/' ~/.config/neofetch/config.conf
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo zypper addlock qbittorrent
sudo touch /etc/cron.weekly/balance
sudo bash -c 'echo -e "#!/usr/bin/env bash\nbtrfs scrub start / >> /home/howling/scrub.txt" >> /etc/cron.weekly/balance'
#-----------------
sudo chmod +x /etc/cron.weekly/balance
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/
mkdir -p ~/.config/nvim/
cp ~/Downloads/inst/init.vim ~/.config/nvim/
curl -O https://i.imgur.com/N51R4iT.jpg
cp  ~/Downloads/inst/N51R4iT.jpg ~/.config/neofetch/
sudo mkdir -p /root/.config/nvim/
sudo cp ~/Downloads/inst/init.vim /root/.config/nvim/
cd ~/Downloads/inst/
wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
mv yt-dlp_linux yt-dlp
chmod +x yt-dlp
sudo cp ~/Downloads/inst/yt-dlp /usr/bin/
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip
cp -r ~/Downloads/inst/files/* ~/.config/
cd ~/Downloads/inst/
git clone https://github.com/yeyushengfan258/Win11OS-kde 
sudo bash ~/Downloads/inst/Win11OS-kde/install.sh
sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
# --------- Snapshots ------------------------
sudo systemctl enable grub-btrfsd.service
sudo systemctl start grub-btrfsd.service
# ----------------------------------------------
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
sudo chattr -R +C ~/Media
sudo chattr -R +C ~/.wine
cd ~/Downloads/inst/
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo sed -i '/^#$/,/^### BEGIN \/etc\/grub.d\/00_header ###$/s/^#$/set superusers="mastros"\npassword_pbkdf2 mastros grub.pbkdf2.sha512.10000.77DA16D22A3A8D15AA247F40FA13D6248A92B70D588CFBA14D0C61B15CB7BA37D7895693F643A4C84E5F0891AFB73CD83724D5B6B636A9722B94F726D4F5AAFA.B27F2FE6F14E583AFECAD4E5775498C1144639FB415F228F877EFACF8A1A3DA2BD5781238BD47BA00C4444C51A7F9D232E96F8C0A193E6FD8B64F2BC4E857A10\n#/' /boot/grub2/grub.cfg
mpg123 ~/.othercrap/1.mp3 > /dev/null 2>&1
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