#!/usr/bin/env bash
##################### git clone in ~/Downloads, then chmod +x s.sh and then ./s.sh ####################################################
#https://github.com/howling50/Top-5-Bootloader-Themes
#git clone https://github.com/yeyushengfan258/Win11OS-kde && sudo bash ~/Downloads/inst/Win11OS-kde/install.sh && sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
#sudo visudo (Defaults timestamp_timeout=60)
#sudo zypper install -y -n conky && cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#curl -L https://nixos.org/nix/install | sh
#distrobox create -n arch -i quay.io/toolbx/arch-toolbox --init --additional-packages "systemd git fzf eza starship zoxide thefuck neovim" --home ~/Media/container/arch
#https://www.opensuse-community.org/
SECONDS=0
sudo zypper ref && sudo zypper up
sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper dup --from packman --allow-vendor-change
sudo zypper install -y -n powerline-fonts starship
#----Swap-------
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 8G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#------------
sudo mkdir -p /etc/cron.minutely && sudo cp ~/Downloads/inst/mycronjobs /etc/cron.d/ && chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/1 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/2 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/timer /usr/local/bin && sudo cp ~/Downloads/inst/scripts/mp4decrypt /usr/local/bin && sudo cp ~/Downloads/inst/scripts/checkerror /usr/local/bin
#-------
sudo btrfs subvol create ~/Media && sudo chown $(whoami):$(whoami) ~/Media && sudo chmod 755 ~/Media && sudo btrfs subvol create ~/.wine && sudo chown $(whoami):$(whoami) ~/.wine && sudo chmod 755 ~/.wine && sudo btrfs subvol create ~/.config/qBittorrent && sudo chown $(whoami):$(whoami) ~/.config/qBittorrent && sudo chmod 755 ~/.config/qBittorrent
#--------
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config/ && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path
#-----------------------------------------------------
sudo zypper remove -y kwalletmanager kmail
sudo zypper install -y -n xkill firewall-config tealdeer patterns-devel-base-devel_basis bat zoxide fzf gdu tree eza thefuck ripgrep e2fsprogs podman distrobox symbols-only-nerd-fonts fetchmsttfonts meslo-lg-fonts oxygen6-cursors mpv
sudo zypper install -y -n less dxvk hardinfo opi mpg123 ImageMagick feh fastfetch binutils hiredis ccache nmap make autoconf flex gcc patch automake bison fakeroot bind yast2-theme-oxygen wine-gecko catfish wine-mono winetricks steam proxychains-ng tor neovim kitty gamemode audacious lutris zip unrar mkvtoolnix-tools mkvtoolnix-gui gparted celluloid mediainfo flac filezilla aegisub virtualbox qbittorrent putty kdialog aria2 google-roboto-fonts fuseiso android-tools yakuake
sudo opi -n codecs
sudo opi -n input-remapper
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
#-----------------------------------------------------------------
#bdinfo-git quickemu quickgui-bin
#sudo flatpak install --noninteractive flathub com.github.tchx84.Flatseal
sudo flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && sudo flatpak install --noninteractive flathub com.usebottles.bottles && sudo flatpak install --noninteractive flathub fr.handbrake.ghb && sudo flatpak install --noninteractive flathub net.davidotek.pupgui2 && sudo flatpak install --noninteractive flathub com.brave.Browser
sudo flatpak install --noninteractive flathub com.calibre_ebook.calibre && sudo flatpak install --noninteractive flathub org.gimp.GIMP && sudo flatpak install --noninteractive flathub com.github.Matoking.protontricks && sudo flatpak install --noninteractive flathub io.gitlab.librewolf-community && sudo flatpak install --noninteractive flathub net.pcsx2.PCSX2 && sudo flatpak install --noninteractive flathub org.shotcut.Shotcut && sudo flatpak install --noninteractive flathub io.github.Hexchat
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep linux_amd64.rpm | cut -d\" -f4) && sudo zypper --no-gpg-checks install -y -n ~/Downloads/inst/autobrr*.rpm
mkdir -p ~/.othercrap
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) > /dev/null 2>&1
tar -xzf ~/Downloads/inst/ventoy*.tar.gz -C ~/.othercrap/
ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*"); mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/Ventoy.desktop
wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop
chmod +x ~/.local/share/applications/stacer.desktop && mkdir -p ~/.local/share/kservices5/ServiceMenus/ && cp ~/Downloads/inst/scripts/mediainfo.sh ~/.othercrap/ && cp ~/Downloads/inst/scripts/mediainfo.desktop ~/.local/share/kservices5/ServiceMenus/
mkdir -p ~/.config/fastfetch && cp ~/Downloads/inst/config.jsonc ~/.config/fastfetch/ && sudo mkdir -p /root/.config/fastfetch && sudo cp ~/Downloads/inst/config.jsonc /root/.config/fastfetch/
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf' && echo 'export VISUAL="nvim"' | sudo tee -a /root/.profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo zypper addlock qbittorrent
sudo touch /etc/cron.weekly/balance
sudo bash -c 'echo -e "#!/usr/bin/env bash\nbtrfs scrub start / >> /home/howling/scrub.txt" >> /etc/cron.weekly/balance'
#-----------------
sudo firewall-cmd --permanent --new-zone=howling && sudo firewall-cmd --permanent --zone=howling --add-source=192.168.0.0/24 && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="tcp" accept' && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="udp" accept' && sudo firewall-cmd --permanent --zone=howling --add-port=23232/tcp && sudo firewall-cmd --permanent --zone=howling --add-port=23232/udp && sudo firewall-cmd --permanent --zone=howling --set-target=DROP && sudo firewall-cmd --set-default-zone=howling && sudo firewall-cmd --reload
sudo chmod +x /etc/cron.weekly/balance
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && mkdir -p ~/.config/nvim/ && cp ~/Downloads/inst/init.lua ~/.config/nvim/
curl -O https://i.imgur.com/N51R4iT.jpg
cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/
sudo mkdir -p /root/.config/nvim/
sudo cp ~/Downloads/inst/init.lua /root/.config/nvim/
cd ~/Downloads/inst/
wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
mv yt-dlp_linux yt-dlp
chmod +x yt-dlp
sudo cp ~/Downloads/inst/yt-dlp /usr/bin/
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip
cp -r ~/Downloads/inst/files/* ~/.config/
cd
cd ~/Downloads/inst/
# ---------------------------------
#sudo snapper -c home create-config /home
convert ~/Downloads/inst/script/monkey.jpg ~/Downloads/inst/script/monkey.png
mv ~/Downloads/inst/script/monkey.png ~/.othercrap/monkey.png
mkdir -p ~/.othercrap/dedrm
unzip ~/Downloads/inst/DeDRM_tools_10.0.3.zip -d ~/.othercrap/dedrm > /dev/null
mkdir -p ~/.othercrap/eac3to
unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null
mv ~/Downloads/inst/script/tampermonkey-* ~/.othercrap/
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/script/'XMouseButtonControl 2.20.5 Portable.zip' ~/.othercrap/
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine
cd ~/Downloads/inst/
sudo sed -i '$ a\set superusers="mastros"\npassword_pbkdf2 mastros grub.pbkdf2.sha512.10000.77DA16D22A3A8D15AA247F40FA13D6248A92B70D588CFBA14D0C61B15CB7BA37D7895693F643A4C84E5F0891AFB73CD83724D5B6B636A9722B94F726D4F5AAFA.B27F2FE6F14E583AFECAD4E5775498C1144639FB415F228F877EFACF8A1A3DA2BD5781238BD47BA00C4444C51A7F9D232E96F8C0A193E6FD8B64F2BC4E857A10' /etc/grub.d/40_custom
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
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
