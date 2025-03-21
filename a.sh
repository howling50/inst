#!/usr/bin/env bash
##################### sudo chattr -R +C ~/Downloads then git clone in ~/Downloads, then chmod +x a.sh and then ./a.sh ####################################################
#git clone https://github.com/howling50/Top-5-Bootloader-Themes 
#git clone https://github.com/yeyushengfan258/Win11OS-kde && sudo bash ~/Downloads/inst/Win11OS-kde/install.sh && sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
SECONDS=0
sudo cp /etc/sudoers /etc/sudoers.tmp && sudo sed -i '/^# Defaults.*timestamp_timeout/s/^# //' /etc/sudoers.tmp && echo 'Defaults timestamp_timeout=60' | sudo tee -a /etc/sudoers.tmp > /dev/null && sudo cp /etc/sudoers.tmp /etc/sudoers && sudo rm -rf /etc/sudoers.tmp
sudo sh -c 'for option in "Color" "ILoveCandy" "VerbosePkgLists"; do grep -qx "$option" /etc/pacman.conf || sed -i "/\[options\]/a $option" /etc/pacman.conf; done' && sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
sudo pacman -Syu --noconfirm --needed && chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/* /usr/local/bin && mkdir ~/.othercrap && cp ~/Downloads/inst/script/*.png ~/.othercrap/
sudo pacman -S gnome-system-monitor file-roller reflector eza zoxide fzf bat feh zip unzip --noconfirm --needed && cp -r ~/Downloads/inst/files/* ~/.config/ && sudo mkdir -p /root/.config && sudo cp -r ~/Downloads/inst/files/* /root/.config/
mkdir -p ~/.themes && tar -xvf ~/Downloads/inst/script/Material-Black-Blueberry-2.9.9-07.tar -C ~/.themes > /dev/null && mkdir -p ~/.icons && unzip ~/Downloads/inst/script/Material-Black-Blueberry-Numix_1.9.3.zip -d ~/.icons > /dev/null
#sudo pacman -S i3-wm polybar python-i3ipc autotiling rofi rofi-calc i3lock --noconfirm --needed && chmod +x ~/.config/polybar/launch.sh
sudo reflector --verbose -c AT -c BE -c BG -c HR -c CZ -c DK -c EE -c FR -c DE -c GR -c HU -c LV -c LT -c LU -c NL -c PL -c RO -c CH -c GB --protocol https --sort rate --latest 20 --number 12 --download-timeout 20 --save /etc/pacman.d/mirrorlist
#sudo pacman -S nvidia-dkms nvidia-utils nvidia-settings
sudo pacman -S fastfetch kitty powerline-fonts starship flatpak rsync ttf-firacode-nerd ttf-meslo-nerd ttf-roboto terminus-font noto-fonts-emoji ttf-nerd-fonts-symbols --noconfirm --needed
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo pacman -S --needed base-devel git --noconfirm --needed && git clone https://aur.archlinux.org/yay.git && cd ~/Downloads/inst/yay && makepkg --noconfirm -si && cd ~/Downloads/inst && yay --sudoloop --save
sudo pacman -S cronie man-db --noconfirm --needed && sudo systemctl enable --now cronie.service
#----Swap-------
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=z3fold zswap.max_pool_percent=25 zswap.accept_threshold_percent=90"/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 6G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#-------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media && mkdir -p ~/.config/qBittorrent && mkdir -p ~/Media && mkdir -p ~/.wine && sudo mkdir -p /var/lib/flatpak && mkdir -p ~/.local/share/flatpak && sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine
#---
#curl -O https://blackarch.org/strap.sh && chmod +x strap.sh && sudo ./strap.sh
#---
#sudo pacman -S system-config-printer cups --noconfirm --needed && sudo systemctl enable --now cups.service cups.socket cups.path
#sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path
#balooctl disable && sudo rm -rf ~/./local/share/baloo
#-------------qemu---------------------------------
sudo pacman -S dnsmasq bridge-utils qemu-full virt-manager --noconfirm && sudo systemctl enable --now libvirtd && sudo usermod -a -G libvirt $(whoami) && sudo systemctl restart libvirtd && sudo virsh net-define /etc/libvirt/qemu/networks/default.xml && sudo virsh net-autostart default
#-----------------------------------------------------
#sudo pacman -R parole vim --noconfirm && sudo getent group autologin > /dev/null || sudo groupadd autologin && sudo usermod -aG autologin $USER
#sudo pacman -Rns kwalletmanager --noconfirm && sudo pacman -R elisa thunderbird vim --noconfirm && sudo pacman -S yakuake oxygen-icons gwenview okular kvantum-qt5 audiocd-kio --noconfirm --needed
sudo pacman -S binutils nmap gcc patch fakeroot bind rofi rofi-calc yazi --noconfirm --needed
sudo pacman -S qbittorrent putty aria2 bluez bluez-utils blueman fuseiso android-tools mpv vlc libreoffice-fresh viewnior --noconfirm --needed
sudo pacman -S ffmpeg libfdk-aac gst-plugins-base gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly --noconfirm --needed
sudo pacman -S wine wine-gecko wine-mono wine-nine winetricks flameshot --noconfirm --needed
sudo pacman -S catfish pacman-contrib gufw proxychains tor neovim pkgconf audacious lutris net-tools zip unzip lsof unrar gparted filezilla --noconfirm --needed
sudo pacman -S flac yt-dlp mkvtoolnix-cli mkvtoolnix-gui steam --noconfirm --needed
sudo pacman -S cpu-x gamemode gsmartcontrol cmatrix w3m ddgr cmus xorg-xkill podman distrobox e2fsprogs ripgrep memtest86+ tree gdu less mpg123 imagemagick tldr feh alsa-utils gptfdisk ntfs-3g os-prober python-pip --noconfirm --needed
#-----------------------------------------------------------------
yay -S --noconfirm dxvk-bin ventoy-bin reflector-simple quickemu quickgui-bin winegui-bin cli-visualizer input-remapper-git ttf-ms-fonts
#yay -S --noconfirm konsave
flatpak install --noninteractive flathub io.gitlab.librewolf-community && flatpak install --noninteractive flathub com.github.tchx84.Flatseal && flatpak install --noninteractive flathub net.mediaarea.MediaInfo && flatpak install --noninteractive flathub org.torproject.torbrowser-launcher && flatpak install --noninteractive flathub io.github.giantpinkrobots.varia
flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub org.gimp.GIMP && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub app.zen_browser.zen && flatpak install --noninteractive flathub org.shotcut.Shotcut && flatpak install --noninteractive flathub io.github.Hexchat
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub fr.handbrake.ghb && flatpak install --noninteractive flathub net.davidotek.pupgui2 && flatpak install --noninteractive flathub com.brave.Browser
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
sudo curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o /usr/local/bin/yt-x && sudo chmod +x /usr/local/bin/yt-x && mkdir -p ~/.local/share/vlc/lua/extensions/ && mv ~/Downloads/inst/script/*.lua ~/.local/share/vlc/lua/extensions/ && mkdir -p ~/.local/share/vlc/lua/playlist/ && mv ~/Downloads/inst/script/1/*.lua ~/.local/share/vlc/lua/playlist/
#wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) > /dev/null 2>&1 && tar -xzf ~/Downloads/inst/ventoy*.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*"); mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/Ventoy.desktop
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep amd64.pkg.tar.zst   | cut -d\" -f4) && sudo pacman -U autobrr*.tar.zst --noconfirm --needed
#----Kde---
#mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#---xfce--
mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper && sudo systemctl start avahi-daemon && sudo systemctl enable avahi-daemon
#------------Remote -----------------------------------
#sudo pacman -S remmina --noconfirm --needed && yay -S --noconfirm remmina-plugin-teamviewer remmina-plugin-ultravnc remmina-plugin-rdesktop remmina-plugin-url remmina-plugin-open remmina-plugin-folder
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
mkdir -p ~/.config/vis/colors/ && echo -e "colors.override.terminal=false\ncolors.scheme=color\n\nvisualizer.spectrum.bar.width=1" > ~/.config/vis/config && echo -e "gradient=false\n4\n12\n6\n14\n2\n10\n11\n3\n5\n1\n13\n9\n7\n15\n0" > ~/.config/vis/colors/color
#------------------------------------------rk hunter--------------------------
#sudo cp ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo pacman -S apparmor --noconfirm --needed && sudo systemctl start apparmor && sudo systemctl enable apparmor && sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 quiet apparmor=1 security=apparmor"/' /etc/default/grub
#-----------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
echo 'export VISUAL="nvim"' | sudo tee -a /root/.bash_profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.bash_profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
#sudo sed -i 's/^#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent kwalletmanager/' /etc/pacman.conf
#sudo touch /etc/cron.weekly/balance
#sudo bash -c 'echo -e "#!/usr/bin/env bash\nbtrfs scrub start / >> /home/howling/scrub.txt" >> /etc/cron.weekly/balance'
#sudo chmod +x /etc/cron.weekly/balance
#-----------------
echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile && echo '    source ~/.bashrc' >> ~/.bash_profile && echo 'fi' >> ~/.bash_profile && echo 'if [ -f /root/.bashrc ]; then' | sudo tee -a /root/.bash_profile && echo '    source /root/.bashrc' | sudo tee -a /root/.bash_profile && echo 'fi' | sudo tee -a /root/.bash_profile
#-----------------
sudo sed -i '$ a unqualified-search-registries=["registry.access.redhat.com", "registry.fedoraproject.org", "docker.io"]' /etc/containers/registries.conf
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && curl -O https://i.imgur.com/N51R4iT.jpg && cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/
#wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && mv yt-dlp_linux yt-dlp && chmod +x yt-dlp && sudo cp ~/Downloads/inst/yt-dlp /usr/local/bin
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip && wget https://github.com/sc0ty/subsync/releases/download/0.17/subsync-0.17.0-portable-amd64.exe && mv ~/Downloads/inst/subsync-0.17.0-portable-amd64.exe ~/.othercrap/
#---------------Firewall--------------
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow proto udp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow 23232/tcp && sudo ufw allow 23232/udp
sudo ufw default deny incoming && sleep 1 && sudo ufw default allow outgoing && sleep 1 && sudo systemctl enable ufw && sudo systemctl start ufw && sudo ufw enable
# ----------------------------------------------
#konsave -i ~/Downloads/inst/kde2.knsv
#sleep 1
#konsave -a kde2
#cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop
#cp ~/Downloads/inst/.conkyrc ~/.conkyrc
mkdir -p ~/.othercrap/dedrm && unzip ~/Downloads/inst/DeDRM_tools_10.0.3.zip -d ~/.othercrap/dedrm > /dev/null
mkdir -p ~/.othercrap/eac3to && unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null
mv ~/Downloads/inst/script/tampermonkey-* ~/.othercrap/ && mv ~/Downloads/inst/script/*.exe ~/.othercrap/ && mv ~/Downloads/inst/script/'XMouseButtonControl 2.20.5 Portable.zip' ~/.othercrap/
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
#conky -c ~/.conkyrc &
sed -i 's/"sudoloop": true/"sudoloop": false/' ~/.config/yay/config.json
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo sed -i '/^Defaults timestamp_timeout=/s/.*/# Defaults timestamp_timeout=15/' /etc/sudoers
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
#defaults,ssd,discard,noatime,compress=zstd,space_cache=v2 0 0
#sudo nano /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
#GRUB_DISABLE_SUBMENU=y
#sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo pacman -S gvfs-mtp gvfs-afc pamixer mpv-mpris dunst baobab numlockx pavucontrol tumbler polkit-gnome unzip htop jq xfce4-terminal xfce4-taskmanager imagemagick thunar thunar-volman thunar-archive-plugin gvfs lxappearance --needed
#/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm.conf or /etc/sddm.conf [Autologin] User=howling Session=i3       sudo pacman -S linux-lts linux-lts-headers && sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg         other: pika-backup
#git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git ~/Arch-Hyprland && cd ~/Arch-Hyprland && chmod +x install.sh && ./install.sh
