# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Launch tmux
#[[ -z "$TMUX" ]] && exec tmux
if [[ -z "$TMUX" ]] ;then
    ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        exec tmux -2 new-session 'neofetch --ascii_distro 'linux' --colors 3 7 3 3 3 7 --underline_char " "; bash' >/dev/null
        exit 0
    else
        # if available attach to it
        exec tmux attach-session -t "$ID" >/dev/null
    fi
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# exclude from history
alias exit=" exit"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# windows
alias web='cmd.exe /c start'
alias toast='powershell.exe -command New-BurntToastNotification'

# tmux/terminal shortcuts
alias new='urxvtc'
alias detach='tmux detach'
alias vsplit='tmux split-window -h && tmux selectp -t 1 && tmux split-window -v && tmux selectp -t 0'
alias hsplit='tmux split-window -v && tmux selectp -t 1 && tmux split-window -h && tmux selectp -t 0'
alias qsplit='tmux split-window -h && tmux selectp -t 0 && tmux split-window -v && tmux selectp -t 2 && tmux split-window -v && tmux selectp -t 0'

# git shortcuts
alias log='git log --graph --decorate --abbrev-commit'
alias pull='git pull --rebase --autostash'
alias push='git push'
alias rebase='git rebase --autostash'
alias status='git status'

add() {
    if [ -z "$1" ]; then
        git add .
    else
        git add $1
    fi
}

commit() {
    git commit -m "$1"
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='toast -Text "$([ $? = 0 ] && echo terminal || echo error)\n$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

#Aliases
alias vgup="vagrant up"
alias vgssh="vagrant ssh"
alias vghalt="vagrant halt"
alias vgrld="vagant reload"
alias vgkill="vagrant destroy --force"
alias vgsync="vagrant rsync-auto"
alias vgback="vagrant rsync-back"

mkcd () {
  mkdir "$1"
  cd "$1"
}

# @gf3s Sexy Bash Prompt, inspired by Extravagant Zsh Prompt
# Shamelessly copied from https://github.com/gf3/dotfiles
# Screenshot: http://i.imgur.com/s0Blh.png

#if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
#    export TERM=gnome-256color
#elif infocmp xterm-256color >/dev/null 2>&1; then
#    export TERM=xterm-256color
#fi

#if tput setaf 1 &> /dev/null; then
#    tput sgr0
#    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
#        MAGENTA=$(tput setaf 9)
#        ORANGE=$(tput setaf 172)
#        GREEN=$(tput setaf 190)
#        PURPLE=$(tput setaf 141)
#        WHITE=$(tput setaf 7)
#    else
#        MAGENTA=$(tput setaf 5)
#        ORANGE=$(tput setaf 4)
#        GREEN=$(tput setaf 2)
#        PURPLE=$(tput setaf 1)
#        WHITE=$(tput setaf 7)
#    fi
#    BOLD=$(tput bold)
#    RESET=$(tput sgr0)
#else
#    MAGENTA="\033[1;31m"
#    ORANGE="\033[1;33m"
#    GREEN="\033[1;32m"
#    PURPLE="\033[1;35m"
#    WHITE="\033[1;37m"
#    BOLD=""
#    RESET="\033[m"
#fi

#export MAGENTA
#export ORANGE
#export GREEN
#export PURPLE
#export WHITE
#export BOLD
#export RESET

function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]]
}

function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

#export PS1="\[$MAGENTA\]\u\[$WHITE\]@\[$ORANGE\]\h\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" | \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n${debian_chroot:+($debian_chroot)}\w\$ \[$RESET\]"
#export PS2="\[$ORANGE\] \[$RESET\]"
#export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \":\")\$(parse_git_branch)\$ "
#export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;35m\]\[\$(parse_git_branch)\[\033[00m\]\]\$ "
export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[33m\]<\$(parse_git_branch)>\[\033[01;34m\]\w\[\033[00m\]\$ "

export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/source"
export VAGRANT_WSL_DISABLE_VAGRANT_HOME="1"

# Setup X11
export DISPLAY=:0 
export RUNLEVEL=3
xset +fp "C:\program Files\VcXsrv\fonts\profont-x11" >/dev/null
xset fp rehash >/dev/null

# Setup PATH
PATH=$PATH:$HOME/bin

# Theme: Monokai - Wimer Hazenberg (http://www.monokai.nl)
color00="272822" # Base 00 - Black
color01="f92672" # Base 08 - Red
color02="a6e22e" # Base 0B - Green
color03="F5871F" # Base 0A - Yellow
color04="66d9ef" # Base 0D - Blue
color05="ae81ff" # Base 0E - Magenta
color06="a1efe4" # Base 0C - Cyan
color07="f8f8f2" # Base 05 - White
color08="75715e" # Base 03 - Bright Black
color09=$color01 # Base 08 - Bright Red
color10=$color02 # Base 0B - Bright Green
color11="FFC66D" # Base 0A - Bright Yellow
color12=$color04 # Base 0D - Bright Blue
color13=$color05 # Base 0E - Bright Magenta
color14=$color06 # Base 0C - Bright Cyan
color15="f9f8f5" # Base 07 - Bright White

# 16 color space
echo -e "\e]P0$color00" >/dev/null
echo -e "\e]P1$color01" >/dev/null
echo -e "\e]P2$color02" >/dev/null
echo -e "\e]P3$color03" >/dev/null
echo -e "\e]P4$color04" >/dev/null
echo -e "\e]P5$color05" >/dev/null
echo -e "\e]P6$color06" >/dev/null
echo -e "\e]P7$color07" >/dev/null
echo -e "\e]P8$color08" >/dev/null
echo -e "\e]P9$color09" >/dev/null
echo -e "\e]PA$color10" >/dev/null
echo -e "\e]PB$color11" >/dev/null
echo -e "\e]PC$color12" >/dev/null
echo -e "\e]PD$color13" >/dev/null
echo -e "\e]PE$color14" >/dev/null
echo -e "\e]PF$color15" >/dev/null

# clean up
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
