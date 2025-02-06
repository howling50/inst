#!/usr/bin/env bash
##################### sudo chattr -R +C ~/Downloads and git clone in ~/Downloads, then chmod +x s.sh and then ./s.sh ####################################################
#git clone https://github.com/yeyushengfan258/Win11OS-kde && sudo bash ~/Downloads/inst/Win11OS-kde/install.sh && sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
#sudo visudo (Defaults timestamp_timeout=60)  patterns-games-games patterns-kde-kde_pim xfce4-terminal --drop-down
#sudo zypper install -y -n conky && cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#zypper in mirrorsorcerer && systemctl enable --now mirrorsorcerer
#/etc/sysconfig/btrfsmaintenance
#mkdir -p ~/Media/container/arch && distrobox-create -n arch -i quay.io/toolbx/arch-toolbox --init --additional-packages "systemd git fzf eza starship zoxide neovim ytfzf cmatrix mpv yt-dlp" --home ~/Media/container/arch
#mkdir -p ~/.config/nvim && cp /home/howling/.bash* ~/ && cp /home/howling/.config/starship.toml ~/.config/ && cp /home/howling/.config/nvim/* ~/.config/nvim/ && [ -f ~/.bash_profile ] || echo -e "if [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi" > ~/.bash_profile
SECONDS=0
sudo zypper ref && sudo zypper up
sudo zypper install -y -n systemd-zram-service &&  sudo systemctl enable --now zramswap.service
sudo systemctl stop packagekit.service && sudo zypper remove -y PackageKit && sudo zypper addlock PackageKit
sudo zypper remove -y discover6 && sudo zypper addlock discover6
#sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman && sudo zypper dup --from packman --allow-vendor-change
#sudo zypper ar -f https://download.nvidia.com/opensuse/tumbleweed/ nvidia
sudo zypper install flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo zypper install -y -n powerline-fonts starship memtest86+ kitty
#----Swap-------
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 6G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#------------
sudo mkdir -p /etc/cron.minutely && sudo cp ~/Downloads/inst/mycronjobs /etc/cron.d/ && chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/1 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/2 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/timer /usr/local/bin && sudo cp ~/Downloads/inst/scripts/mp4decrypt /usr/local/bin && sudo cp ~/Downloads/inst/scripts/checkerror /usr/local/bin
sudo btrfs quota disable /
#-------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media
mkdir -p ~/.config/qBittorrent && mkdir -p ~/Media && mkdir -p ~/.wine && sudo mkdir -p /var/lib/flatpak && mkdir -p ~/.local/share/flatpak
sudo chattr -R +C ~/.config/qBittorrent && sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine && sudo chattr -R +C /var/lib/flatpak && sudo chattr -R +C ~/.local/share/flatpak
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config/ && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path
#-----------------------------------------------------
sudo zypper remove -y kwalletmanager && sudo zypper addlock kwalletmanager
akonadictl stop && systemctl --user disable akonadi && sudo zypper remove --clean-deps -y akonadi && sudo zypper addlock akonadi patterns-kde-kde_pim
#sudo zypper remove -y xscreensaver
#sudo zypper install -y -n xfce4-panel-profiles xfce4-whiskermenu-plugin xfce4-screenshooter xfce4-taskmanager adwaita-icon-theme dmz-icon-theme-cursors guake
sudo zypper install -y -n yakuake oxygen6-cursors yast2-theme-oxygen
sudo zypper install -y -n audacious yt-dlp cmus cmus-plugins-all mpv mpg123 mkvtoolnix-tools mkvtoolnix-gui steam lutris flac vlc
sudo zypper install -y -n gsmartcontrol w3m ddgr xkill firewall-config tealdeer bat zoxide fzf gdu eza ripgrep podman distrobox symbols-only-nerd-fonts fetchmsttfonts meslo-lg-fonts
sudo zypper install -y -n dxvk hardinfo opi feh fastfetch nmap fakeroot bind wine-gecko catfish wine-mono winetricks proxychains-ng tor neovim
sudo zypper install -y -n gamemode zip unrar gparted filezilla qbittorrent putty aria2 fuseiso android-tools q4wine flameshot
sudo opi -n codecs
#sudo opi -n input-remapper && sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
#-----------------------------------------------------------------
#bdinfo-git quickemu quickgui-bin
sudo flatpak install --noninteractive flathub net.mediaarea.MediaInfo && sudo flatpak install --noninteractive flathub com.github.tchx84.Flatseal
sudo flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && sudo flatpak install --noninteractive flathub com.usebottles.bottles && sudo flatpak install --noninteractive flathub fr.handbrake.ghb && sudo flatpak install --noninteractive flathub net.davidotek.pupgui2 && sudo flatpak install --noninteractive flathub com.brave.Browser
sudo flatpak install --noninteractive flathub com.calibre_ebook.calibre && sudo flatpak install --noninteractive flathub org.gimp.GIMP && sudo flatpak install --noninteractive flathub com.github.Matoking.protontricks && sudo flatpak install --noninteractive flathub io.gitlab.librewolf-community && sudo flatpak install --noninteractive flathub org.shotcut.Shotcut && sudo flatpak install --noninteractive flathub io.github.Hexchat
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep linux_amd64.rpm | cut -d\" -f4) && sudo zypper --no-gpg-checks install -y -n ~/Downloads/inst/autobrr*.rpm
mkdir -p ~/.othercrap
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) > /dev/null 2>&1
tar -xzf ~/Downloads/inst/ventoy*.tar.gz -C ~/.othercrap/
ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*"); mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/Ventoy.desktop
wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop
chmod +x ~/.local/share/applications/stacer.desktop
#---xfce--
#wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) -O ~/Downloads/ventoy.tar.gz && mkdir -p ~/.othercrap && tar -xzf ~/Downloads/ventoy.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*") && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/Ventoy.desktop && chmod +x ~/.local/share/applications/Ventoy.desktop
#wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
mkdir -p ~/.config/fastfetch && cp ~/Downloads/inst/config.jsonc ~/.config/fastfetch/ && sudo mkdir -p /root/.config/fastfetch && sudo cp ~/Downloads/inst/config.jsonc /root/.config/fastfetch/
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf' && echo 'export VISUAL="nvim"' | sudo tee -a /root/.profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo zypper addlock qbittorrent
sudo systemctl start cron
#sudo touch /etc/cron.monthly/balance
#sudo touch /etc/cron.monthly/btrfs_balance
#sudo bash -c 'echo -e "#!/usr/bin/env bash\n\n# Scrub root filesystem\nbtrfs scrub start / >> /home/howling/scrub.txt 2>&1\n\n# Scrub secondary drives\nbtrfs scrub start /home/howling/Media/D >> /home/howling/scrub.txt 2>&1\nbtrfs scrub start /home/howling/Media/E >> /home/howling/scrub.txt 2>&1" > /etc/cron.monthly/balance'
#sudo bash -c 'echo -e "#!/usr/bin/env bash\n\n# Balance secondary drives\n\ndate >> /home/howling/balance.txt\nbtrfs balance start /home/howling/Media/D >> /home/howling/balance.txt 2>&1\nbtrfs balance start /home/howling/Media/E >> /home/howling/balance.txt 2>&1" > /etc/cron.monthly/btrfs_balance'
#sudo chmod +x /etc/cron.weekly/balance
#sudo chmod +x /etc/cron.monthly/btrfs_balance
#-----------------
sudo firewall-cmd --permanent --new-zone=howling && sudo firewall-cmd --permanent --zone=howling --add-source=192.168.0.0/24 && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="tcp" accept' && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="udp" accept' && sudo firewall-cmd --permanent --zone=howling --add-port=23232/tcp && sudo firewall-cmd --permanent --zone=howling --add-port=23232/udp && sudo firewall-cmd --permanent --zone=howling --set-target=DROP && sudo firewall-cmd --reload && sudo firewall-cmd --set-default-zone=howling
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && mkdir -p ~/.config/nvim/ && cp ~/Downloads/inst/init.lua ~/.config/nvim/
curl -O https://i.imgur.com/N51R4iT.jpg
cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/
sudo mkdir -p /root/.config/nvim/
sudo cp ~/Downloads/inst/init.lua /root/.config/nvim/
cd ~/Downloads/inst/
#wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && mv yt-dlp_linux yt-dlp && chmod +x yt-dlp && sudo cp ~/Downloads/inst/yt-dlp /usr/local/bin
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip
cp -r ~/Downloads/inst/files/* ~/.config/
cd
cd ~/Downloads/inst/
wget https://github.com/sc0ty/subsync/releases/download/0.17/subsync-0.17.0-portable-amd64.exe
mv ~/Downloads/inst/subsync-0.17.0-portable-amd64.exe ~/.othercrap/
# ---------------------------------
magick ~/Downloads/inst/script/monkey.jpg ~/Downloads/inst/script/monkey.png
mv ~/Downloads/inst/script/monkey.png ~/.othercrap/monkey.png
mkdir -p ~/.othercrap/dedrm
unzip ~/Downloads/inst/DeDRM_tools_10.0.3.zip -d ~/.othercrap/dedrm > /dev/null
mkdir -p ~/.othercrap/eac3to
unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null
mv ~/Downloads/inst/script/tampermonkey-* ~/.othercrap/
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/script/'XMouseButtonControl 2.20.5 Portable.zip' ~/.othercrap/
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
cd ~/Downloads/inst/
sudo sed -i '$ a\set superusers="mastros"\npassword_pbkdf2 mastros grub.pbkdf2.sha512.10000.77DA16D22A3A8D15AA247F40FA13D6248A92B70D588CFBA14D0C61B15CB7BA37D7895693F643A4C84E5F0891AFB73CD83724D5B6B636A9722B94F726D4F5AAFA.B27F2FE6F14E583AFECAD4E5775498C1144639FB415F228F877EFACF8A1A3DA2BD5781238BD47BA00C4444C51A7F9D232E96F8C0A193E6FD8B64F2BC4E857A10' /etc/grub.d/40_custom
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo chattr +C /home
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
