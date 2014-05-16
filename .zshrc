
autoload -U colors && colors
fpath=(~/Tools/tools/env/libs/zsh/prompts $fpath)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

alias e='export'
alias a='alias'
alias u='unset'
alias so='setopt'
alias uo='unsetopt'

alias sagi="sudo apt-get install"
alias update="sudo -s -- sh -c 'apt-get update && apt-get upgrade'"
alias sudos="sudo -s -- sh -c"

bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U is-at-least

if is-at-least 4.3.8; then
    # VCS info :
    autoload -Uz vcs_info
    # check-for-changes can be really slow.
    # you should disable it, if you work with large repositories
    zstyle ':vcs_info:*' enable git cvs svn hg
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' unstagedstr '%F{red}●'
    zstyle ':vcs_info:*' stagedstr '%F{green}●'
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
    zstyle ':vcs_info:hg:*' branchformat '%b'
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:git*+set-message:*' hooks git-stash
fi

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes})"
    fi
}

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu yes select
zstyle ':completion:*' force-list always
zstyle ':completion:*' menu select=1

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle '*:processes-names' command 'ps -e -o comm='
zstyle '*:processes' command 'ps -au$USER'

setopt append_history
setopt autocd
setopt auto_menu
setopt auto_param_slash
setopt auto_remove_slash
setopt auto_pushd
unsetopt beep
setopt chase_links
setopt complete_in_word
setopt correct
setopt csh_junkie_history
setopt extended_glob
setopt extended_history
unsetopt hist_beep
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_verify
unsetopt list_beep
setopt list_rows_first
setopt inc_append_history
setopt pushd_ignore_dups
setopt pushd_to_home
unsetopt function_argzero

autoload -U zmv

autoload -U bashcompinit
bashcompinit

#bash_source() {
#  alias shopt=':'
#  alias _expand=_bash_expand
#  alias _complete=_bash_comp
#  emulate -L sh
#  setopt kshglob noshglob braceexpand
#
#  have() {
#    unset have
#    (( ${+commands[$1]} )) && have=yes
#  }
#
#  source "$@"
#}
#
#bash_source /etc/bash_completion.d/openssl

#------------------------------------------------------------------------------
# Compinstall configuration
#------------------------------------------------------------------------------
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' max-errors 1 not-numeric
zstyle ':completion:*' original true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
#zstyle ':completion:*' menu select=2
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always


autoload -U promptinit 
promptinit
prompt seb

alias vi='gvim -geometry=133x150'
alias vir='vi --remote-silent'
alias vid='gvim -d'
alias gti='git'
alias ggb='git gui blame'

bindkey "\e[3~" delete-char
bindkey "\e[H" beginning-of-line #Konsole
bindkey "^[OH" beginning-of-line #Terminator
bindkey "\e[F" end-of-line #Konsole
bindkey "^[OF" end-of-line #Terminator

#bindkey '^A'    beginning-of-line    # Home
#bindkey '^E'    end-of-line          # End
#bindkey '^D'    delete-char          # Del
#bindkey '^[[1~' beginning-of-line    # Home
#bindkey '^[[3~' delete-char          # Del
#bindkey '^[[4~' end-of-line          # End
bindkey '^[[5~' up-line-or-search     # Page  Up
bindkey '^[[6~' down-line-or-search   # Page  Down
#bindkey "^[[7~" beginning-of-line    # Home
#bindkey "^[[8~" end-of-line          # End
#bindkey "^[OH"  beginning-of-line
#bindkey "^[OF"  end-of-line
#bindkey "^[[H"  beginning-of-line
#bindkey "^[[F"  end-of-line
#
#bindkey '^[[A'  up-line-or-search   # Up
#bindkey '^[[D'  backward-char       # Left
#bindkey '^[[B'  down-line-or-search # Down
#bindkey '^[[C'  forward-char        # Right
#------------------------------------------------------------------------------
# Custom aliases
#------------------------------------------------------------------------------


alias ll="ls -o -h -N --color=auto"
alias la="ls -o -h -A --color=auto"
alias md="mkdir -p"
alias df="df -h"

alias gp="grep --exclude-dir='.svn' --exclude-dir='.git' --exclude='cscope.*' --color=always -n -r"
alias gpi="gp -i"
alias cm="~/Tools/cmake"

#Pipe vi:
alias -g V='|vi -R -'
alias -g H='HEAD'
alias -g H='HEAD'
alias -g ...='../..'

export PATH="$PATH:$HOME/Tools/"
export MANPAGER='manpagervim.sh'
export JS_CMD='jsc'


#------------------------------------------------------------------------------
# Custom suffixes aliases
#------------------------------------------------------------------------------
alias -s pdf="evince "
alias -s c="vi "
alias -s cpp="vi "
alias -s h="vi "
alias -s txt="vi "
alias -s log="vi "
alias -s htm="google-chrome "
alias -s html="google-chrome "

#------------------------------------------------------------------------------
# HOOKS
#------------------------------------------------------------------------------
CmdTimeProcess="no"
CmdLaunched="yes"

#------------------------------------------------------------------------------
#Open a greped file with vi at the right line :

compdefas () {
  local a
  a="$1"
  shift
  compdef "$_comps[$a]" "${(@)*}=$a"
}

vig () {
   vi_file=`echo "$1" | awk -F : '{print $1}'`;
   vi_line=`echo "$1" | awk -F : '{print $2}'`;
   vi $vi_file +$vi_line;
}

vic () {
   vi_file=`echo "$1" | awk -F : '{print $1}'`;
   vi_line=`echo "$1" | awk -F : '{print $2}'`;
   vi -t $vi_file +$vi_line;
}

viw () {
    vi $(which $*)
}
compdefas which viw

p () {
    pri="$(( $@ ))"
   echo "$pri";
}

mytop () {
    while (true); do
        clear;
        echo -e "\x1b[f";
        $*;
        sleep 1;
    done;
}
compdef _command mytop


alias ccs='mytop ccache -s'
