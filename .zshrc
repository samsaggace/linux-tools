export PATH="$PATH:$HOME/Tools"

source /usr/local/share/antigen/antigen.zsh
source $HOME/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundle git

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle composer
antigen bundle bundler
antigen bundle felixr/docker-zsh-completion
antigen bundle pip
antigen bundle rsync
antigen bundle python
antigen bundle zsh-users/zsh-completions src
antigen bundle command-not-found
antigen bundle history
antigen bundle vundle
antigen bundle gem
antigen bundle ruby
antigen bundle rbenv
antigen bundle colorize
antigen bundle brew
antigen bundle golang
antigen bundle docker
antigen bundle thefuck

antigen theme bureau

antigen apply

ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[red]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[magenta]%}★%{$reset_color%}"

export MATRICULE='sebastien'
export MYHOST='sebastien-e7440'

export SSH_ASKPASS=/usr/bin/ksshaskpass
if ! ssh-add -l > /dev/null; then
    ssh-add $HOME/.ssh/id_rsa $HOME/.ssh/gitlab.key < /dev/null > /dev/null 2>&1
fi
#source ~/Tools/.zshrc

alias vir='vi --remote-silent'
alias vil='vi -u NONE -R'
alias vid='gvim -d'
alias gti='git'
alias ggb='git gui blame'

alias grep='grep --color=auto'
alias gp="grep --exclude-dir='.git' --exclude='cscope.*' --exclude='tags*' --color=auto -n -r"
alias gpi="gp -i"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

compdefas () {
  local a
  a="$1"
  shift
  compdef "$_comps[$a]" "${(@)*}=$a"
}

vig () {
   local vi_file=`echo "$1" | awk -F : '{print $1}'`;
   local vi_line=`echo "$1" | awk -F : '{print $2}'`;
   vi $vi_file +$vi_line;
}

vic () {
   local vi_file=`echo "$1" | awk -F : '{print $1}'`;
   local vi_line=`echo "$1" | awk -F : '{print $2}'`;
   vi -t $vi_file +$vi_line;
}

viw () {
    vi $(which $*)
}
compdefas which viw

vi () {
    gvim $@ 2> /dev/null
}



p () {
   local pri="$(( $@ ))"
   echo "$pri";
}

kplasma() {
    killall plasmashell
    kstart plasmashell > /dev/null 2>&1 &
}

#Pipe vi:
alias -g V='|vi -R -'
alias -g ...='../..'

export MANPAGER='manpagervim.sh'

compdef _gnu_generic git-review
compdef _gnu_generic phpunit php-cs-fixer



alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
# Define a Shell alias
alias cassh='docker run -it -u $(id -u) -e HOME=${HOME} -w ${HOME} -v ${HOME}/.ssh:${HOME}/.ssh -v ${HOME}/.cassh:${HOME}/.cassh:ro --rm nbeguier/cassh-client'


SSH_KEY_BASE=${HOME}/.ssh/id_rsa

function diff_ssh_cert {
  if ! diff -q <(ssh-add -L ${SSH_KEY_BASE} | grep ssh-rsa-cert | awk '{print $2}') <(cat ${SSH_KEY_BASE}-cert.pub | awk '{print $2}') >/dev/null 2>&1; then
    ssh-add -D >/dev/null 2>&1
    ssh-add ${SSH_KEY_BASE} >/dev/null 2>&1  
  fi
}

function start_start_agent {
  SSH_AGENT_PID=$(pgrep ssh-agent | head -1)
  if [ -z "${SSH_AGENT_PID}" ]; then
    ssh-agent > /tmp/ssh_agent.eval
    eval "$(cat /tmp/ssh_agent.eval)" >/dev/null
    ssh-add ${SSH_KEY_BASE} >/dev/null 2>&1
  else
    eval "$(cat /tmp/ssh_agent.eval)" >/dev/null
    diff_ssh_cert
  fi
}

start_start_agent
