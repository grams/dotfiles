########################################################################
# General purpose aliases

## get rid of command not found
alias cd..='cd ..'
 
## a quick way to get out of current directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

## cl -> perform 'ls' after 'cd' if successful.
cl() {
  builtin cd "$*"
  RESULT=$?
  if [ "$RESULT" -eq 0 ]; then
    ls --color=auto -alF
  fi
}
complete -F _cd cl

## gn <file> -> geany <file> &
gn() {
  (geany "$*" &)
}

## gd <file> -> gedit <file> &
gd() {
  (gedit "$*" &)
}

## History
alias h='history'

## Defaut args
alias df='df -H'
alias du='du -ch'

########################################################################
# Git

alias gprune='git remote show | xargs git remote prune'
alias gshow='git remote show | xargs git remote -v show'
alias gfetch='git fetch --all --prune'
gupdate() {
    git fetch --all --prune
    LC_ALL=C git branch -vv  | grep '^[^[]*\[[^]]*: *gone\]' | awk '{print $1}' | grep -v -Fx '*' | xargs -r git branch -d
    git remote show | LC_ALL=C xargs -r -Ixxx /bin/bash -c "git remote show xxx | grep '(local out of date)' | awk '{print \$1}' | grep -v -Fx \$(git rev-parse --abbrev-ref HEAD) | xargs -r -I{} git fetch xxx {}:{}"
}
gupdateall() {
    for D in ` find . -maxdepth 1 -type d | sed -e 's/\.\///g'`
    do
        pushd "$D" > /dev/null
        if [ -d ".git" ]
        then
            /bin/echo -----\> $D
            gupdate
        fi
        popd > /dev/null
    done
}
alias gahead='git log @{u}..HEAD --oneline'
alias glog='git log --oneline --decorate'
gitrebaseallbranches() {
    git branch | sed -e s/\\*//g | xargs -I {} git config branch.{}.rebase true
}

########################################################################
# Docker

alias doruni='docker run -t -i -P'
dobash() {
  docker run --rm -t -i -P "$*" /bin/bash
}

doclean() {
    echo Zombie containers...
    CONTAINERS=$(docker ps -a | grep 'ago [ ]*Exited '  | awk '{print $1}')
    if [ -n "$CONTAINERS" ]; then
        docker rm  $CONTAINERS
    fi

    echo Unused images...
    IMAGES=$(docker images -a | grep "^<none>" | awk '{print $3}')
    if [ -n "$IMAGES" ]; then
        docker rmi  $IMAGES 2>&1 | grep -v "Error"
    fi
}

dostopall() {
    CONTAINERS=$(docker ps -q)
    if [ -n "$CONTAINERS" ]; then
        docker stop  $CONTAINERS
    fi
}

# Completions. These base completions should be installed :
# https://github.com/dotcloud/docker/blob/master/contrib/completion/bash/docker
complete -F __docker_image_repos_and_tags doruni
complete -F __docker_image_repos_and_tags dobash

########################################################################
# Sudo

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

# F6 -> ~/
bind '"\e[17~":" ~/"'

# F7 -> cd ..
bind '"\e[18~":"cd ..\n"'

# F8 -> git status
bind '"\e[19~":"git status\n"'

# F9 -> git branch
bind '"\e[20~":"git branch\n"'
