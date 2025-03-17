#!/usr/bin/env bash
##################### git clone in ~/Downloads, then chmod +x s.sh and then ./s.sh (also dont forget to change fstab)####################################################
#git clone https://github.com/yeyushengfan258/Win11OS-kde && sudo bash ~/Downloads/inst/Win11OS-kde/install.sh && sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
#sudo visudo (Defaults timestamp_timeout=60)  (xfce4-terminal --drop-down xfce4-taskmanager kitty distrobox-enter -n arch /etc/sysconfig/btrfsmaintenance /etc/snapper/configs/root)  kernel-longterm
SECONDS=0
cp -r ~/Downloads/inst/files/* ~/.config/ && sudo mkdir -p /root/.config && sudo cp -r ~/Downloads/inst/files/* /root/.config/ && chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/* /usr/local/bin && mkdir ~/.othercrap && cp ~/Downloads/inst/script/*.png ~/.othercrap/
#sudo zypper install -y -n i3 nitrogen polybar python313-i3ipc i3lock && chmod +x ~/.config/polybar/launch.sh
unzip ~/Downloads/inst/script/FiraMono.zip -d ~/Downloads/inst/script/ > /dev/null 2>&1 && rm -f ~/Downloads/inst/script/README.md ~/Downloads/inst/script/LICENSE 2> /dev/null && sudo mkdir -p /usr/share/fonts/opentype && sudo mv ~/Downloads/inst/script/*.otf /usr/share/fonts/opentype/ && sudo fc-cache -f -v
mkdir -p ~/.themes && tar -xvf ~/Downloads/inst/script/Material-Black-Blueberry-2.9.9-07.tar -C ~/.themes > /dev/null && mkdir -p ~/.icons && unzip ~/Downloads/inst/script/Material-Black-Blueberry-Numix_1.9.3.zip -d ~/.icons > /dev/null
sudo zypper install -y -n feh rofi qalculate rofi-calc lsof google-noto-coloremoji-fonts ImageMagick symbols-only-nerd-fonts fetchmsttfonts meslo-lg-fonts vlc powerline-fonts starship memtest86+ kitty flatpak tealdeer bat zoxide fzf gdu eza ripgrep && sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo zypper --gpg-auto-import-keys ar -cfp 90 -n VLC http://download.videolan.org/pub/vlc/SuSE/Tumbleweed/ vlc && sudo zypper --gpg-auto-import-keys ref && sudo zypper in -y -n --allow-vendor-change vlc-codecs && sudo mkdir -p /usr/lib/vlc/lua/extensions/ && sudo mv ~/Downloads/inst/script/VlcPrevNext.lua /usr/lib/vlc/lua/extensions/
sudo zypper ref && sudo zypper up && cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config/ && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo systemctl stop packagekit.service && sudo zypper remove -y PackageKit && sudo zypper addlock PackageKit
#sudo zypper ar -f https://download.nvidia.com/opensuse/tumbleweed/ nvidia
#----Swap-------
#sudo zypper install -y -n systemd-zram-service && sudo systemctl enable --now zramswap.service 
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=z3fold zswap.max_pool_percent=25 zswap.accept_threshold_percent=90"/' /etc/default/grub && sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 6G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#------------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media && mkdir -p ~/.config/qBittorrent && mkdir -p ~/Media && mkdir -p ~/.wine && sudo mkdir -p /var/lib/flatpak && mkdir -p ~/.local/share/flatpak && sudo chattr -R +C ~/.config/qBittorrent && sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine && sudo chattr -R +C /var/lib/flatpak && sudo chattr -R +C ~/.local/share/flatpak
#sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path
#sudo zypper install -y -n system-config-printer-applet cups && sudo systemctl enable --now cups.service cups.socket cups.path
#-----------------------------------------------------
#sudo zypper remove -y discover6 && sudo zypper addlock discover6 && sudo zypper remove -y kwalletmanager && sudo zypper addlock kwalletmanager && akonadictl stop && systemctl --user disable akonadi && sudo zypper remove --clean-deps -y akonadi && sudo zypper addlock akonadi patterns-kde-kde_pim && sudo zypper install -y -n yakuake oxygen6-cursors yast2-theme-oxygen
#sudo zypper install -y -n xfce4-panel-profiles xfce4-whiskermenu-plugin xfce4-screenshooter xfce4-taskmanager adwaita-icon-theme dmz-icon-theme-cursors && sudo zypper remove -y pragha parole && sudo zypper addlock parole pragha
sudo zypper install -y -n libreoffice-writer libreoffice-writer-extensions cmatrix rpmorphan
sudo zypper install -y -n audacious yt-dlp cmus cmus-plugins-all mpv mpg123 mkvtoolnix-tools mkvtoolnix-gui steam lutris flac
sudo zypper install -y -n gsmartcontrol w3m ddgr xkill firewall-config podman distrobox bluez blueman rsync 
sudo zypper install -y -n dxvk hardinfo opi feh fastfetch nmap fakeroot bind wine-gecko catfish wine-mono winetricks proxychains-ng tor neovim gnome-system-monitor
sudo zypper install -y -n gamemode zip unrar gparted filezilla qbittorrent putty aria2 fuseiso android-tools q4wine flameshot
#sudo opi -n codecs
#sudo opi -n input-remapper && sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
#-----------------------------------------------------------------
#git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si && cd && rm -rf yay && sudo pacman -S autotiling git fzf eza bat starship zoxide neovim --noconfirm --needed && [ -f ~/.bash_profile ] || echo -e "if [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi" > ~/.bash_profile && mkdir -p ~/.config/nvim && cp /home/howling/.bash* ~/ && cp /home/howling/.config/starship.toml ~/.config/ && cp /home/howling/.config/nvim/* ~/.config/nvim/ && source ~/.bashrc
#yay -S --noconfirm bdinfo-git cli-visualizer-git  && mkdir -p ~/.config/vis/colors/ && echo -e "colors.override.terminal=false\ncolors.scheme=color\n\nvisualizer.spectrum.bar.width=1" > ~/.config/vis/config && echo -e "gradient=false\n4\n12\n6\n14\n2\n10\n11\n3\n5\n1\n13\n9\n7\n15\n0" > ~/.config/vis/colors/color
#distrobox-export -b /usr/bin/vis && distrobox-export -b bdinfo
#------------------------------------------------------------------
sudo flatpak install --noninteractive flathub io.gitlab.librewolf-community && sudo flatpak install --noninteractive flathub org.gnome.Boxes && sudo flatpak install --noninteractive flathub io.github.giantpinkrobots.varia && sudo flatpak install --noninteractive flathub net.mediaarea.MediaInfo && sudo flatpak install --noninteractive flathub com.github.tchx84.Flatseal && sudo flatpak install --noninteractive flathub org.torproject.torbrowser-launcher
sudo flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && sudo flatpak install --noninteractive flathub com.usebottles.bottles && sudo flatpak install --noninteractive flathub fr.handbrake.ghb && sudo flatpak install --noninteractive flathub net.davidotek.pupgui2 && sudo flatpak install --noninteractive flathub com.brave.Browser
sudo flatpak install --noninteractive flathub com.calibre_ebook.calibre && sudo flatpak install --noninteractive flathub org.gimp.GIMP && sudo flatpak install --noninteractive flathub com.github.Matoking.protontricks && sudo flatpak install --noninteractive flathub app.zen_browser.zen && sudo flatpak install --noninteractive flathub org.shotcut.Shotcut && sudo flatpak install --noninteractive flathub io.github.Hexchat
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep linux_amd64.rpm | cut -d\" -f4) && sudo zypper --no-gpg-checks install -y -n ~/Downloads/inst/autobrr*.rpm
mkdir -p ~/.othercrap && wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
sudo curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o /usr/local/bin/yt-x && sudo chmod +x /usr/local/bin/yt-x
#---kde---
#wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) > /dev/null 2>&1 && tar -xzf ~/Downloads/inst/ventoy*.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*"); mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/Ventoy.desktop
#wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#---xfce--
wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | jq -r '.assets[] | select(.name | test("linux.tar.gz")) | .browser_download_url') -O ~/Downloads/ventoy.tar.gz && mkdir -p ~/.othercrap && tar -xzf ~/Downloads/ventoy.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*") && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/Ventoy.desktop && chmod +x ~/.local/share/applications/Ventoy.desktop
wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rkhunter--------------------------
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf' && echo 'export VISUAL="nvim"' | sudo tee -a /root/.profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo zypper addlock qbittorrent
sudo systemctl start cron
#-----------------
sudo firewall-cmd --permanent --new-zone=howling && sudo firewall-cmd --permanent --zone=howling --add-source=192.168.0.0/24 && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="tcp" accept' && sudo firewall-cmd --permanent --zone=howling --add-rich-rule='rule family="ipv4" port port="1-65535" protocol="udp" accept' && sudo firewall-cmd --permanent --zone=howling --add-port=23232/tcp && sudo firewall-cmd --permanent --zone=howling --add-port=23232/udp && sudo firewall-cmd --permanent --zone=howling --set-target=DROP && sudo firewall-cmd --reload && sudo firewall-cmd --set-default-zone=howling
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && curl -O https://i.imgur.com/N51R4iT.jpg && cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/
#wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && mv yt-dlp_linux yt-dlp && chmod +x yt-dlp && sudo cp ~/Downloads/inst/yt-dlp /usr/local/bin
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip
wget https://github.com/sc0ty/subsync/releases/download/0.17/subsync-0.17.0-portable-amd64.exe
mv ~/Downloads/inst/subsync-0.17.0-portable-amd64.exe ~/.othercrap/
# ---------------------------------
mkdir -p ~/.othercrap/dedrm
unzip ~/Downloads/inst/DeDRM_tools_10.0.3.zip -d ~/.othercrap/dedrm > /dev/null
mkdir -p ~/.othercrap/eac3to
unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null
mv ~/Downloads/inst/script/tampermonkey-* ~/.othercrap/
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/script/'XMouseButtonControl 2.20.5 Portable.zip' ~/.othercrap/
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
cd ~/Downloads/inst/
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
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
#defaults,nodatacow,noatime,autodefrag,compress=zstd,space_cache=v2,nofail 0 0
#defaults,ssd,discard=async,noatime,compress=zstd,space_cache=v2 0 0
#sudo zypper install -y -n xhost && xhost +local:
#sudo zypper install -y -n conky && cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#zypper in mirrorsorcerer && systemctl enable --now mirrorsorcerer  xfce4-i3-workspaces-plugin  (patterns-games-games patterns-kde-kde_pim sudo zypper dup --from vlc --allow-vendor-change -y) (about:profiles, open root profile folder,Clear start up cache" ) sestatus  and /etc/selinux/config , Exec=/usr/bin/xdg-su -c /sbin/yast2  system-config-printer
#mkdir -p ~/Media/container/arch && distrobox create -n arch -i quay.io/toolbx/arch-toolbox:latest --init --home ~/Media/container/arch && distrobox enter arch
#mkdir -p ~/.config/nvim && cp /home/howling/.bash* ~/ && cp /home/howling/.config/starship.toml ~/.config/ && cp /home/howling/.config/nvim/* ~/.config/nvim/
#curl -s https://raw.githubusercontent.com/pavinjosdev/zypperoni/main/zypperoni | sudo tee /usr/bin/zypperoni > /dev/null && sudo chmod 755 /usr/bin/zypperoni
#sudo sed -i 's/^[[:space:]]*#\?[[:space:]]*solver\.onlyRequires[[:space:]]*=[[:space:]]*false/solver.onlyRequires = true/' /etc/zypp/zypp.conf
#sudo zypper in --no-recommends pamixer gnome-system-monitor mpv-mpris gvfs-backend-afc gvfs-backends gvfs-fuse pavucontrol dunst xfce4-terminal xfce4-taskmanager mousepad numlockx thunar-archive-plugin polkit-gnome htop NetworkManager-applet catfish jq thunar thunar-volman gvfs lxappearance
#sudo setsebool -P selinuxuser_execmod 1 && sudo setsebool -P selinuxuser_execheap 1 && sudo setsebool -P selinuxuser_execstack 1 
#browser: sudo semanage fcontext -a -t user_home_dir_t "/home/howling/Downloads(/.*)?" && sudo restorecon -Rv /home/howling/Downloads
