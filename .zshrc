# Path to your oh-my-zsh installation.
export ZSH=/home/drobune/.oh-my-zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

export SAVEHIST=200000
setopt hist_ignore_dups

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bgnotify themes)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export MANPATH="/usr/local/man:$MANPATH"
export ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

setxkbmap -option ctrl:nocaps

export VISUAL="nano"

export GOPATH=~/go

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# go path
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

export CLOUDSDK_PYTHON=python2

# The next line enables shell command completion for gcloud.
source '/home/drobune/google-cloud-sdk/completion.zsh.inc'

# -*- mode: shell-script -*-

echo -n "ssh-agent: "
if [ -e ~/.ssh-agent-info ]; then
    source ~/.ssh-agent-info
fi

ssh-add -l >&/dev/null
if [ $? = 2 ] ; then
    echo -n "ssh-agent: restart...."
    ssh-agent >~/.ssh-agent-info
    source ~/.ssh-agent-info
fi
if ssh-add -l >&/dev/null ; then
    echo "ssh-agent: Identity is already stored."
else
    ssh-add
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY
PATH="/usr/local/heroku/bin:$PATH"

preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
}
precmd () {
    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=6

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            # Beep or visual bell if the elapsed time (in seconds) is greater than threshold
            print -n '\a'
            # Send a notification
            notify-send 'Job finished' "The job \"$CMD_NAME\" has finished."
        fi
    fi
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi

    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter



function git_not_pushed()
{
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes)
    do
        if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo -n "NOT PUSHED"
  fi
  return 0
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} $(git_not_pushed) % %{$reset_color%}'

#ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"


function random_cowsay() {
    COWS="/usr/share/cows"
    NBRE_COWS=$(ls -1 $COWS | wc -l)
    COWS_RANDOM=$(expr $RANDOM % $NBRE_COWS + 1)
    COW_NAME=$(ls -1 $COWS | awk -F\. -v COWS_RANDOM_AWK=$COWS_RANDOM 'NR == COWS_RANDOM_AWK {print $1}')
    cowsay -f $COW_NAME "`fortune -s`"
}

if which fortune cowsay >/dev/null; then
    while :
    do
        random_cowsay 2>/dev/null && break
    done
fi && unset -f random_cowsay

alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

source /usr/share/nvm/init-nvm.sh

# The next line updates PATH for the Google Cloud SDK.
source '/home/drobune/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/home/drobune/google-cloud-sdk/completion.zsh.inc'

export K8S_VERSION=$(curl -sS https://storage.googleapis.com/kubernetes-release/release/stable.txt)

theme agnoster
