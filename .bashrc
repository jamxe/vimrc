[ -f ~/.bashenv ] && source ~/.bashenv

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -la'
alias l='ls -lt'
alias s='ls'
alias gs='git status'
alias ga='git add --all'
alias gad='git add'
alias gc='git commit -m'
alias gcm='git commit'
alias gca='git commit --amend'
alias gq='git pull'
alias gk='git reset'
alias gkh='git reset --hard'
alias gkha='git reset --hard HEAD^'
alias gp='git push'
alias gg='git switch'
alias ggo='git switch -c'
alias grs='git restore --staged'
alias grc='git rm --cached'
alias gr='git restore'
alias gd='git diff'
alias gdc='git diff --cached'
alias gda='git diff HEAD^'
alias gm='git merge'
alias gl='git log'
alias gll='git log --graph --oneline --decorate'
alias gcl='git clone'
alias gcl1='git clone --depth=1'
alias g='git'
alias p='python'
alias b='nvim'
alias sup='sudo pacman'

source /usr/share/git/completion/git-prompt.sh
#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

__exit_status() {
    x="$?"
    if [[ "x$x" != "x0" ]]; then
        printf "$1" "$x"
    fi
}
__afb1="$(tput bold)$(tput setaf 1)"
__afb4="$(tput bold)$(tput setaf 4)"
__af6="$(tput setaf 6)"
__af5="$(tput setaf 5)"
__af3="$(tput setaf 3)"
__af2="$(tput setaf 2)"
__rst="$(tput sgr0)"

__bash_root_pid="${BASHPID}"
__cmd_start() {
    date +%s.%N > "/dev/shm/${USER}.bashtime.${__bash_root_pid}"
}
__cmd_end() {
    file="/dev/shm/${USER}.bashtime.${__bash_root_pid}"
    if [[ -f "${file}" ]]; then
        endtime="$(date +%s.%N)"
        starttime="$(< "${file}")"
        rm "${file}"
        x="$(echo "m=$endtime-$starttime;s=2;if(m>=10)s=1;h=0.5;scale=s+1;t=1000;if(m<0)h=-0.5;a=m*t+h;scale=s;a=a/t;if(a>0.1)a;" | bc)"
        if [[ "$x" == .* ]]; then
            x="0$x"
        fi
        if [ "x$x" != "x" ]; then
            printf "$1" "$x"
        fi
    fi
}

__mem_usage() {
    echo "$[100 - $(awk '/MemFree/{print $2}' /proc/meminfo) * 100 / $(awk '/MemTotal/{print $2}' /proc/meminfo)]%"
}

export PS1='\[${__rst}\]$(__exit_status "\[${__afb1}\]%s\[${__rst}\] ")$(__cmd_end "\[${__af6}\]%ss\[${__rst}\] ")\[${__afb4}\]\W\[${__rst}\]$(__git_ps1 " \[${__af2}\](%s)\[${__rst}\]") \[${__af3}\]\$\[${__rst}\] '
export PS0='$(__cmd_start)\[${__rst}\]'

[ -f .bash_localrc ] && source .bash_localrc
