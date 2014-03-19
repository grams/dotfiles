########################################################################
# General purpose aliases
#


## get rid of command not found
alias cd..='cd ..'
 
## a quick way to get out of current directory
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'

## cdl -> perform 'ls' after 'cd' if successful.
cdl() {
  builtin cd "$*"
  RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    ls --color=auto -alF
  fi
}

## g <file> -> geany <file> &
g() {
  (geany "$*" &)
}

## History
alias h='history'

## Defaut args
alias df='df -H'
alias du='du -ch'

## GIT
alias gprune='git remote prune origin'
alias gshow='git remote show origin'

########################################################################
# Sudo
#

alias svi='sudo vi'
alias apt="sudo apt-get"
alias su='sudo -i'
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

########################################################################
# Function keys to GIT
# even faster than aliases !
#

# F6 -> ~/
bind '"\e[17~":" ~/"'

# F7 -> cd ..
bind '"\e[18~":"cd ..\n"'

# F8 -> git status
bind '"\e[19~":"git status\n"'

# F9 -> git branch
bind '"\e[20~":"git branch\n"'
