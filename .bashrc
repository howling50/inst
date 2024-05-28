#
# ~/.bashrc
#
iatest=$(expr index "$-" i)
[[ $- != *i* ]] && return
###################################################
#if [ -f /usr/bin/fastfetch ]; then
#	fastfetch
#fi
# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi
# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac
use_color=true
# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true
if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi
	#alias ls='ls -aFh --color=always'
	alias grep='grep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi
unset use_color safe_term match_lhs sh
bind '"\e[A": history-search-backward'
bind '"\eOA": history-search-backward'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
xhost +local:root > /dev/null 2>&1
# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s cdspell
# export QT_SELECT=4
# Enable history appending instead of overwriting.  #139609
shopt -s histappend
PROMPT_COMMAND='history -a'
export EDITOR=nvim
export VISUAL=nvim
# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=3000
# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace
# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:*.exe=01;33:'
# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Alias
alias freshclam='sudo freshclam'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias cd..='cd ..'
alias bd='cd "$OLDPWD"'
alias cls='clear'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias rkhunt='sudo rkhunter --update && sudo rkhunter --propupd && sudo rkhunter --check --sk'
kernelupdate () {
    if command -v pacman &> /dev/null; then
        echo "Updating GRUB for Arch Linux..."
        sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg
    elif command -v zypper &> /dev/null; then
        echo "Updating GRUB for openSUSE..."
        sudo mkinitcpio -P && sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo "Neither Arch Linux nor openSUSE found. GRUB update aborted."
    fi
}
alias listapp='echo "yt-dlp, autobrr, nmap, checkupdates, proxychains, 1, 2, aria2c, fuseiso, bdinfo, ncdu, fzf, ftext, cpp, ver, distro, thefuck, distrobox, ani-cli"'
alias systemcheck='sudo systemctl --failed && sudo journalctl -p 3 -xb'
alias torstart='sudo systemctl start tor.service'
alias torstop='sudo systemctl stop tor.service'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more='less'
alias cat='bat'
alias listen='sudo lsof -i -P -n | grep LISTEN'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias myip='curl ifconfig.me'
delall () {
    if command -v pacman &> /dev/null; then
        echo "Running cleanup for pacman..."
        sudo pacman -Rs $(pacman -Qqtd)
    elif command -v zypper &> /dev/null; then
        echo "Running cleanup for zypper..."
        sudo zypper cc -a
    else
        echo "Neither pacman nor zypper found. Cleanup aborted."
    fi
}
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | grep -E ^/dev/ | sort"
finds ()
{
  find / -iname "$1" 2>/dev/null
}
punlock() {
    if command -v pacman &> /dev/null; then
        echo "Unlocking pacman..."
        sudo chmod +rw /var/lib/pacman/db.lck && sudo rm /var/lib/pacman/db.lck
    elif command -v zypper &> /dev/null; then
        echo "Unlocking zypper..."
        sudo chmod +rw /var/run/zypp.pid && sudo rm /var/run/zypp.pid
    else
        echo "Neither pacman nor zypper found. Nothing to unlock."
    fi
}
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}
alias grep='grep --color'
alias rm='rm -I --preserve-root'
alias cp='cp -i'
alias mv='mv -i'
alias vim='nvim'
alias vimrc='nvim ~/.config/nvim/init.lua'
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
alias neofetch='fastfetch'
image ()                                                                                                                                               
{
  kitty icat --transfer-mode=file "$1"
}
depdel () {
if [ -z "$1" ]; then
        echo "Please provide a package name."
        return 1
    fi

    if command -v pacman &> /dev/null; then
        echo "Removing package with pacman..."
        sudo pacman -Rcns "$1"
    elif command -v zypper &> /dev/null; then
        echo "Removing package with zypper..."
        sudo zypper rm -u "$1"
    else
        echo "Neither pacman nor zypper found. Cannot remove package."
    fi
}
alias h="history | grep "
# Search running processes
alias plist="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
# Searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}
# Copy file with a progress bar
cpp() {
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}
# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
# Alias's for multiple directory listing commands
#alias la='ls -Alh'                # show hidden files
#alias lx='ls -lXBh'               # sort by extension
#alias lk='ls -lSrh'               # sort by size
#alias lc='ls -lcrh'               # sort by change time
#alias lu='ls -lurh'               # sort by access time
#alias lr='ls -lRh'                # recursive ls
#alias lt='ls -ltrh'               # sort by date
#alias lm='ls -alh |more'          # pipe through 'more'
#alias lw='ls -xAh'                # wide listing format
#alias ll='ls -Fls'                # long listing format
#alias labc='ls -lap'              #alphabetical sort
#alias lf="ls -l | egrep -v '^d'"  # files only
#alias ldir="ls -l | egrep '^d'"   # directories only
alias ls="eza --color=always  --icons=always --no-time --all"
alias ll="eza --color=always --long  --icons=always --no-time --all"
alias lk="eza --color=always --long  --icons=always --no-time --all --reverse --sort=size"
alias lx="eza --color=always --long  --icons=always --no-time --all --sort=extension"
alias lt="eza --color=always --long  --icons=always --all --reverse --sort=modified"
alias lf="eza --color=always --long  --icons=always --no-time -f"
alias ldir="eza --color=always --long  --icons=always --no-time -D"
sudo() {
  if [ "$1" = "rm" ]; then
    shift
    command sudo rm -I --preserve-root "$@"
  elif [ "$1" = "ls" ]; then
    shift
    command sudo eza --color=always --icons=always --no-time --all "$@"
  elif [ "$1" = "ll" ]; then
    shift
    command sudo eza --color=always --long  --icons=always --no-time --all "$@"
  elif [ "$1" = "vim" ]; then
    shift
    command sudo nvim "$@"
 elif [ "$1" = "cat" ]; then
    shift
    command sudo bat  "$@"
  else
    command sudo "$@"
  fi
}
# Show the current distribution
distro ()
{
	local dtype="unknown"  # Default to unknown
	# Use /etc/os-release for modern distro identification
	if [ -r /etc/os-release ]; then
		source /etc/os-release
		case $ID in
			fedora|rhel|centos)
				dtype="redhat"
				;;
			sles|opensuse*)
				dtype="suse"
				;;
			ubuntu|debian)
				dtype="debian"
				;;
			gentoo)
				dtype="gentoo"
				;;
			arch)
				dtype="arch"
				;;
			slackware)
				dtype="slackware"
				;;
			*)
				# If ID is not recognized, keep dtype as unknown
				;;
		esac
	fi
	echo $dtype
}
# Show the current version of the operating system
ver() {
	local dtype
	dtype=$(distro)
	case $dtype in
		"redhat")
			if [ -s /etc/redhat-release ]; then
				cat /etc/redhat-release
			else
				cat /etc/issue
			fi
			uname -a
			;;
		"suse")
			cat /usr/lib/os-release
			;;
		"debian")
			lsb_release -a
			;;
		"gentoo")
			cat /etc/gentoo-release
			;;
		"arch")
			cat /etc/os-release
			;;
		"slackware")
			cat /etc/slackware-version
			;;
		*)
			if [ -s /etc/issue ]; then
				cat /etc/issue
			else
				echo "Error: Unknown distribution"
				exit 1
			fi
			;;
	esac
}
# Alias's to show disk space and space used in a folder
alias diskspace="du -hS | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'

### EOF ###
# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
eval "$(fzf --bash)"
eval "$(zoxide init --cmd cd bash)"
eval $(thefuck --alias fuck)
eval $(thefuck --alias)
eval "$(starship init bash)"

# Check if aarchup is installed and run it if it is
if command -v aarchup &> /dev/null
then
    aarchup
fi
