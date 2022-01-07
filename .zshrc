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
alias torstart='sudo systemctl start tor.service'
alias torstop='sudo systemctl stop tor.service'
alias listen='sudo lsof -i -P -n | grep LISTEN'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias myip='curl ifconfig.me'
alias delall='sudo pacman -Rs $(pacman -Qqtd)'
alias pacign='sudo nvim /etc/pacman.conf'
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
guiedit ()
{
 sudo env SUDO_EDITOR="/usr/bin/mousepad" sudoedit "$1" 2>/dev/null &
}
alias pacman-update='sudo pacman-mirrors --geoip'
alias ll='ls -l'
alias la='ls -lha'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vimrc='nvim ~/.config/nvim/init.vim'
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
alias neofetch='neofetch --kitty --source ~/.config/neofetch/N51R4iT.jpg'
image ()                                                                                                                                               
{
  kitty icat --transfer-mode=file "$1"
}
pacdel ()
{
  sudo pacman -Rcns "$1"
}
alias slist='sudo btrfs subv list /'
