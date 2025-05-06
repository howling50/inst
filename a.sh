#!/usr/bin/env bash
##################### Check /etc/pacman.conf for multilib then go to /etc/fstab and then git clone in ~/Downloads, then chmod +x a.sh and then ./a.sh ####################################################
SECONDS=0
required_dir="$HOME/Downloads/inst"
if [[ $(pwd -P) != $(realpath "$required_dir") ]]; then
    echo -e "\033[31mERROR: Run script from $required_dir\033[0m" >&2
    exit 1
fi

if ! sudo -v; then
    echo -e "\033[31mERROR: Insufficient sudo privileges\033[0m" >&2
    exit 1
fi

if ! curl -sLf -o /dev/null https://google.com; then
    echo -e "\033[31mERROR: No internet connection\033[0m" >&2
    exit 1
fi

sudo timedatectl set-timezone Asia/Nicosia && sudo timedatectl set-ntp true
for dir in Media Downloads Music Videos Pictures; do [ ! -d "$HOME/$dir" ] && mkdir "$HOME/$dir"; done && mkdir -p ~/.local/bin/ && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
sudo cp /etc/sudoers /etc/sudoers.tmp && sudo sed -i '/^# Defaults.*timestamp_timeout/s/^# //' /etc/sudoers.tmp && echo 'Defaults timestamp_timeout=60' | sudo tee -a /etc/sudoers.tmp > /dev/null && sudo cp /etc/sudoers.tmp /etc/sudoers && sudo rm -rf /etc/sudoers.tmp
sudo sh -c 'for option in "Color" "ILoveCandy" "VerbosePkgLists"; do grep -qx "$option" /etc/pacman.conf || sed -i "/\[options\]/a $option" /etc/pacman.conf; done' && sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
chmod +x ~/Downloads/inst/scripts/* && mv ~/Downloads/inst/scripts/* ~/.local/bin/ && mkdir ~/.othercrap && mv ~/Downloads/inst/script/*.png ~/.othercrap/ && chmod +x ~/.config/hypr/scripts/* && chmod +x ~/.config/i3/scripts/* && mv ~/Downloads/inst/script/wallpaper ~/.othercrap/
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
git clone https://aur.archlinux.org/yay-bin.git && cd ~/Downloads/inst/yay-bin && makepkg --noconfirm -si && cd ~/Downloads/inst && rm -rf yay-bin && yay -Syu --noconfirm && yay -Y --sudoloop --save

# GRUB theme installation
read -p "Do you want to install a new GRUB theme? [Y/n] " -r
echo

answer=${REPLY:-Y}
answer=${answer,,}

if [[ $answer == "y" ]]; then
    echo "Installing GRUB themes..."
    
    if ! git clone https://github.com/howling50/Top-5-Bootloader-Themes; then
        echo "Error: Failed to clone repository!" >&2
        exit 1
    fi

    theme_dir="${required_dir}/Top-5-Bootloader-Themes"
    chmod +x "${theme_dir}/install.sh"
    sudo "${theme_dir}/install.sh"

    echo "GRUB theme installation completed!"
else
    echo "Skipping GRUB theme installation..."
fi

# Check for NVIDIA GPU and offer driver installation
if ! command -v lspci &>/dev/null; then
    sudo pacman -S --noconfirm pciutils
fi
if lspci | grep -i NVIDIA >/dev/null; then
    echo "NVIDIA GPU detected!"
    read -p "Do you want to install NVIDIA drivers? [Y/n] " -r
    echo
    
    answer=${REPLY:-Y}
    answer=${answer,,} 

    if [[ $answer == "y" ]]; then
        echo "Installing NVIDIA drivers..."
        if ! sudo pacman -S --noconfirm --needed nvidia-dkms nvidia-utils nvidia-settings; then
            echo "Error: Failed to install NVIDIA packages!" >&2
            exit 1
        fi
        echo "NVIDIA drivers installed successfully!"
    else
        echo "Skipping NVIDIA driver installation..."
    fi
fi

# Check and install printer support
if ! pacman -Qq cups &>/dev/null; then
    read -p "Printer support (CUPS) not installed. Install it? [Y/n] " -r
    echo
    
    answer=${REPLY:-Y}
    answer=${answer,,}

    if [[ $answer == "y" ]]; then
        echo "Installing printer support..."
        if ! sudo pacman -S --noconfirm --needed system-config-printer cups; then
            echo "Error: Failed to install printer packages!" >&2
            exit 1
        fi
        echo "Enabling CUPS service..."
        sudo systemctl enable --now cups.service cups.socket cups.path
        echo "Printer support installed and services enabled!"
    else
        echo "Skipping printer support installation..."
    fi
else
    echo "CUPS is already installed, skipping printer setup..."
fi

# AppArmor installation and configuration
read -p "Do you want to install and configure AppArmor? [Y/n] " -r
echo

answer=${REPLY:-Y}
answer=${answer,,}

if [[ $answer == "y" ]]; then
    echo "Installing and configuring AppArmor..."
    
    if ! sudo pacman -S --noconfirm --needed apparmor; then
        echo "Error: Failed to install AppArmor!" >&2
        exit 1
    fi
    
    sudo systemctl start apparmor
    sudo systemctl enable apparmor
    
    if ! sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ apparmor=1 security=apparmor"/' /etc/default/grub; then
        echo "Error: Failed to modify GRUB configuration!" >&2
        exit 1
    fi
    
    if ! sudo grub-mkconfig -o /boot/grub/grub.cfg; then
        echo "Error: Failed to update GRUB!" >&2
        exit 1
    fi
    
    echo "AppArmor installed and configured successfully!"
else
    echo "Skipping AppArmor installation..."
fi

# Check for KDE Plasma and customize accordingly
if pacman -Qs plasma-desktop >/dev/null; then
    echo "KDE Plasma detected! Applying KDE customizations..."
    
    sudo pacman -Rns kwalletmanager --noconfirm
    sudo pacman -R elisa thunderbird --noconfirm
    rm -rf "${required_dir}/files/gtk-3.0"
    
    sudo pacman -S yakuake oxygen-icons gwenview okular kvantum-qt5 audiocd-kio --noconfirm --needed
    
    git clone https://github.com/yeyushengfan258/Win11OS-kde
    sudo bash "${required_dir}/Win11OS-kde/install.sh"
    
    echo "KDE customization completed!"
else
    echo "Non-KDE environment detected. Applying basic customizations..."
    
    sudo pacman -R parole --noconfirm
    sudo pacman -S --noconfirm --needed i3-wm polybar python-i3ipc autotiling i3lock lxappearance udiskie
    sudo pacman -S --noconfirm --needed man-db bc arandr viewnior rofi rofi-calc flameshot gvfs-mtp gvfs-afc mpv-mpris baobab numlockx tumbler thunar-archive-plugin file-roller fbreader ffmpegthumbnailer catfish pamixer dunst pavucontrol thunar-volman  
    mkdir -p ~/.themes && tar -xvf ~/Downloads/inst/script/Material-Black-Blueberry-2.9.9-07.tar -C ~/.themes > /dev/null && mkdir -p ~/.icons && unzip ~/Downloads/inst/script/Material-Black-Blueberry-Numix_1.9.3.zip -d ~/.icons > /dev/null && gtk-update-icon-cache -f -t "/home/$(whoami)/.icons/Material-Black-Blueberry-Numix/" && wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
    sudo getent group autologin >/dev/null || sudo groupadd autologin
    sudo usermod -aG autologin "$(whoami)"
    
    echo "Desktop Specific customization completed!"
fi

sudo pacman -S wireplumber playerctl bash-completion neovim trash-cli xclip pacman-contrib jq gnome-system-monitor reflector eza zoxide fzf bat feh zip unzip --noconfirm --needed && cp -r ~/Downloads/inst/files/* ~/.config/ && sudo mkdir -p /root/.config && sudo cp -r ~/Downloads/inst/files/* /root/.config/
sudo reflector --verbose -c AT -c BE -c BG -c HR -c CZ -c DK -c EE -c FR -c DE -c GR -c HU -c LV -c LT -c LU -c NL -c PL -c RO -c CH -c GB --protocol https --sort rate --latest 20 --number 12 --download-timeout 20 --save /etc/pacman.d/mirrorlist
sudo pacman -S fastfetch kitty powerline-fonts starship flatpak rsync ttf-firacode-nerd ttf-meslo-nerd ttf-roboto terminus-font noto-fonts-emoji ttf-nerd-fonts-symbols --noconfirm --needed
#----Swap-------
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=z3fold zswap.max_pool_percent=25 zswap.accept_threshold_percent=90"/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo btrfs subvol create /Swap && sudo chattr +C /Swap && sudo swapoff -a && sudo truncate -s 0 /Swap/swapfile && sudo dd if=/dev/zero of=/Swap/swapfile bs=1M count=6144 status=progress conv=fsync && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap defaults,nodatacow,discard 0 0' | sudo tee -a /etc/fstab
#-------------qemu---------------------------------
sudo pacman -S dnsmasq bridge-utils qemu-full virt-manager --noconfirm && sudo systemctl enable --now libvirtd && sudo usermod -a -G libvirt $(whoami) && sudo systemctl restart libvirtd && sudo virsh net-define /etc/libvirt/qemu/networks/default.xml && sudo virsh net-autostart default
#-----------------------------------------------------
sudo pacman -S binutils nmap gcc patch fakeroot bind yazi gimp easytag mediainfo-gui mediainfo npm xournalpp --noconfirm --needed
sudo pacman -S qbittorrent putty aria2 bluez bluez-utils blueman fuseiso android-tools mpv vlc libreoffice-fresh cava perl-image-exiftool shotcut hexchat gnome-boxes handbrake --noconfirm --needed
sudo pacman -S ffmpeg libfdk-aac gst-plugins-base gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly --noconfirm --needed
sudo pacman -S wine wine-gecko wine-mono wine-nine winetricks --noconfirm --needed
sudo pacman -S gufw proxychains tor pkgconf audacious lutris net-tools zip unzip lsof unrar gparted filezilla --noconfirm --needed
sudo pacman -S flac yt-dlp mkvtoolnix-cli mkvtoolnix-gui steam --noconfirm --needed
sudo pacman -S cpu-x gamemode gsmartcontrol cmatrix w3m ddgr cmus xorg-xkill podman distrobox e2fsprogs ripgrep memtest86+ tree gdu less mpg123 imagemagick tldr feh alsa-utils gptfdisk ntfs-3g os-prober python-pip --noconfirm --needed
#-----------------------------------------------------------------
yay -S --noconfirm dxvk-bin ventoy-bin winegui-bin input-remapper-bin ttf-ms-fonts dragon-drop heroic-games-launcher-bin urlview pacseek-bin autobrr-bin
flatpak install --noninteractive flathub io.gitlab.librewolf-community && flatpak install --noninteractive flathub com.github.tchx84.Flatseal && flatpak install --noninteractive flathub org.torproject.torbrowser-launcher && flatpak install --noninteractive flathub io.github.giantpinkrobots.varia
flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub app.zen_browser.zen
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub net.davidotek.pupgui2
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | jq -r '.assets[] | select(.name | test("ani-cli")) | .browser_download_url') -O ani-cli && chmod +x ani-cli && mv ani-cli ~/.local/bin/ && rm ani-cli*
curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o ~/.local/bin/yt-x && chmod +x ~/.local/bin/yt-x && mkdir -p ~/.local/share/vlc/lua/extensions/ && mv ~/Downloads/inst/script/*.lua ~/.local/share/vlc/lua/extensions/ && mkdir -p ~/.local/share/vlc/lua/playlist/ && mv ~/Downloads/inst/script/1/*.lua ~/.local/share/vlc/lua/playlist/
curl -sL https://www.rarlab.com/rar/rarlinux-x64-$(curl -sL https://www.rarlab.com/download.htm | grep -oP 'rarlinux-x64-\K[0-9]+\.tar\.gz' | head -n1) -o rarlinux.tar.gz && tar -xzf rarlinux.tar.gz && mv rar/rar ~/.local/bin/ && rm -rf rar rarlinux.tar.gz
mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper && sudo systemctl start avahi-daemon && sudo systemctl enable avahi-daemon
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo mv ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------
echo 'export VISUAL="nvim"' | sudo tee -a /root/.bash_profile  >/dev/null && echo 'export VISUAL="nvim"' | tee -a ~/.bash_profile  >/dev/null
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent kwalletmanager/' /etc/pacman.conf && flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications:create
#-----------------
echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile && echo '    source ~/.bashrc' >> ~/.bash_profile && echo 'fi' >> ~/.bash_profile && echo 'if [ -f /root/.bashrc ]; then' | sudo tee -a /root/.bash_profile && echo '    source /root/.bashrc' | sudo tee -a /root/.bash_profile && echo 'fi' | sudo tee -a /root/.bash_profile
#-----------------
sudo sed -i '$ a unqualified-search-registries=["registry.access.redhat.com", "registry.fedoraproject.org", "docker.io"]' /etc/containers/registries.conf
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && curl -O https://i.imgur.com/N51R4iT.jpg && cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/ && sudo usermod -aG gamemode,wheel,adbusers,input "$(whoami)"
wget $(curl -s https://api.github.com/repos/UniqProject/BDInfo/releases/latest | grep download | grep .zip  | cut -d\" -f4) && mv BDInfo_*.zip ~/.othercrap
wget $(curl -s https://api.github.com/repos/sc0ty/subsync/releases/latest | grep download | grep portable-amd64.exe   | cut -d\" -f4) && mv subsync-*-portable-amd64.exe ~/.othercrap
wget $(curl -s https://api.github.com/repos/noDRM/DeDRM_tools/releases/latest | grep download | grep .zip   | cut -d\" -f4) && mv DeDRM_tools_*.zip ~/.othercrap
wget --trust-server-names --content-disposition "https://www.highrez.co.uk/scripts/download.asp?package=XMousePortable" && mv XMouseButtonControl*Portable.zip ~/.othercrap
#---------------Firewall--------------
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow proto udp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow 23232/tcp && sudo ufw allow 23232/udp
sudo ufw default deny incoming && sleep 1 && sudo ufw default allow outgoing && sleep 1 && sudo systemctl enable ufw && sudo systemctl start ufw && sudo ufw enable
# ----------------------------------------------
mkdir -p ~/.othercrap/eac3to
unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null && unrar x ~/Downloads/inst/script/1.rar ~/.othercrap > /dev/null
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
sudo sed -i 's/version_sort -r/version_sort/' /etc/grub.d/10_linux
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i '/^Defaults timestamp_timeout=/s/.*/# Defaults timestamp_timeout=15/' /etc/sudoers
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
#defaults,ssd,noatime,compress=zstd:3,space_cache=v2 0 0
#snapshots = defaults,ssd,noatime,compress=no,space_cache=v2 0 0
#ext4 = defaults,noatime,barrier=1,data=ordered,errors=remount-ro,commit=60,nofail 0 2
#--
#sudo pacman -S linux-lts linux-lts-headers && sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo nano /etc/grub.d/10_linux  then Find the line with version_sort -r and remove the -r the save and sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo nano /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
#GRUB_DISABLE_SUBMENU=y
#----other repos---
#cachyosrepo install = curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz && tar xvf cachyos-repo.tar.xz && cd cachyos-repo && sudo ./cachyos-repo.sh && sudo pacman -Syu
#cachyosrepo uninst = curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz && tar xvf cachyos-repo.tar.xz && cd cachyos-repo&& sudo ./cachyos-repo.sh --remove && sudo pacman -Syu
#BlackArch = curl -O https://blackarch.org/strap.sh && chmod +x strap.sh && sudo ./strap.sh && sudo pacman -Syu
#---------------
#conky: sudo pacman -S conkie && cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#sudo pacman -S cronie man-db --noconfirm --needed && sudo systemctl enable --now cronie.service
#faster shutdown: sudo sed -i 's/^#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
#balooctl disable && sudo rm -rf ~/./local/share/baloo
#sudo pacman -S  i3-wm polybar python-i3ipc autotiling i3lock gvfs-mtp gvfs-afc pamixer mpv-mpris dunst baobab numlockx pavucontrol tumbler polkit-gnome unzip htop jq xfce4-terminal xfce4-taskmanager imagemagick thunar thunar-volman thunar-archive-plugin gvfs lxappearance  --noconfirm --needed && chmod +x ~/.config/polybar/launch.sh
#/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm.conf or /etc/sddm.conf [Autologin] User=howling Session=i3   other: pika-backup
#sh <(curl -L https://raw.githubusercontent.com/JaKooLit/Arch-Hyprland/main/auto-install.sh) or bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/setup-arch.sh)
#sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
#yay -Y --sudoloop=false --save
