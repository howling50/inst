#!/usr/bin/env bash
##################### git clone in ~/Downloads, then chmod +x k.sh and then ./k.sh ####################################################
SECONDS=0
#sudo pacman -R timeshift --noconfirm
#sudo pacman -R timeshift-autosnap-manjaro --noconfirm
#curl -L https://nixos.org/nix/install | sh
#git clone https://github.com/yeyushengfan258/Win11OS-kde
sudo cp /etc/sudoers /etc/sudoers.tmp
sudo sed -i '/^# Defaults.*timestamp_timeout/s/^# //' /etc/sudoers.tmp
echo 'Defaults timestamp_timeout=60' | sudo tee -a /etc/sudoers.tmp > /dev/null
sudo cp /etc/sudoers.tmp /etc/sudoers
sudo rm -rf /etc/sudoers.tmp
#----Swap-------
sudo btrfs subvol create /Swap
sudo chattr -R +C /Swap
#sudo mkdir /Swap
sudo swapoff -a
sudo fallocate -l 6G /Swap/swapfile
sudo chmod 600 /Swap/swapfile
sudo mkswap /Swap/swapfile
sudo swapon /Swap/swapfile
echo '/Swap/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo swapon -a
#------------
sudo pacman -S caffeine-ng --noconfirm --needed
caffeine & 2>/dev/null
sudo mkdir -p /etc/crontab
sudo mkdir -p /etc/cron.minutely
sudo cp ~/Downloads/inst/mycronjobs /etc/cron.d/
chmod +x ~/Downloads/inst/scripts/*
sudo cp ~/Downloads/inst/scripts/1 /usr/local/bin
sudo cp ~/Downloads/inst/scripts/2 /usr/local/bin
sudo cp ~/Downloads/inst/scripts/timer /usr/local/bin
sudo cp ~/Downloads/inst/scripts/mp4decrypt /usr/local/bin
sudo cp ~/Downloads/inst/scripts/checkerror /usr/local/bin
#-------
sudo btrfs subvol create /Media && sudo chown $(whoami):$(whoami) /Media && sudo chmod 755 /Media && sudo chattr -R +C /Media
btrfs subvol create ~/Media
btrfs subvol create ~/.wine
btrfs subvol create ~/.config/qBittorrent
sudo chattr -R +C ~/Media
sudo chattr -R +C ~/.wine
sudo chattr -R +C ~/.config/qBittorrent
sudo mv ~/Downloads ~/Downloads.old
btrfs subvol create ~/Downloads
sudo mv ~/Downloads.old/* ~/Downloads/
sudo rmdir ~/Downloads.old
sudo chattr -R +C ~/Downloads
#--------
cd
cd ~/Downloads/inst/
#-----
#curl -O https://blackarch.org/strap.sh
#chmod +x strap.sh
#sudo ./strap.sh
#-------
sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
sudo pacman-mirrors --fasttrack 15 && sudo pacman -Syu --noconfirm --needed
sudo pacman -S powerline-fonts starship --noconfirm --needed
cp ~/Downloads/inst/starship.toml ~/.config/ && sudo mkdir -p /root/.config && sudo cp ~/Downloads/inst/starship.toml /root/.config/
sudo rm -rf /root/.bashrc
sudo cp ~/Downloads/inst/.bashrc /root/.bashrc
sudo rm -rf ~/.bashrc
cp ~/Downloads/inst/.bashrc ~/.bashrc
sudo pacman -S yay --noconfirm --needed
sudo systemctl stop cups
sudo systemctl disable cups.service cups.socket cups.path
balooctl disable
sudo rm -rf ~/./local/share/baloo
#-------------qemu---------------------------------
sudo pacman -S dnsmasq bridge-utils qemu-full virt-manager --noconfirm
sudo systemctl enable --now libvirtd
sudo usermod -a -G libvirt $(whoami)
sudo systemctl restart libvirtd
sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
sudo virsh net-autostart default
#-----------------------------------------------------
sudo pacman -Rns kwalletmanager --noconfirm
sudo pacman -R elisa --noconfirm
sudo pacman -R neofetch --noconfirm
sudo pacman -R thunderbird --noconfirm
sudo pacman -S binutils --noconfirm --needed
sudo pacman -S hiredis --noconfirm --needed
sudo pacman -S ccache --noconfirm --needed
sudo pacman -S nmap --noconfirm --needed
sudo pacman -S make --noconfirm --needed
sudo pacman -S autoconf --noconfirm --needed
sudo pacman -S flex --noconfirm --needed
sudo pacman -S less --noconfirm --needed
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
sudo pacman -S steam --noconfirm --needed
sudo pacman -S gufw --noconfirm --needed
sudo pacman -S proxychains --noconfirm --needed
sudo pacman -S tor --noconfirm --needed
sudo pacman -S neovim --noconfirm --needed
sudo pacman -S pkgconf --noconfirm --needed
sudo pacman -S kitty --noconfirm --needed
sudo pacman -S gamemode --noconfirm --needed
sudo pacman -S audacious --noconfirm --needed
sudo pacman -S lutris --noconfirm --needed
sudo pacman -S fastfetch --noconfirm --needed
sudo pacman -S net-tools --noconfirm --needed
sudo pacman -S zip --noconfirm --needed
sudo pacman -S unzip --noconfirm --needed
sudo pacman -S lsof --noconfirm --needed
sudo pacman -S unrar --noconfirm --needed
sudo pacman -S rkhunter --noconfirm --needed
sudo pacman -S unrar --noconfirm --needed
sudo pacman -S ffmpeg --noconfirm --needed
sudo pacman -S bat --noconfirm --needed
sudo pacman -S gparted --noconfirm --needed
sudo pacman -S mkvtoolnix-cli mkvtoolnix-gui --noconfirm --needed
sudo pacman -S celluloid --noconfirm --needed
#sudo pacman -S conky --noconfirm --needed
sudo pacman -S mediainfo --noconfirm --needed
sudo pacman -S flac --noconfirm --needed
#sudo pacman -S burpsuite --noconfirm --needed
sudo pacman -S ventoy --noconfirm --needed
sudo pacman -S downgrade --noconfirm --needed
sudo pacman -S filezilla --noconfirm --needed
sudo pacman -S aegisub --noconfirm --needed
sudo pacman -S virtualbox --noconfirm --needed
sudo pacman -S qbittorrent --noconfirm --needed
sudo pacman -S putty --noconfirm --needed 
sudo pacman -S kdialog --noconfirm --needed
sudo pacman -S aria2 --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed
sudo pacman -S bluez bluez-utils --noconfirm --needed
sudo pacman -S fuseiso --noconfirm --needed
sudo pacman -S android-tools --noconfirm --needed
sudo pacman -S tldr --noconfirm --needed
sudo pacman -S feh --noconfirm --needed
sudo pacman -S ytfzf w3m ddgr ttf-firacode-nerd cmus flatpak-kcm blueman podman distrobox e2fsprogs ripgrep zoxide fzf gdu tree eza thefuck --noconfirm --needed
#-----------------------------------------------------------------
yay --sudoloop --save
#yay -S --noconfirm virtualbox-ext-oracle
yay -S --noconfirm hardinfo2 cli-visualizer
yay -S --noconfirm dxvk-bin
yay -S --noconfirm input-remapper-git
yay -S --noconfirm ttf-meslo
yay -S --noconfirm bdinfo-git
yay -S --noconfirm ttf-ms-fonts
yay -S --noconfirm quickemu
yay -S --noconfirm sublime-text-4 
yay -S --noconfirm quickgui-bin
yay -S --noconfirm konsave
#flatpak install --noninteractive flathub com.github.tchx84.Flatseal
flatpak install --noninteractive flathub com.calibre_ebook.calibre && flatpak install --noninteractive flathub org.gimp.GIMP && flatpak install --noninteractive flathub com.github.Matoking.protontricks && flatpak install --noninteractive flathub io.gitlab.librewolf-community && flatpak install --noninteractive flathub net.pcsx2.PCSX2 && flatpak install --noninteractive flathub org.shotcut.Shotcut && flatpak install --noninteractive flathub io.github.Hexchat
flatpak install --noninteractive flathub io.github.dvlv.boxbuddyrs && flatpak install --noninteractive flathub com.usebottles.bottles && flatpak install --noninteractive flathub fr.handbrake.ghb && flatpak install --noninteractive flathub net.davidotek.pupgui2 && flatpak install --noninteractive flathub com.brave.Browser
wget $(curl -s https://api.github.com/repos/pystardust/ani-cli/releases/latest | grep download | grep ani-cli | cut -d\" -f4) && chmod +x ani-cli && sudo mv ani-cli /usr/local/bin
wget $(curl -s https://api.github.com/repos/autobrr/autobrr/releases/latest | grep download | grep amd64.pkg.tar.zst   | cut -d\" -f4)
sudo pacman -U autobrr*.tar.zst --noconfirm --needed
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
sudo systemctl enable input-remapper && sudo systemctl restart input-remapper
mkdir -p ~/.config/fastfetch && cp ~/Downloads/inst/config.jsonc ~/.config/fastfetch/ && sudo mkdir -p /root/.config/fastfetch && sudo cp ~/Downloads/inst/config.jsonc /root/.config/fastfetch/
#------------Remote -----------------------------------
#sudo pacman -S remmina --noconfirm --needed
#yay -S --noconfirm remmina-plugin-teamviewer
#yay -S --noconfirm remmina-plugin-ultravnc
#yay -S --noconfirm remmina-plugin-rdesktop
#yay -S --noconfirm remmina-plugin-url
#yay -S --noconfirm remmina-plugin-open
#yay -S --noconfirm remmina-plugin-folder
#------------------------------------------------------------------
sudo bash -c 'echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf'
mkdir -p ~/.config/vis/colors/ && echo -e "colors.override.terminal=false\ncolors.scheme=color\n\nvisualizer.spectrum.bar.width=1" > ~/.config/vis/config && echo -e "gradient=false\n4\n12\n6\n14\n2\n10\n11\n3\n5\n1\n13\n9\n7\n15\n0" > ~/.config/vis/colors/color
#------------------------------------------rk hunter--------------------------
sudo cp ~/Downloads/inst/rkhunter.conf.local  /etc/rkhunter.conf.local 
sudo bash -c 'echo  "PermitRootLogin no" >> /etc/ssh/sshd_config'
#-----------------------------------------------------------------------------------
sudo bash -c 'echo "244" > /proc/sys/kernel/sysrq'
sudo bash -c 'echo "kernel.sysrq = 244" >> /etc/sysctl.d/99-sysctl.conf'
sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
sudo sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
sudo sed -i 's/^#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/' /etc/systemd/system.conf
sudo sed -i 's/^#IgnorePkg   =/IgnorePkg = qbittorrent/' /etc/pacman.conf
sudo sed -i 's/^IgnorePkg =/IgnorePkg = qbittorrent/' /etc/pamac.conf
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
echo vm.swappiness=10 | sudo tee -a /etc/sysctl.d/100-manjaro.conf  >/dev/null
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
mkdir -p ~/.steam/root/compatibilitytools.d/
mkdir -p ~/.config/nvim/
cp ~/Downloads/inst/init.lua ~/.config/nvim/
curl -O https://i.imgur.com/N51R4iT.jpg
cp  ~/Downloads/inst/N51R4iT.jpg ~/.othercrap/
sudo mkdir -p /root/.config/nvim/
sudo cp ~/Downloads/inst/init.lua /root/.config/nvim/
cd ~/Downloads/inst/
wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux
mv yt-dlp_linux yt-dlp
chmod +x yt-dlp
sudo cp ~/Downloads/inst/yt-dlp /usr/local/bin
wget https://github.com/noDRM/DeDRM_tools/releases/download/v10.0.3/DeDRM_tools_10.0.3.zip
#---------------Firewall--------------
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 1:65535
sudo ufw allow proto udp from 192.168.0.0/24 to any port 1:65535
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
cd
cd ~/Downloads/inst/
sudo bash ~/Downloads/inst/Win11OS-kde/install.sh
lookandfeeltool -a com.github.yeyushengfan258.Win11OS-dark 2>/dev/null
sleep 2
# --------- Snapshots ------------------------
sudo systemctl enable grub-btrfsd.service
sudo systemctl start grub-btrfsd.service
# ----------------------------------------------
konsave -i ~/Downloads/inst/kde2.knsv
sleep 1
konsave -a kde2
#cp ~/Downloads/inst/conky.desktop ~/.config/autostart/conky.desktop
#cp ~/Downloads/inst/.conkyrc ~/.conkyrc
cp ~/Downloads/inst/1.mp3 ~/.othercrap/1.mp3
mkdir -p ~/.othercrap/dedrm
unzip ~/Downloads/inst/DeDRM_tools_10.0.3.zip -d ~/.othercrap/dedrm > /dev/null
mkdir -p ~/.othercrap/eac3to
unrar x ~/Downloads/inst/script/eac3to_3.44.rar ~/.othercrap/eac3to > /dev/null
mv ~/Downloads/inst/script/tampermonkey-* ~/.othercrap/
mv ~/Downloads/inst/script/*.exe ~/.othercrap/
mv ~/Downloads/inst/script/'XMouseButtonControl 2.20.5 Portable.zip' ~/.othercrap/
caffeine kill
sudo pacman -R caffeine-ng --noconfirm
convert ~/Downloads/inst/script/monkey.jpg ~/Downloads/inst/script/monkey.png
mv ~/Downloads/inst/script/monkey.png ~/.othercrap/monkey.png
#qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:var allDesktops = desktops();print (allDesktops);for (i=0;i<allDesktops.length;i++) {d = allDesktops[i];d.wallpaperPlugin = "org.kde.image";d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");d.writeConfig("Image", "file://'$HOME'/.othercrap/monkey.png");}'
#conky -c ~/.conkyrc &
sed -i 's/"sudoloop": true/"sudoloop": false/' ~/.config/yay/config.json
cd ..
cd ~/Downloads/inst/
sudo sed -i '$ a\set superusers="mastros"\npassword_pbkdf2 mastros grub.pbkdf2.sha512.10000.77DA16D22A3A8D15AA247F40FA13D6248A92B70D588CFBA14D0C61B15CB7BA37D7895693F643A4C84E5F0891AFB73CD83724D5B6B636A9722B94F726D4F5AAFA.B27F2FE6F14E583AFECAD4E5775498C1144639FB415F228F877EFACF8A1A3DA2BD5781238BD47BA00C4444C51A7F9D232E96F8C0A193E6FD8B64F2BC4E857A10' /etc/grub.d/40_custom
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=-1/' /etc/default/grub
sudo sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 usbcore.autosuspend=-1"/' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i '/^Defaults timestamp_timeout=/s/.*/# Defaults timestamp_timeout=15/' /etc/sudoers
mpg123 ~/.othercrap/1.mp3 > /dev/null 2>&1
#List Installed packages nix-env -q
#Install Packages nix-env -iA nixpkgs.packagename
#Erase Packages nix-env -e packagename
#Update All Packages nix-env -u
#Update Specific Packages nix-env -u packagename
#Hold Specific Package nix-env --set-flag keep true packagename
#List Backups (Generations) nix-env --list-generations
#Rollback to Last Backup nix-env --rollback
#Rollback to Specific Generation nix-env --switch-generation #
#Search  nix-env -qa [package name]
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
