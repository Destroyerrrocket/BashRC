#TODO

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
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

gitify () {
      gitmas=`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`
}

function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    #dangerous line
    elif ((ms > 0)); then
	timer_show=${ms}.$((us / 100))ms
	if ((ms < 10)); then
		timer_show=0${ms}.$((us / 100))ms
	else
		timer_show=${ms}.$((us / 100))ms
	fi
    else timer_show=${us}us
    fi
    unset timer_start
}

set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Yellow='\[\e[01;33m\]'
    LightBlue='\[\e[01;36m\]'
    Orange='\[\e[0;33m\]'
    Purple='\[\e[1;35m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'
    title='\e]2;'
    titleend='\007\e]1;\007'
    cwd=$(pwd)
    columns=$(tput cols)
    shortpwd=$cwd
    # Add a bright white exit status for the last command
    PS1="$White\$?"
    PT1="$title"
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Checkmark "
        PT1+="$Checkmark "
    else
        PS1+="$Red$FancyX "
        PT1+="$FancyX "
    fi
    gitify
    PT1+="$gitmas "
    # Add the ellapsed time and current date
    timer_stop
    if ((columns > 84)); then
       PS1+="$LightBlue($timer_show)$Green \t "
    fi
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if ((columns > 58)); then
        if [[ $EUID == 0 ]]; then
            PS1+="$Red\\u$Green@\\h "
        elif id -nG "$USER" | grep -qw "sudo"; then
            PS1+="$Yellow\\u$Green@\\h "
        else
            PS1+="$Green\\u@\\h "
        fi
    fi
    PT1+="$USER@$HOSTNAME "
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    if ((columns > 84)); then
        PS1+="$Blue\\w "
        PS1+="$Purple$gitmas"
    fi
    PS1+="$Reset"
    PS1+="$ "
    PT1+="$shortpwd"
    PT1+="$titleend"
    printf "$PT1"
}
trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'


# >>> Added by cnchi installer
BROWSER=/usr/bin/firefox
EDITOR=/usr/bin/nano

#Custom functions
testTTY(){

  isTTY=$(tty | awk '{if ($0~/\/dev\/tty.*/) {print "true"}else{print "false"}}')

  if [ "$isTTY" = "true" ]; then
    printf "You are in virtual console\n"
    printf "current disk usage is"
    df
    printf "\n"
  else
    if [[ $EUID == 0 ]]; then
       printf "\nWe are in the roots of the system! >:D\n\n"
    else
       trizen -Syu --noconfirm
    fi
  fi
}
#Ubuntu's Alias
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
#Custom Alias
alias "actualizar"="trizen -Syu"
alias "Thalía"="yes Thalía | toilet -F border --gay"
alias "Nuria"="yes Nuria | toilet -F border"
alias "mountmame"="sudo mount -o loop /run/media/pol/MULTIVERS/MAMEROMS/MAME\ Complete\ Romset\ 0188u0/MAME\ 0188u0\ Complete\ Romset.iso /run/media/pol/MULTIVERS/MAMEROMS/roms/"
alias "testscript"="rm .test.sh; nano .test.sh; chmod +x .test.sh; ./.test.sh;"
alias "apaga"="shutdown 0"
alias "findf"="sudo find / 2>/dev/null | grep"
alias "list_AUR_packages"="trizen -Qme"
alias youtube-dl-mp3="youtube-dl --extract-audio --audio-format mp3 --output \"%(uploader)s-%(title)s.%(ext)s\""
alias "makepkg-.srcinfo"="makepkg --printsrcinfo > .SRCINFO"
alias ñs=ls
testTTY
