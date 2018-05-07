# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias ls='ls --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Custmoized
## Color predefination
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

if [[ $EUID -ne 0 ]]; then
    PS1="$Cyan[$Green\u$Cyan@$BBlue\h$Cyan][$White$Yellow\w$Cyan]$White\n%"
else
    PS1="$Cyan[$BRed\u$Cyan@$BRed\h$Cyan][$White$Yellow\w$Cyan]$White\n%"
fi
# PROMPT_COMMAND='es=$?; [[ $es -eq 0 ]] && unset error || error=$(echo -e "$Red $es $White")'
# PS1="${error}${PS1}"

# set PATH so it inlcudes user's private bin installed by python pip
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

## Environment
export VISUAL=vim
export EDITOR=vim
export PAGER=less
# export PAGER=vimpager
# alias less=$PAGER
# alias zless=$PAGER

alias '...'='../..'
alias '....'='../../..'
alias '.....'='../../../..'
alias '......'='../../../../..'
alias '.......'='../../../../../..'

## Modified commands 
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
#

## New commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep '        # require an argument
alias openports='ss --all --numeric --processs --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # require an argument
alias ..='cd ..'
#

## Privileged access
if [[ $EUID -ne 0 ]]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    # alias reboot='sudo systemctl reboot' # Not support in Debian 7
    # alias poweroff='sudo systemctl poweroff' # Not support in Debian 7
    # alias update='sudo pacman -Su'
    # alias netctl='sudo netctl' # Conflict with netcfg
fi

## ls
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | less'
#

## Safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file

# safer alternative w/ timeout, not stored in history
alias rm='timeout 3 rm -Iv'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias cls=' echo -ne "\033c"' # clear screen for real
#

## Make Bash error tollerant
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias cd..='cd ..'
#
# Set Tmux console to be 256 color
alias tmux='tmux -2'

## Bash find command of specific file type extension
alias findc='find ./ -maxdepth 5 -type f -name "*.c" | xargs grep '
alias findcpp='find ./ -maxdepth 5 -type f -name "*.cpp" | xargs grep '
alias findlua='find ./ -maxdepth 5 -type f -name "*.lua" | xargs grep '
alias findjava='find ./ -maxdepth 5 -type f -name "*.java" | xargs grep '
alias findrs='find ./ -maxdepth 5 -type f -name "*.rs" | xargs grep '

alias findpl='find ./ -maxdepth 5 -type f -name "*.pl" | xargs grep '
alias findpy='find ./ -maxdepth 5 -type f -name "*.py" | xargs grep '
alias findrb='find ./ -maxdepth 5 -type f -name "*.rb" | xargs grep '

alias findhtml='find ./ -maxdepth 5 -type f -name "*.html" | xargs grep '
alias findjs='find ./ -maxdepth 5 -type f -name "*.js" | xargs grep '
alias findcss='find ./ -maxdepth 5 -type f -name "*.css" | xargs grep '

alias findlsp='find ./ -maxdepth 5 -type f -name "*.lsp" | xargs grep '
alias findss='find ./ -maxdepth 5 -type f -name "*.ss" | xargs grep '
alias findsls='find ./ -maxdepth 5 -type f -name "*.sls" | xargs grep '
alias findrkt='find ./ -maxdepth 5 -type f -name "*.rkt" | xargs grep '
alias findhs='find ./ -maxdepth 5 -type f -name "*.hs" | xargs grep '

alias findmd='find ./ -maxdepth 5 -type f -name "*.md" | xargs grep '
alias findcfg='find ./ -maxdepth 5 -type f -name "*.cfg" | xargs grep '
alias findxml='find ./ -maxdepth 5 -type f -name "*.xml" | xargs grep '
alias findjson='find ./ -maxdepth 5 -type f -name "*.json" | xargs grep '
alias findall='find ./ -maxdepth 5 -type f | xargs grep '

alias efindc='find ./ -maxdepth 5 -type f -name "*.c" | xargs egrep '
alias efindcpp='find ./ -maxdepth 5 -type f -name "*.cpp" | xargs egrep '
alias efindlua='find ./ -maxdepth 5 -type f -name "*.lua" | xargs egrep '
alias efindjava='find ./ -maxdepth 5 -type f -name "*.java" | xargs egrep '
alias efindrs='find ./ -maxdepth 5 -type f -name "*.rs" | xargs egrep '

