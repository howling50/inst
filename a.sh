#!/usr/bin/env bash
##################### sudo chattr -R +C ~/Downloads then git clone in ~/Downloads, then chmod +x a.sh and then ./a.sh ####################################################
#git clone https://github.com/howling50/Top-5-Bootloader-Themes 
#git clone https://github.com/yeyushengfan258/Win11OS-kde && sudo bash ~/Downloads/inst/Win11OS-kde/install.sh && sudo bash ~/Downloads/inst/Win11OS-kde/sddm-dark/install.sh
#xfce4-terminal --drop-down /etc/lightdm/lightdm.conf  
SECONDS=0
sudo chattr +C /home
sudo cp /etc/sudoers /etc/sudoers.tmp && sudo sed -i '/^# Defaults.*timestamp_timeout/s/^# //' /etc/sudoers.tmp && echo 'Defaults timestamp_timeout=60' | sudo tee -a /etc/sudoers.tmp > /dev/null && sudo cp /etc/sudoers.tmp /etc/sudoers && sudo rm -rf /etc/sudoers.tmp
sudo sh -c 'for option in "Color" "ILoveCandy" "VerbosePkgLists"; do grep -qx "$option" /etc/pacman.conf || sed -i "/\[options\]/a $option" /etc/pacman.conf; done' && sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
sudo pacman -Syyu --noconfirm --needed
sudo pacman -S reflector --noconfirm --needed
sudo reflector --latest 5 --sort rate --download-timeout 10 --save /etc/pacman.d/mirrorlist
#sudo pacman -S nvidia nvidia-utils nvidia-settings
sudo pacman -S cronie man-db --noconfirm --needed && sudo systemctl enable --now cronie.service
sudo pacman -S fastfetch firefox kitty powerline-fonts starship flatpak --noconfirm --needed
sudo pacman -S --needed base-devel git --noconfirm --needed
git clone https://aur.archlinux.org/yay.git && cd ~/Downloads/inst/yay && makepkg --noconfirm -si && cd ~/Downloads/inst && yay --sudoloop --save
#----Swap-------
sudo btrfs subvol create /Swap && sudo chattr -R +C /Swap && sudo swapoff -a && sudo fallocate -l 6G /Swap/swapfile && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab && sudo swapon -a
#------------
chmod +x ~/Downloads/inst/scripts/* && sudo cp ~/Downloads/inst/scripts/1 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/2 /usr/local/bin && sudo cp ~/Downloads/inst/scripts/timer /usr/local/bin && sudo cp ~/Downloads/inst/scripts/mp4decrypt /usr/local/bin && sudo cp ~/Downloads/inst/scripts/checkerror /usr/local/bin
#-------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media
mkdir -p ~/.config/qBittorrent && mkdir -p ~/Media && mkdir -p ~/.wine && sudo mkdir -p /var/lib/flatpak && mkdir -p ~/.local/share/flatpak
sudo chattr -R +C ~/.config/qBittorrent && sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine && sudo chattr -R +C /var/lib/flatpak && sudo chattr -R +C ~/.local/share/flatpak && cd ~/Downloads/inst/
#---
#curl -O https://blackarch.org/strap.sh && chmod +x strap.sh && sudo ./strap.sh
#---
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config && sudo cp ~/Downloads/inst/starship.toml /root/.config/
sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path && balooctl disable && sudo rm -rf ~/./local/share/baloo
#-------------qemu---------------------------------
sudo pacman -S dnsmasq bridge-utils qemu-full virt-manager --noconfirm && sudo systemctl enable --now libvirtd && sudo usermod -a -G libvirt $(whoami) && sudo systemctl restart libvirtd && sudo virsh net-define /etc/libvirt/qemu/networks/default.xml && sudo virsh net-autostart default
#-----------------------------------------------------
#sudo pacman -S conky --noconfirm --needed
#sudo pacman -S virtualbox jdk-openjdk --noconfirm --needed && yay -S --noconfirm virtualbox-ext-oracle
#sudo pacman -S xfce4-panel-profiles xfce4-whiskermenu-plugin xfce4-screenshooter xfce4-taskmanager baobab file-roller --noconfirm --needed && sudo pacman -R parole vim --noconfirm && sudo getent group autologin > /dev/null || sudo groupadd autologin && sudo usermod -aG autologin $USER
sudo pacman -Rns kwalletmanager --noconfirm && sudo pacman -R elisa thunderbird vim --noconfirm && sudo pacman -S yakuake oxygen-icons gwenview okular kvantum-qt5 audiocd-kio --noconfirm --needed
sudo pacman -S binutils nmap autoconf bat gcc patch fakeroot bind --noconfirm --needed
sudo pacman -S qbittorrent putty aria2 ttf-roboto bluez bluez-utils blueman fuseiso android-tools apparmor mpv vlc libreoffice-fresh --noconfirm --needed
sudo pacman -S ffmpeg libfdk-aac gst-plugins-base gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly --noconfirm --needed
sudo pacman -S wine wine-gecko wine-mono wine-nine winetricks --noconfirm --needed
sudo pacman -S catfish pacman-contrib gufw proxychains tor neovim pkgconf audacious lutris net-tools zip unzip lsof unrar rkhunter gparted filezilla --noconfirm --needed
sudo pacman -S flac yt-dlp mkvtoolnix-cli mkvtoolnix-gui steam --noconfirm --needed
sudo pacman -S cpu-x gamemode gsmartcontrol cmatrix w3m ddgr ttf-firacode-nerd cmus xorg-xkill ttf-meslo-nerd podman distrobox e2fsprogs ripgrep eza memtest86+ tree gdu zoxide fzf less memtest86+-efi mpg123 imagemagick tldr feh alsa-utils awesome-terminal-fonts exfat-utils gptfdisk ntfs-3g ntp os-prober python-pyqt5 python-pip terminus-font ttf-droid --noconfirm --needed
#-----------------------------------------------------------------
#yay -S --noconfirm ffmpeg-full
yay -S --noconfirm ventoy-bin reflector-simple quickemu quickgui-bin winegui cli-visualizer dxvk-bin input-remapper-git ttf-ms-fonts
#yay -S --noconfirm sublime-text-4 
#yay -S --noconfirm konsave
sudo flatpak install --noninteractive flathub com.github.tchx84.Flatseal && sudo flatpak install --noninteractive flathub net.mediaarea.MediaInfo
flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub org.gimp.GIMP && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub app.zen_browser.zen && flatpak install --noninteractive flathub org.shotcut.Shotcut && flatpak install --noninteractive flathub io.github.Hexchat
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub fr.handbrake.ghb && flatpak install --noninteractive flathub net.davidotek.pupgui2 && flatpak install --noninteractive flathub com.brave.Browser
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
sudo curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o /usr/local/bin/yt-x && sudo chmod +x /usr/local/bin/yt-x
#wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep download | grep linux.tar.gz | cut -d\" -f4) > /dev/null 2>&1 && tar -xzf ~/Downloads/inst/ventoy*.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*"); mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/Ventoy.desktop
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep amd64.pkg.tar.zst   | cut -d\" -f4) && sudo pacman -U autobrr*.tar.zst --noconfirm --needed
#----Kde---
mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=~/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=~/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#---xfce--
#mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
mkdir -p ~/.config/fastfetch && cp ~/Downloads/inst/config.jsonc ~/.config/fastfetch/ && sudo mkdir -p /root/.config/fastfetch && sudo cp ~/Downloads/inst/config.jsonc /root/.config/fastfetch/
#------------Remote -----------------------------------
#sudo pacman -S remmina --noconfirm --needed && yay -S --noconfirm remmina-plugin-teamviewer remmina-plugin-ultravnc remmina-plugin-rdesktop remmina-plugin-url remmina-plugin-open remmina-plugin-folder
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
mkdir -p ~/.config/vis/colors/ && echo -e "colors.override.terminal=false\ncolors.scheme=color\n\nvisualizer.spectrum.bar.width=1" > ~/.config/vis/config && echo -e "gradient=false\n4\n12\n6\n14\n2\n10\n11\n3\n5\n1\n13\n9\n7\n15\n0" > ~/.config/vis/colors/color
#------------------------------------------rk hunter--------------------------
sudo cp ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local && sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo systemctl start apparmor && sudo systemctl enable apparmor && sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 quiet apparmor=1 security=apparmor"/' /etc/default/grub
#-----------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq'
sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
echo 'export VISUAL="nvim"' | sudo tee -a /root/.bash_profile  >/dev/null
echo 'export VISUAL="nvim"' | tee -a ~/.bash_profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo sed -i 's/^#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent kwalletmanager/' /etc/pacman.conf
#sudo touch /etc/cron.weekly/balance
#sudo bash -c 'echo -e "#!/usr/bin/env bash\nbtrfs scrub start / >> /home/howling/scrub.txt" >> /etc/cron.weekly/balance'
#sudo chmod +x /etc/cron.weekly/balance
#-----------------
echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile
echo '    source ~/.bashrc' >> ~/.bash_profile
echo 'fi' >> ~/.bash_profile
echo 'if [ -f /root/.bashrc ]; then' | sudo tee -a /root/.bash_profile
echo '    source /root/.bashrc' | sudo tee -a /root/.bash_profile
echo 'fi' | sudo tee -a /root/.bash_profile
#-----------------
sudo sed -i '$ a unqualified-search-registries=["registry.access.redhat.com", "registry.fedoraproject.org", "docker.io"]' /etc/containers/registries.conf
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && mkdir -p ~/.config/nvim/ && cp ~/Downloads/inst/init.lua ~/.config/nvim/ && curl -O https://i.imgur.com/N51R4iT.jpg && cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/ && sudo mkdir -p /root/.config/nvim/ && sudo cp ~/Downloads/inst/init.lua /root/.config/nvim/
cd ~/Downloads/inst/
#wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux && mv yt-dlp_linux yt-dlp && chmod +x yt-dlp && sudo cp ~/Downloads/inst/yt-dlp /usr/local/bin
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip && wget https://github.com/sc0ty/subsync/releases/download/0.17/subsync-0.17.0-portable-amd64.exe && mv ~/Downloads/inst/subsync-0.17.0-portable-amd64.exe ~/.othercrap/
#---------------Firewall--------------
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow proto udp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow 23232/tcp && sudo ufw allow 23232/udp
sudo ufw default deny incoming 
sleep 1
sudo ufw default allow outgoing
sleep 1
sudo systemctl enable ufw && sudo systemctl start ufw && sudo ufw enable
cp -r ~/Downloads/inst/files/* ~/.config/ && cd && cd ~/Downloads/inst/
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
magick ~/Downloads/inst/script/monkey.jpg ~/.othercrap/monkey.png
#conky -c ~/.conkyrc &
sed -i 's/"sudoloop": true/"sudoloop": false/' ~/.config/yay/config.json
sudo sed -i '$ a\set superusers="mastros"\npassword_pbkdf2 mastros grub.pbkdf2.sha512.10000.77DA16D22A3A8D15AA247F40FA13D6248A92B70D588CFBA14D0C61B15CB7BA37D7895693F643A4C84E5F0891AFB73CD83724D5B6B636A9722B94F726D4F5AAFA.B27F2FE6F14E583AFECAD4E5775498C1144639FB415F228F877EFACF8A1A3DA2BD5781238BD47BA00C4444C51A7F9D232E96F8C0A193E6FD8B64F2BC4E857A10' /etc/grub.d/40_custom
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/' /etc/default/grub
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
