#!/usr/bin/env bash
##################### git clone in ~/Downloads, then chmod +x s.sh and then ./s.sh (also dont forget to change fstab)####################################################
#sudo visudo (Defaults timestamp_timeout=60 %wheel ALL=(ALL:ALL) ALL  #Defaults targetpw  #ALL   ALL=(ALL) ALL)  (/etc/sysconfig/btrfsmaintenance /etc/snapper/configs/root) sudo zypper ref && sudo zypper dup && sudo zypper inr
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

detect_display_manager() {
    if [ -L /etc/alternatives/default-displaymanager ]; then
        dm_bin=$(readlink -f /etc/alternatives/default-displaymanager)
        dm_name=$(basename "$dm_bin")
        echo "$dm_name"
        return 0
    fi

    if systemctl is-active sddm &>/dev/null; then
        echo "sddm"
        return 0
    elif systemctl is-active lightdm &>/dev/null; then
        echo "lightdm"
        return 0
    fi

    if [ -f /etc/sysconfig/displaymanager ]; then
        source /etc/sysconfig/displaymanager
        if [ -n "$DISPLAYMANAGER" ]; then
            echo "${DISPLAYMANAGER,,}"  # Convert to lowercase
            return 0
        fi
    fi

    return 1
}

CURRENT_DM=$(detect_display_manager)

case $CURRENT_DM in
    sddm)
        echo "SDDM detected - proceeding with autologin configuration"
        ;;
    lightdm)
        echo "LightDM detected - switching to SDDM"
        sudo zypper remove -y -n lightdm lightdm-gtk-greeter
        sudo zypper addlock lightdm lightdm-gtk-greeter
        sudo zypper install -y -n sddm
        sudo systemctl enable sddm --now
        CURRENT_DM="sddm"
        echo "Display manager switched to SDDM"
        ;;
    *)
        echo "Error: Could not detect SDDM or LightDM display manager"
        echo "Detected display manager: '$CURRENT_DM'"
        echo "Please ensure SDDM is installed and configured"
        exit 1
        ;;
esac

if [ "$CURRENT_DM" = "sddm" ]; then    
    echo "Configuring autologin for user $(whoami)..."
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Autologin]\nUser=$(whoami)\nSession=plasma" | sudo tee /etc/sddm.conf.d/20-autologin.conf >/dev/null
    
    echo "Applying openSUSE-specific settings..."
    sudo touch /etc/sddm.conf
    sudo sed -i '/^\[Autologin\]/,/^\[/{/^\[Autologin\]/!d}' /etc/sddm.conf
    sudo sed -i '/^User=.*/d' /etc/sddm.conf
    sudo sed -i '/^Session=.*/d' /etc/sddm.conf
    echo -e "\n[Autologin]\nUser=$(whoami)\nSession=plasma" | sudo tee -a /etc/sddm.conf >/dev/null
else
    echo "ERROR: SDDM not active after configuration"
    exit 1
fi

