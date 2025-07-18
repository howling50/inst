#!/usr/bin/env bash
##################### sudo chattr -R +C ~/Downloads then git clone in ~/Downloads, then chmod +x k.sh and then ./k.sh ####################################################
#sudo pacman -R timeshift-autosnap-manjaro --noconfirm && sudo pacman -R timeshift --noconfirm
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

# Check multilib status
if grep -q '^\[multilib\]' /etc/pacman.conf; then
    echo "Multilib is already enabled."
else
    if grep -q '^#\[multilib\]' /etc/pacman.conf; then
        echo "Enabling multilib repository..."
        
        # Backup original config
        backup_file="/etc/pacman.conf.$(date +%Y%m%d%H%M%S).bak"
        sudo cp /etc/pacman.conf "$backup_file"
        
        # Enable multilib
        sudo sed -i \
            -e 's/^#\[multilib\]$/\[multilib\]/' \
            -e '/^\[multilib\]$/{n;s/^#\(Include[[:space:]]*=[[:space:]]*\/etc\/pacman.d\/mirrorlist\)/\1/}' \
            /etc/pacman.conf
        sudo pacman -Syu --noconfirm

        echo "Multilib enabled successfully. Backup created at $backup_file"
    else
        echo "Error: No multilib section found in /etc/pacman.conf" >&2
        exit 1
    fi
fi

# Nvidia Install
if ! command -v lspci &>/dev/null; then
    echo "Installing pciutils for hardware detection..."
    sudo pacman -S --noconfirm pciutils || { echo "Failed to install pciutils!" >&2; exit 1; }
fi

# Detect NVIDIA GPU
if lspci | grep -iq "nvidia"; then
    echo "NVIDIA GPU detected!"
    read -p "Do you want to install NVIDIA drivers? [Y/n] " -r
    echo  # Add a new line after prompt

    answer=${REPLY:-Y}
    answer=${answer,,}  # Convert to lowercase

    if [[ $answer == "y" ]]; then
        echo "Installing NVIDIA drivers and configuration..."

        # Install packages
        if ! sudo pacman -S --needed --noconfirm \
            nvidia-dkms nvidia-utils nvidia-settings \
            libva-nvidia-driver lib32-nvidia-utils \
            lib32-opencl-nvidia opencl-nvidia \
            libvdpau libxnvctrl \
            vulkan-icd-loader lib32-vulkan-icd-loader; then
            echo "Error: Failed to install NVIDIA packages!" >&2
            exit 1
        fi

        # Add NVIDIA kernel parameter to GRUB
        if grep -q "^GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
            sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/"$/ nvidia-drm.modeset=1"/' /etc/default/grub
            echo "Updated GRUB kernel parameters for NVIDIA."
            
            # Regenerate GRUB config (only if GRUB is installed)
            if command -v grub-mkconfig &>/dev/null && [ -d /boot/grub ]; then
                echo "Regenerating GRUB configuration..."
                sudo grub-mkconfig -o /boot/grub/grub.cfg
            else
                echo "Warning: GRUB not detected. Update your bootloader config manually!"
            fi
        else
            echo "Error: GRUB_CMDLINE_LINUX_DEFAULT not found in /etc/default/grub!" >&2
            exit 1
        fi

        echo "NVIDIA drivers installed successfully! Reboot to apply changes."
    else
        echo "Skipping NVIDIA driver installation."
    fi
fi

# Prompt for swapfile size
read -p "Size of Swapfile in GB (just the number): " swap_size

# Validate input
if ! [[ "$swap_size" =~ ^[0-9]+$ ]]; then
  echo "Error: Please enter a valid number"
  exit 1
fi

# Get root filesystem type
fstype=$(findmnt -n -o FSTYPE /)

# Create swap directory based on filesystem
if [[ "$fstype" == "btrfs" ]]; then
  sudo btrfs subvol create /Swap || exit 1
  sudo chattr +C /Swap
else
  sudo mkdir -p /Swap || exit 1
fi

# Calculate size in megabytes (for dd)
swap_mb=$((swap_size * 1024))

# Create swapfile with validation
sudo swapoff -a

echo "Creating ${swap_size}GB swapfile (this may take a while)..."
sudo truncate -s 0 /Swap/swapfile
sudo dd if=/dev/zero of=/Swap/swapfile bs=1M count=$swap_mb status=progress conv=fsync

# Configure swap
sudo chmod 600 /Swap/swapfile
sudo mkswap /Swap/swapfile
sudo swapon /Swap/swapfile

