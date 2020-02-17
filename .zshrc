export PATH="$PATH:$HOME/Tools:$HOME/go/bin/"


source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
echo "Creating a zgen save"
    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    #zgen load bhilburn/powerlevel9k powerlevel9k
    zgen load junegunn/fzf


    zgen oh-my-zsh plugins/composer
    zgen oh-my-zsh plugins/bundler
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/rsync
    zgen oh-my-zsh plugins/python
    zgen oh-my-zsh plugins/history
    zgen oh-my-zsh plugins/vundle
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/rbenv
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/thefuck
    zgen oh-my-zsh plugins/repo
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/node

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load denysdovhan/spaceship-prompt spaceship

    # save all to init script
    zgen save
fi

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



alias brewup='brew upgrade; brew prune; brew cleanup; brew doctor; brew cask upgrade; brew cask cleanup; brew cask doctor'
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

#start_start_agent

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

fpath=($HOME/.zsh-completion.d/ $fpath)
compinit