sudo addlock openbox
sudo zypper in -y -n procs
cp -rf ~/Downloads/inst/files/* ~/.config/ && sudo mkdir -p /root/.config && sudo cp -rf ~/Downloads/inst/files/* /root/.config/ && chmod +x ~/Downloads/inst/scripts/* && mkdir -p ~/.local/bin/ && mv ~/Downloads/inst/scripts/* ~/.local/bin/ && mkdir ~/.othercrap && mv ~/Downloads/inst/script/wallpaper ~/Pictures/ && unzip -o ~/Downloads/inst/script/1.zip -d ~/.othercrap > /dev/null && chmod +x ~/.config/hypr/scripts/* && chmod +x ~/.config/i3/scripts/* && chmod +x ~/.config/sway/scripts/*
sudo zypper ref && sudo zypper dup -y && cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config/ && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo zypper install -y -n btop torbrowser-launcher mediainfo trash-cli urlview htop feh jq lsof google-noto-coloremoji-fonts ImageMagick symbols-only-nerd-fonts fetchmsttfonts meslo-lg-fonts vlc powerline-fonts starship kitty flatpak tealdeer bat zoxide fzf gdu eza ripgrep && flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak remote-delete --system flathub

# Prompt for swapfile size
read -p "Size of Swapfile in GB (just the number): " swap_size

# Validate input
if ! [[ "$swap_size" =~ ^[0-9]+$ ]]; then
  echo "Error: Please enter a valid number"
  exit 1
fi

# Calculate size in megabytes (for dd)
swap_mb=$((swap_size * 1024))

# Create swapfile with validation
sudo btrfs subvol create /Swap || exit 1
sudo chattr +C /Swap
sudo swapoff -a

echo "Creating ${swap_size}GB swapfile (this may take a while)..."
sudo truncate -s 0 /Swap/swapfile
sudo dd if=/dev/zero of=/Swap/swapfile bs=1M count=$swap_mb status=progress conv=fsync

# Configure swap
sudo chmod 600 /Swap/swapfile
sudo mkswap /Swap/swapfile
sudo swapon /Swap/swapfile

# Add to fstab
echo "/Swap/swapfile none swap defaults,nodatacow,discard,noatime 0 0" | sudo tee -a /etc/fstab

echo "Swapfile created successfully!"
echo "New swap configuration:"
sudo swapon --show

# Check for NVIDIA GPU and offer driver installation
if ! command -v lspci &>/dev/null; then
    sudo zypper install -y -n pciutils
fi
if lspci | grep -i NVIDIA >/dev/null; then
    echo "NVIDIA GPU detected!"
    read -p "Do you want to install NVIDIA drivers? [Y/n] " -r
    echo
    
    answer=${REPLY:-Y}
    answer=${answer,,} 

    if [[ $answer == "y" ]]; then
        echo "Installing NVIDIA drivers..."
        if ! sudo zypper install -y -n openSUSE-repos-Tumbleweed-NVIDIA; then
            echo "Error: Failed to install NVIDIA packages!" >&2
            exit 1
        fi
        echo "NVIDIA drivers installed successfully!"
    else
        echo "Skipping NVIDIA driver installation..."
    fi
fi

# Check for KDE Plasma and customize accordingly
if [ -f /usr/bin/plasmashell ]; then
    echo "KDE Plasma detected! Applying KDE customizations..."
    
    sudo zypper remove -y discover6 kwalletmanager
    sudo zypper addlock kwalletmanager patterns-games-games patterns-kde-kde_games patterns-kde-kde_pim discover6 akonadi
    sudo zypper install -y -n yakuake oxygen6-cursors yast2-theme-oxygen 
    rm -rf "${required_dir}/files/gtk-3.0"    
    git clone https://github.com/yeyushengfan258/Win11OS-kde
    sudo bash "${required_dir}/Win11OS-kde/install.sh"
    
    echo "KDE customization completed!"
else
    echo "Non-KDE environment detected. Applying basic customizations..."
    
    sudo zypper remove -y pragha parole && sudo zypper addlock parole pragha
    sudo zypper remove -y -n icewm && sudo zypper addlock icewm
    sudo zypper install -y -n bc polkit-gnome htop NetworkManager-applet ffmpegthumbnailer xprop i3 nitrogen thunar polybar python313-i3ipc i3lock pamixer pavucontrol dunst mousepad wmctrl && chmod +x ~/.config/polybar/launch.sh && chmod +x ~/Downloads/inst/script/autotiling && mv ~/Downloads/inst/script/autotiling ~/.local/bin/
    sudo zypper install -y -n rofi rofi-calc qalculate flameshot numlockx fbreader mpv-mpris gvfs-backend-afc gvfs-backends gvfs-fuse lxappearance
    mkdir -p ~/.themes && tar -xvf ~/Downloads/inst/script/Material-Black-Blueberry-2.9.9-07.tar -C ~/.themes > /dev/null && mkdir -p ~/.icons && unzip ~/Downloads/inst/script/Material-Black-Blueberry-Numix_1.9.3.zip -d ~/.icons > /dev/null && gtk-update-icon-cache -f -t "/home/$(whoami)/.icons/Material-Black-Blueberry-Numix/" && wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
    
    echo "Desktop Specific customization completed!"
fi

touch ~/.bash_profile && grep -qF '[[ -f ~/.bashrc ]] && . ~/.bashrc' ~/.bash_profile || echo -e '\n# Source .bashrc\n[[ -f ~/.bashrc ]] && . ~/.bashrc' >> ~/.bash_profile; grep -qF '[[ -f ~/.profile ]] && . ~/.profile' ~/.bash_profile || echo -e '\n# Source .profile\n[[ -f ~/.profile ]] && . ~/.profile' >> ~/.bash_profile; grep -qF 'export EDITOR=nvim' ~/.bash_profile || echo -e '\n# Core Exports\nexport EDITOR=nvim\nexport VISUAL=nvim\nexport PATH="$HOME/.local/bin:$PATH"\nexport TERMINAL="kitty"\nexport DIFFPROG="nvim -d"' >> ~/.bash_profile
sudo touch /root/.bash_profile && sudo bash -c 'grep -qF "[[ -f ~/.bashrc ]] && . ~/.bashrc" /root/.bash_profile || echo -e "\n# Source .bashrc\n[[ -f ~/.bashrc ]] && . ~/.bashrc" >> /root/.bash_profile; grep -qF "[[ -f ~/.profile ]] && . ~/.profile" /root/.bash_profile || echo -e "\n# Source .profile\n[[ -f ~/.profile ]] && . ~/.profile" >> /root/.bash_profile; grep -qF "export EDITOR=nvim" /root/.bash_profile || echo -e "\n# Core Exports\nexport EDITOR=nvim\nexport VISUAL=nvim\nexport PATH=\"\$HOME/.local/bin:\$PATH\"\nexport TERMINAL=\"kitty\"\nexport DIFFPROG=\"nvim -d\"" >> /root/.bash_profile'
#sed -i '/GPU_ENV_SET/d; /LIBVA_DRIVER_NAME/d' ~/.profile && echo -e '\n# GPU detection\nif command -v lspci >/dev/null; then\n  if lspci | grep -iq "nvidia"; then\n    export LIBVA_DRIVER_NAME=nvidia\n    export VDPAU_DRIVER=nvidia\n    export __GLX_VENDOR_LIBRARY_NAME=nvidia\n  elif lspci | grep -iq "amd\\|radeon"; then\n    export LIBVA_DRIVER_NAME=radeonsi\n    export VDPAU_DRIVER=radeonsi\n    unset __GLX_VENDOR_LIBRARY_NAME\n  fi\n  export GPU_ENV_SET=1\nfi' >> ~/.profile
sudo sed -i 's/^\s*#\?\s*download\.max_concurrent_connections\s*=\s*[0-9]\+/download.max_concurrent_connections = 15/' /etc/zypp/zypp.conf && sudo hostnamectl set-hostname "$(whoami)"
unzip ~/Downloads/inst/script/FiraMono.zip -d ~/Downloads/inst/script/ > /dev/null 2>&1 && rm -f ~/Downloads/inst/script/README.md ~/Downloads/inst/script/LICENSE 2> /dev/null && sudo mkdir -p /usr/share/fonts/opentype && sudo mv ~/Downloads/inst/script/*.otf /usr/share/fonts/opentype/ && sudo fc-cache -f -v
sudo zypper --gpg-auto-import-keys ar -cfp 90 -n VLC http://download.videolan.org/pub/vlc/SuSE/Tumbleweed/ vlc && sudo zypper --gpg-auto-import-keys ref && sudo zypper in -y -n --allow-vendor-change vlc-codecs && mkdir -p ~/.local/share/vlc/lua/extensions/ && mv ~/Downloads/inst/script/*.lua ~/.local/share/vlc/lua/extensions/ && mkdir -p ~/.local/share/vlc/lua/playlist/ && mv ~/Downloads/inst/script/1/*.lua ~/.local/share/vlc/lua/playlist/
sudo systemctl stop packagekit.service && sudo zypper remove -y PackageKit && sudo zypper addlock PackageKit
sudo zypper install -y -n inotify-tools brightnessctl
#----Swap-------
sudo zypper install -y -n systemd-zram-service && sudo systemctl enable --now zramswap.service
#sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=z3fold zswap.max_pool_percent=25 zswap.accept_threshold_percent=90"/' /etc/default/grub && sudo grub2-mkconfig -o /boot/grub2/grub.cfg
#sudo btrfs subvol create /Swap && sudo chattr +C /Swap && sudo swapoff -a && sudo truncate -s 0 /Swap/swapfile && sudo dd if=/dev/zero of=/Swap/swapfile bs=1M count=6144 status=progress conv=fsync && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap defaults,nodatacow,discard,noatime 0 0' | sudo tee -a /etc/fstab
#-----------------------------------------------------
sudo zypper install -y -n libreoffice-writer libreoffice-writer-extensions cmatrix cava yazi gimp dragon-drop exiftool gnome-boxes shotcut hexchat npm22
sudo zypper install -y -n audacious yt-dlp cmus cmus-plugins-all mpv mpg123 mkvtoolnix-tools mkvtoolnix-gui steam lutris flac
sudo zypper install -y -n gsmartcontrol w3m ddgr xdotool firewall-config podman distrobox bluez blueman rsync w3m-inline-image
sudo zypper install -y -n dxvk hardinfo opi feh fastfetch nmap fakeroot bind wine-gecko catfish wine-mono winetricks proxychains-ng tor neovim gnome-system-monitor
sudo zypper install -y -n xkill gamemode zip unrar gparted filezilla qbittorrent putty aria2 fuseiso android-tools q4wine mediainfo-gui
sudo zypper install -y -n x gnome-calculator xfburn
sudo zypper install -y -n xinput
#sudo zypper in piper && sudo systemctl enable ratbagd.service && sudo systemctl restart ratbagd.service && sudo usermod -aG games "$(whoami)"
#------------------------------------------------------------------
flatpak install --noninteractive flathub app.drey.Warp && flatpak install --noninteractive flathub com.github.xournalpp.xournalpp && flatpak install --noninteractive flathub com.heroicgameslauncher.hgl && flatpak install --noninteractive flathub io.gitlab.librewolf-community && flatpak install --noninteractive flathub io.github.giantpinkrobots.varia && flatpak install --noninteractive flathub com.github.tchx84.Flatseal
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub fr.handbrake.ghb && flatpak install --noninteractive flathub net.davidotek.pupgui2
flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub app.zen_browser.zen
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep linux_amd64.rpm | cut -d\" -f4) && sudo zypper --no-gpg-checks install -y -n ~/Downloads/inst/autobrr*.rpm
mkdir -p ~/.othercrap && wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | jq -r '.assets[] | select(.name | test("ani-cli")) | .browser_download_url') -O ani-cli && chmod +x ani-cli && mv ani-cli ~/.local/bin/ && rm ani-cli*
curl -sL https://www.rarlab.com/rar/rarlinux-x64-$(curl -sL https://www.rarlab.com/download.htm | grep -oP 'rarlinux-x64-\K[0-9]+\.tar\.gz' | head -n1) -o rarlinux.tar.gz && tar -xzf rarlinux.tar.gz && mv rar/rar ~/.local/bin/ && rm -rf rar rarlinux.tar.gz
curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o ~/.local/bin/yt-x && chmod +x ~/.local/bin/yt-x
wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | jq -r '.assets[] | select(.name | test("linux.tar.gz")) | .browser_download_url') -O ~/Downloads/ventoy.tar.gz && mkdir -p ~/.othercrap && tar -xzf ~/Downloads/ventoy.tar.gz -C ~/.othercrap/ && ventoy_folder=$(find ~/.othercrap -maxdepth 1 -type d -name "ventoy-*") && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Ventoy\nExec=$ventoy_folder/VentoyGUI.x86_64\nIcon=$ventoy_folder/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/Ventoy.desktop && chmod +x ~/.local/share/applications/Ventoy.desktop
wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rkhunter--------------------------
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo zypper addlock qbittorrent && flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications:create
sudo setsebool -P selinuxuser_execmod 1 && sudo setsebool -P selinuxuser_execheap 1 && sudo setsebool -P selinuxuser_execstack 1
#-----------------
sudo firewall-cmd --permanent --new-zone=howling && sudo firewall-cmd --permanent --zone=howling --add-source=192.168.0.0/24 && sudo firewall-cmd --permanent --zone=howling --set-target=ACCEPT && sudo firewall-cmd --permanent --zone=public --add-port=23232/tcp && sudo firewall-cmd --permanent --zone=public --add-port=23232/udp && sudo firewall-cmd --permanent --zone=public --set-target=DROP && sudo firewall-cmd --set-default-zone=public && sudo firewall-cmd --reload
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/ && sudo usermod -aG gamemode,wheel,adbusers,libvirt "$(whoami)"
wget $(curl -s https://api.github.com/repos/UniqProject/BDInfo/releases/latest | grep download | grep .zip  | cut -d\" -f4) && mv BDInfo_*.zip ~/.othercrap
wget $(curl -s https://api.github.com/repos/sc0ty/subsync/releases/latest | grep download | grep portable-amd64.exe   | cut -d\" -f4) && mv subsync-*-portable-amd64.exe ~/.othercrap
wget $(curl -s https://api.github.com/repos/noDRM/DeDRM_tools/releases/latest | grep download | grep .zip   | cut -d\" -f4) && mv DeDRM_tools_*.zip ~/.othercrap
wget --trust-server-names --content-disposition "https://www.highrez.co.uk/scripts/download.asp?package=XMousePortable" && mv XMouseButtonControl*Portable.zip ~/.othercrap
# ---------------------------------
mkdir -p ~/.othercrap/eac3to && unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null && rm ~/Downloads/inst/script/*.zip && rm ~/Downloads/inst/script/*.tar && rm ~/Downloads/inst/script/*.rar
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/1.mp3 ~/.othercrap/
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
#defaults,ssd,noatime,compress=zstd:3,space_cache=v2 0 0
#snapshots = defaults,ssd,noatime,compress=no,space_cache=v2 0 0
#ext4 = defaults,noatime,barrier=1,data=ordered,errors=remount-ro,commit=60,nofail 0 2
#sudo zypper install -y -n xhost && xhost +local: or xhost +si:localuser:$USER
#sudo zypper install -y -n conky && cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#zypper in mirrorsorcerer && systemctl enable --now mirrorsorcerer  xfce4-i3-workspaces-plugin  (patterns-games-games patterns-kde-kde_pim sudo zypper dup --from vlc --allow-vendor-change -y) (about:profiles, open root profile folder,Clear start up cache" ) sestatus  and /etc/selinux/config , Exec=/usr/bin/xdg-su -c /sbin/yast2  system-config-printer
#mkdir -p ~/Media/container/arch && distrobox create -n arch -i quay.io/toolbx/arch-toolbox:latest --init --additional-packages "systemd" --home ~/Media/container/arch && distrobox enter arch
#sudo sed -i 's/^[[:space:]]*#\?[[:space:]]*solver\.onlyRequires[[:space:]]*=[[:space:]]*false/solver.onlyRequires = true/' /etc/zypp/zypp.conf
#browser: sudo semanage fcontext -a -t user_home_dir_t "/home/$(whoami)/Downloads(/.*)?" && sudo restorecon -Rv "/home/$(whoami)/Downloads"
#cd && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg --noconfirm -si && cd && rm -rf yay && sudo pacman -S autotiling git fzf eza bat starship zoxide neovim --noconfirm --needed && [ -f ~/.bash_profile ] || echo -e "if [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi" > ~/.bash_profile && cp /home/$(whoami)/.bash* ~/ && cp /home/$(whoami)/.config/starship.toml ~/.config/ && cp -r /home/$(whoami)/.config/nvim ~/.config/ && source ~/.bashrc
#yay -S --noconfirm bdinfo-git cli-visualizer-git  && mkdir -p ~/.config/vis/colors/ && echo -e "colors.override.terminal=false\ncolors.scheme=color\n\nvisualizer.spectrum.bar.width=1" > ~/.config/vis/config && echo -e "gradient=false\n4\n12\n6\n14\n2\n10\n11\n3\n5\n1\n13\n9\n7\n15\n0" > ~/.config/vis/colors/color
#distrobox-export -b /usr/bin/vis && distrobox-export -b bdinfo
#gamemode= sudo find /usr/ -name libgamemodeauto.so    steam=gamemoderun %command%
#sudo zypper ar -f https://download.nvidia.com/opensuse/tumbleweed/ nvidia
#wget $(curl -s https://api.github.com/repos/VirusTotal/vt-cli/releases/latest | grep download | grep  Linux64.zip | cut -d\" -f4) && unzip ./Linux64.zip -d ~/.local/bin/ && chmod +x ~/.local/bin/vt && printf 'apikey = "%s"\n' "f4936f6a4e48bb6046edd0339e759bd9e23834ba995e3e6fb53be6643f8aa61e" > ~/.vt.toml
#sudo zypper in --no-recommends xfce4-terminal xfce4-taskmanager mousepad polkit-gnome htop NetworkManager-applet ffmpegthumbnailer xorg-xprop
#sudo systemctl stop cups && sudo systemctl disable cups.service cups.socket cups.path
#sudo opi -n codecs
#sudo opi -n input-remapper && sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