# Add to fstab with appropriate options
if [[ "$fstype" == "btrfs" ]]; then
  echo "/Swap/swapfile none swap defaults,nodatacow,discard,noatime 0 0" | sudo tee -a /etc/fstab
else
  echo "/Swap/swapfile none swap defaults,discard,noatime 0 0" | sudo tee -a /etc/fstab
fi

echo "Swapfile created successfully!"
echo "New swap configuration:"
swapon --show

for dir in Media Downloads Music Videos Pictures; do [ ! -d "$HOME/$dir" ] && mkdir "$HOME/$dir"; done
sudo cp /etc/sudoers /etc/sudoers.tmp && sudo sed -i '/^# Defaults.*timestamp_timeout/s/^# //' /etc/sudoers.tmp && echo 'Defaults timestamp_timeout=60' | sudo tee -a /etc/sudoers.tmp > /dev/null && sudo cp /etc/sudoers.tmp /etc/sudoers && sudo rm -rf /etc/sudoers.tmp
sudo sh -c 'for option in "Color" "ILoveCandy" "VerbosePkgLists"; do grep -qx "$option" /etc/pacman.conf || sed -i "/\[options\]/a $option" /etc/pacman.conf; done' && sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
sudo pacman-mirrors --fasttrack 15 && sudo pacman -Syu --noconfirm --needed
sudo pacman -S yay --noconfirm --needed && yay -Y --sudoloop --save && yay -Syu --noconfirm
chmod +x ~/Downloads/inst/scripts/* && mkdir -p ~/.local/bin/ && mv ~/Downloads/inst/scripts/* ~/.local/bin/ && mkdir ~/.othercrap && chmod +x ~/.config/hypr/scripts/* && chmod +x ~/.config/i3/scripts/* && mv ~/Downloads/inst/script/wallpaper ~/Pictures/ && chmod +x ~/.config/sway/scripts/*
sudo pacman -S xorg-xkill inotify-tools btop wireplumber playerctl bash-completion trash-cli jq gnome-system-monitor file-roller eza zoxide fzf bat feh zip unzip --noconfirm --needed && cp -r ~/Downloads/inst/files/* ~/.config/ && sudo mkdir -p /root/.config && sudo cp -r ~/Downloads/inst/files/* /root/.config/ && unzip -o ~/Downloads/inst/script/1.zip -d ~/.othercrap > /dev/null

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

# Check if SDDM is enabled as the display manager
if systemctl is-enabled sddm &>/dev/null; then
    echo "SDDM detected - configuring Sequoia theme..."
    
    # Clone theme repository and prepare files
    sudo pacman -S --noconfirm --needed qt6-5compat qt6-declarative qt6-svg
    git clone https://codeberg.org/minMelody/sddm-sequoia.git ~/sequoia || { echo "Git clone failed"; exit 1; }
    rm -rf ~/sequoia/.git
    sudo mv ~/sequoia /usr/share/sddm/themes/ || { echo "Theme move failed"; exit 1; }

    # Configure theme settings
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent = sequoia" | sudo tee "/etc/sddm.conf.d/theme.conf.user" >/dev/null

    # Install custom wallpaper
    sudo cp -rf "$HOME/Pictures/wallpaper/monkey.png" "/usr/share/sddm/themes/sequoia/backgrounds/default" || { echo "Wallpaper copy failed"; exit 1; }
    
    # Update theme configuration
    sudo sed -i 's|^wallpaper=".*"|wallpaper="backgrounds/default"|' "/usr/share/sddm/themes/sequoia/theme.conf" 2>/dev/null

    # Configure autologin for current user
    # echo -e "[Autologin]\nUser=$(whoami)" | sudo tee "/etc/sddm.conf" >/dev/null

    echo "SDDM theme configuration completed successfully!"
else
    echo "SDDM not detected - skipping theme configuration."
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
    sudo pacman -S --noconfirm --needed i3-wm polybar python-i3ipc autotiling i3lock lxappearance wmctrl xorg-xprop xfburn
    sudo pacman -S --noconfirm --needed gnome-calculator man-db bc arandr viewnior rofi rofi-calc flameshot gvfs-mtp gvfs-afc mpv-mpris baobab numlockx tumbler thunar-archive-plugin file-roller fbreader ffmpegthumbnailer catfish pamixer dunst pavucontrol thunar-volman
    mkdir -p ~/.themes && tar -xvf ~/Downloads/inst/script/Material-Black-Blueberry-2.9.9-07.tar -C ~/.themes > /dev/null && mkdir -p ~/.icons && unzip -o ~/Downloads/inst/script/Material-Black-Blueberry-Numix_1.9.3.zip -d ~/.icons > /dev/null && gtk-update-icon-cache -f -t "/home/$(whoami)/.icons/Material-Black-Blueberry-Numix/" && wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.icons" sh
    sudo getent group autologin >/dev/null || sudo groupadd autologin
    sudo usermod -aG autologin "$(whoami)"
    
    echo "Desktop Specific customization completed!"
fi

SECONDS=0

sudo pacman -S fastfetch kitty powerline-fonts starship flatpak rsync ttf-firacode-nerd ttf-meslo-nerd ttf-roboto terminus-font noto-fonts-emoji ttf-nerd-fonts-symbols npm --noconfirm --needed
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config && sudo cp ~/Downloads/inst/starship.toml /root/.config/ && sudo rm -rf /root/.bashrc && sudo cp ~/Downloads/inst/.bashrc /root/.bashrc && sudo rm -rf ~/.bashrc && cp ~/Downloads/inst/.bashrc ~/.bashrc
#----Swap-------
sudo sh -c 'pacman -S zram-generator --noconfirm --needed && mkdir -p /etc/systemd/ && printf "[zram0]\nzram-size=ram/2\ncompression-algorithm=lz4\nswap-priority=100\n" > /etc/systemd/zram-generator.conf && systemctl daemon-reload && systemctl start systemd-zram-setup@zram0.service && systemctl enable systemd-zram-setup@zram0.service'
#sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 zswap.enabled=1 zswap.compressor=lz4 zswap.zpool=z3fold zswap.max_pool_percent=25 zswap.accept_threshold_percent=90"/' /etc/default/grub && sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo btrfs subvol create /Swap && sudo chattr +C /Swap && sudo swapoff -a && sudo truncate -s 0 /Swap/swapfile && sudo dd if=/dev/zero of=/Swap/swapfile bs=1M count=6144 status=progress conv=fsync && sudo chmod 600 /Swap/swapfile && sudo mkswap /Swap/swapfile && sudo swapon /Swap/swapfile && echo '/Swap/swapfile none swap defaults,nodatacow,discard,noatime 0 0' | sudo tee -a /etc/fstab
#-------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media && mkdir -p ~/.config/qBittorrent && mkdir -p ~/Media && mkdir -p ~/.wine && sudo mkdir -p /var/lib/flatpak && mkdir -p ~/.local/share/flatpak && sudo chattr -R +C ~/Media && sudo chattr -R +C ~/.wine
#-------------qemu---------------------------------
sudo pacman -S dnsmasq bridge-utils qemu-full virt-manager --noconfirm && sudo systemctl enable --now libvirtd && sudo usermod -a -G libvirt $(whoami) && sudo systemctl restart libvirtd && sudo virsh net-define /etc/libvirt/qemu/networks/default.xml && sudo virsh net-autostart default
#-----------------------------------------------------
sudo pacman -S procs warp magic-wormhole binutils nmap gcc patch fakeroot bind yazi ventoy gimp fbreader dragon-drop perl-image-exiftool shotcut hexchat gnome-boxes mediainfo-gui mediainfo handbrake torbrowser-launcher --noconfirm --needed
sudo pacman -S qbittorrent putty aria2 bluez bluez-utils blueman fuseiso android-tools mpv vlc libreoffice-fresh cava xournalpp --noconfirm --needed
sudo pacman -S ffmpeg libfdk-aac gst-plugins-base gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly --noconfirm --needed
sudo pacman -S wine wine-gecko wine-mono wine-nine winetricks --noconfirm --needed
sudo pacman -S catfish pacman-contrib gufw proxychains tor neovim pkgconf audacious lutris net-tools zip unzip lsof unrar gparted filezilla ffmpegthumbnailer --noconfirm --needed
sudo pacman -S flac yt-dlp mkvtoolnix-cli mkvtoolnix-gui steam gameconqueror --noconfirm --needed
sudo pacman -S cpu-x gamemode gsmartcontrol cmatrix w3m ddgr termusic xdotool podman distrobox e2fsprogs ripgrep memtest86+ tree gdu less mpg123 imagemagick tldr feh alsa-utils gptfdisk ntfs-3g os-prober python-pip --noconfirm --needed
#-----------------------------------------------------------------
yay -S --noconfirm dxvk-bin winegui-bin input-remapper-bin ttf-ms-fonts heroic-games-launcher-bin urlview autobrr-bin varia
flatpak install --noninteractive flathub com.github.tchx84.Flatseal && flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub io.gitlab.librewolf-community && flatpak install --noninteractive flathub app.zen_browser.zen
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub net.davidotek.pupgui2
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && mv ani-cli ~/.local/bin/
curl -sL "https://raw.githubusercontent.com/Benexl/yt-x/refs/heads/master/yt-x" -o ~/.local/bin/yt-x && chmod +x ~/.local/bin/yt-x && mkdir -p ~/.local/share/vlc/lua/extensions/ && mv ~/Downloads/inst/script/*.lua ~/.local/share/vlc/lua/extensions/ && mkdir -p ~/.local/share/vlc/lua/playlist/ && mv ~/Downloads/inst/script/1/*.lua ~/.local/share/vlc/lua/playlist/
mkdir -p ~/.othercrap && wget https://github.com/oguzhaninan/Stacer/releases/download/v1.1.0/Stacer-1.1.0-x64.AppImage && chmod +x Stacer-1.1.0-x64.AppImage && cp Stacer-1.1.0-x64.AppImage ~/.othercrap/ && mkdir -p ~/.local/share/applications/ && echo -e "[Desktop Entry]\nName=Stacer\nExec=$HOME/.othercrap/Stacer-1.1.0-x64.AppImage\nIcon=$HOME/.othercrap/Stacer/icon.png\nType=Application\nCategories=Utility;\nStartupNotify=true\nTerminal=false" > ~/.local/share/applications/stacer.desktop && chmod +x ~/.local/share/applications/stacer.desktop
#-----
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper && sudo systemctl start avahi-daemon && sudo systemctl enable avahi-daemon
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
#------------------------------------------rk hunter--------------------------
sudo cp ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq' && sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf && sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent kwalletmanager/' /etc/pacman.conf && sudo usermod -aG gamemode,wheel,adbusers "$(whoami)" && flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications:create
#-----------------
grep -qF '[[ -f ~/.bashrc ]] && . ~/.bashrc' ~/.bash_profile || echo -e '\n# Source .bashrc\n[[ -f ~/.bashrc ]] && . ~/.bashrc' >> ~/.bash_profile; grep -qF '[[ -f ~/.profile ]] && . ~/.profile' ~/.bash_profile || echo -e '\n# Source .profile\n[[ -f ~/.profile ]] && . ~/.profile' >> ~/.bash_profile; grep -qF 'export EDITOR=nvim' ~/.bash_profile || echo -e '\n# Core Exports\nexport EDITOR=nvim\nexport VISUAL=nvim\nexport PATH="$HOME/.local/bin:$PATH"\nexport TERMINAL="kitty"\nexport DIFFPROG="nvim -d"' >> ~/.bash_profile
sudo bash -c 'grep -qF "[[ -f ~/.bashrc ]] && . ~/.bashrc" /root/.bash_profile || echo -e "\n# Source .bashrc\n[[ -f ~/.bashrc ]] && . ~/.bashrc" >> /root/.bash_profile; grep -qF "[[ -f ~/.profile ]] && . ~/.profile" /root/.bash_profile || echo -e "\n# Source .profile\n[[ -f ~/.profile ]] && . ~/.profile" >> /root/.bash_profile; grep -qF "export EDITOR=nvim" /root/.bash_profile || echo -e "\n# Core Exports\nexport EDITOR=nvim\nexport VISUAL=nvim\nexport PATH=\"\$HOME/.local/bin:\$PATH\"\nexport TERMINAL=\"kitty\"\nexport DIFFPROG=\"nvim -d\"" >> /root/.bash_profile'
#touch ~/.profile && sed -i '/GPU_ENV_SET/d; /LIBVA_DRIVER_NAME/d' ~/.profile && echo -e '\n# GPU detection\nif command -v lspci >/dev/null; then\n  if lspci | grep -iq "nvidia"; then\n    export LIBVA_DRIVER_NAME=nvidia\n    export VDPAU_DRIVER=nvidia\n    export __GLX_VENDOR_LIBRARY_NAME=nvidia\n  elif lspci | grep -iq "amd\\|radeon"; then\n    export LIBVA_DRIVER_NAME=radeonsi\n    export VDPAU_DRIVER=radeonsi\n    unset __GLX_VENDOR_LIBRARY_NAME\n  fi\n  export GPU_ENV_SET=1\nfi' >> ~/.profile
#-----------------
sudo sed -i '$ a unqualified-search-registries=["registry.access.redhat.com", "registry.fedoraproject.org", "docker.io"]' /etc/containers/registries.conf
sudo systemctl enable fstrim.timer && sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/
wget $(curl -s https://api.github.com/repos/UniqProject/BDInfo/releases/latest | grep download | grep .zip  | cut -d\" -f4) && mv BDInfo_*.zip ~/.othercrap
wget $(curl -s https://api.github.com/repos/sc0ty/subsync/releases/latest | grep download | grep portable-amd64.exe   | cut -d\" -f4) && mv subsync-*-portable-amd64.exe ~/.othercrap
wget $(curl -s https://api.github.com/repos/noDRM/DeDRM_tools/releases/latest | grep download | grep .zip   | cut -d\" -f4) && mv DeDRM_tools_*.zip ~/.othercrap
wget --trust-server-names --content-disposition "https://www.highrez.co.uk/scripts/download.asp?package=XMousePortable" && mv XMouseButtonControl*Portable.zip ~/.othercrap
#---------------Firewall--------------
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow proto udp from 192.168.0.0/24 to any port 1:65535 && sudo ufw allow 23232/tcp && sudo ufw allow 23232/udp
sudo ufw default deny incoming && sleep 1 && sudo ufw default allow outgoing && sleep 1 && sudo systemctl enable ufw && sudo systemctl start ufw && sudo ufw enable
# ----------------------------------------------
mkdir -p ~/.othercrap/eac3to && unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null && rm ~/Downloads/inst/script/*.zip && rm ~/Downloads/inst/script/*.tar && rm ~/Downloads/inst/script/*.rar
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/1.mp3 ~/.othercrap/ && rm ~/Downloads/inst/script/autotiling
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i '/^Defaults timestamp_timeout=/s/.*/# Defaults timestamp_timeout=15/' /etc/sudoers
sudo mkdir -p /etc/pacman.d/hooks/ && printf '[Trigger]\nOperation = Upgrade\nType = Package\nTarget = *\n\n[Action]\nDescription = Checking system for unmerged .pacnew files...\nWhen = PostTransaction\nExec = /usr/bin/pacdiff --output\nDepends = pacman-contrib\n' | sudo tee /etc/pacman.d/hooks/pacdiff.hook >/dev/null  
sudo mkdir -p /etc/pacman.d/hooks/ && sudo printf '[Trigger]\nOperation = Upgrade\nType = Package\nTarget = *\n\n[Action]\nDescription = Cleaning pacman cache...\nWhen = PostTransaction\nDepends = pacman-contrib\nExec = /usr/bin/paccache -rk2\n' | sudo tee /etc/pacman.d/hooks/paccachepacman.hook >/dev/null
#sudo mkdir -p /etc/pacman.d/hooks/ && sudo printf '[Trigger]\nType = Package\nOperation = Install\nOperation = Upgrade\nTarget = intel-ucode\nTarget = amd-ucode\n\n[Action]\nDescription = Update GRUB after microcode updates\nWhen = PostTransaction\nDepends = grub\nExec = /usr/bin/grub-mkconfig -o /boot/grub/grub.cfg\n' | sudo tee /etc/pacman.d/hooks/95-microcode-grub.hook >/dev/null
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
#defaults,ssd,noatime,compress=zstd:1,space_cache=v2 0 0
#snapshots = defaults,ssd,noatime,compress=no,space_cache=v2 0 0
#ext4 = defaults,noatime,barrier=1,data=ordered,errors=remount-ro,commit=60,nofail 0 2
#sudo nano /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
#GRUB_DISABLE_SUBMENU=y
#sudo grub-mkconfig -o /boot/grub/grub.cfg
#sudo pacman -S gvfs-mtp gvfs-afc pamixer mpv-mpris dunst baobab numlockx pavucontrol tumbler polkit-gnome unzip htop jq xfce4-terminal xfce4-taskmanager imagemagick thunar thunar-volman thunar-archive-plugin gvfs lxappearance --needed
#/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm.conf or /etc/sddm.conf [Autologin] User=howling Session=i3          other: pika-backup
#git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git ~/Arch-Hyprland && cd ~/Arch-Hyprland && chmod +x install.sh && ./install.sh
#cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop && cp ~/Downloads/inst/.conkyrc ~/.conkyrc && conky -c ~/.conkyrc &
#yay -Y --sudoloop=false --save
