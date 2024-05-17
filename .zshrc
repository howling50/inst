# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
alias rkhunt='sudo rkhunter --update && sudo rkhunter --propupd && sudo rkhunter --check --sk'
alias punlock='sudo chmod +rw /var/lib/pacman/db.lck && sudo rm /var/lib/pacman/db.lck'
alias kernelupdate='sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias listbash='echo "slist, pacdel \$1, image \$1, plist \$1, freeram, nmapauto \$1, fastpacman, ex \$1, finds \$1, mnt, delall, myip, speedtest, listen, systemcheck, rkhunt, kernelupdate, punlock"'
alias systemcheck='sudo systemctl --failed && sudo journalctl -p 3 -xb'
alias torstart='sudo systemctl start tor.service'
alias torstop='sudo systemctl stop tor.service'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more='less'
alias listen='sudo lsof -i -P -n | grep LISTEN'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias myip='curl ifconfig.me'
alias delall='sudo pacman -Rs $(pacman -Qqtd)'
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | grep -E ^/dev/ | sort"
plist ()
{
ps aux | grep "$1"
}
finds ()
{
  find / -iname "$1" 2>/dev/null
}
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
alias grep='grep --color'
alias fastpacman='sudo pacman-mirrors --geoip'
alias ll='ls -l'
alias la='ls -lha'
alias rm='rm -I --preserve-root'
alias cp='cp -i'
alias mv='mv -i'
alias vimrc='nvim ~/.config/nvim/init.vim '
alias bashrc='nvim ~/.bashrc'
alias zshrc='nvim ~/.zshrc'
nmapauto ()
{
 sudo nmap -Pn -T4 -A -p- -sV "$1"
}
freeram ()
{
  sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches && sleep 2 && free -h'
}
alias neofetch='fastfetch --logo ~/.othercrap/N51R4iT.jpg'
alias fastfetch='fastfetch --logo ~/.othercrap/N51R4iT.jpg'
image ()                                                                                                                                               
{
  kitty icat --transfer-mode=file "$1"
}
pacdel ()
{
  sudo pacman -Rcns "$1"
}
alias slist='sudo btrfs subv list /'