alias efindpl='find ./ -maxdepth 5 -type f -name "*.pl" | xargs egrep '
alias efindpy='find ./ -maxdepth 5 -type f -name "*.py" | xargs egrep '
alias efindrb='find ./ -maxdepth 5 -type f -name "*.rb" | xargs egrep '

alias efindhtml='find ./ -maxdepth 5 -type f -name "*.html" | xargs egrep '
alias efindjs='find ./ -maxdepth 5 -type f -name "*.js" | xargs egrep '
alias efindcss='find ./ -maxdepth 5 -type f -name "*.css" | xargs egrep '

alias efindlsp='find ./ -maxdepth 5 -type f -name "*.lsp" | xargs egrep '
alias efindss='find ./ -maxdepth 5 -type f -name "*.ss" | xargs egrep '
alias efindsls='find ./ -maxdepth 5 -type f -name "*.sls" | xargs egrep '
alias efindrkt='find ./ -maxdepth 5 -type f -name "*.rkt" | xargs egrep '
alias efindhs='find ./ -maxdepth 5 -type f -name "*.hs" | xargs egrep '

alias efindmd='find ./ -maxdepth 5 -type f -name "*.md" | xargs egrep '
alias efindcfg='find ./ -maxdepth 5 -type f -name "*.cfg" | xargs egrep '
alias efindxml='find ./ -maxdepth 5 -type f -name "*.xml" | xargs egrep '
alias efindjson='find ./ -maxdepth 5 -type f -name "*.json" | xargs egrep '
alias efindall='find ./ -maxdepth 5 -type f | xargs egrep '

## Debian aptitude aliases
# alias finddpkg='dpkg -l | grep '
# alias findaptc='apt-cache search '

## Pacman aliases
# if necessary, replace 'pacman' with your favorite AUR helper and adapt the
# commands accordingly
# alias pac="sudo /usr/bin/pacman -S"     # default action    - install one or more packages
# alias pacu="/usr/bin/pacman -Syu"       # '[u]pdate'        - upgrade all packages to their newest version
# alias pacr="sudo /usr/bin/pacman -Rs"       # '[r]emove'        - uninstall one or more packages
# alias pacs="/usr/bin/pacman -Ss"        # '[s]earch'        - search for a package using one or more keywords
# alias paci="/usr/bin/pacman -Si"        # '[i]nfo'      - show information about a package
# alias paclo="/usr/bin/pacman -Qdt"      # '[l]ist [o]rphans'    - list all packages which are orphaned
# alias pacc="sudo /usr/bin/pacman -Scc"      # '[c]lean cache'   - delete all not currently installed package files
# alias paclf="/usr/bin/pacman -Ql"       # '[l]ist [f]iles'  - list all files installed by a given package
# alias pacexpl="/usr/bin/pacman -D --asexp"  # 'mark as [expl]icit'  - mark one or more packages as explicitly installed 
# alias pacimpl="/usr/bin/pacman -D --asdep"  # 'mark as [impl]icit'  - mark one or more packages as non explicitly installed

# Node Version Manager for Node.js application
#export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/dist

#alias cnpm="npm --registry=https://registry.npm.taobao.org \
#    --cache=$HOME/.npm/.cache/cnpm \
#    --disturl=https://npm.taobao.org/dist \
#    --userconfig=$HOME/.cnpmrc"

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Add User Language PATH
#export PATH="/path/to/language/bin:$PATH"

## Add User Cache PATH
#export PATH="/path/to/cache/bin:$PATH"

## Add User Database PATH
#export PATH="/path/to/database/bin:$PATH"

## Add User Message Queue PATH
#export PATH="/path/to/message-queue/bin:$PATH"

## Add User Anaconda PATH
#export PATH="/path/to/anaconda3/bin:$PATH"

# Every Day Hints for Shell Commands
# echo "Did you know that:"; whatis $(ls /bin | shuf -n 1) # whatis/makewhatis needed
# For Host with Cowsay Installed
# cowsay -f $(ls /usr/share/cowsay/cows | shuf -n 1 | cut -d. -f1) $(whatis $(ls /bin) 2>/dev/null | shuf -n 1)
