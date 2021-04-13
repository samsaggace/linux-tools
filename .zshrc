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
    zgen oh-my-zsh plugins/node
    zgen oh-my-zsh plugins/fabric
    zgen load lukechilds/zsh-better-npm-completion

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load denysdovhan/spaceship-prompt spaceship

    # save all to init script
    zgen save
fi

if ! ssh-add -l > /dev/null; then
    ssh-add -K $HOME/.ssh/id_rsa  < /dev/null > /dev/null 2>&1
fi

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

#Pipe vi:
alias -g V='|vi -R -'
alias -g ...='../..'

export MANPAGER='~/linux-tools/manpagervim.sh'


alias brewup='brew upgrade; brew cleanup; brew cask upgrade'
# Define a Shell alias

SSH_KEY_BASE=${HOME}/.ssh/id_rsa


export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

fpath=($HOME/.zsh-completion.d/ $fpath)
compinit

eval $(thefuck --alias)

export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=`which python3`
source /usr/local/bin/virtualenvwrapper.sh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/etc/bash_completion.d/nvm" ] && . "$NVM_DIR/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# place this after nvm initialization, will switch to the correct node version automatically
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"
  local nvmrc_vers

  if [ -n "$nvmrc_path" ]; then
    nvmrc_vers="$(cat "${nvmrc_path}")"
  else
    nvmrc_vers="stable"
  fi

  local nvmrc_node_version=$(nvm version ${nvmrc_vers})
  local nvmrc_remote_version=$(nvm version-remote ${nvmrc_vers})

  if [ "$nvmrc_node_version" = "N/A" ]; then
    nvm install
  elif [ "$nvmrc_remote_version" != "$nvmrc_node_version" ]; then
    echo "[NVM] Updating node/npm to latest version : $nvmrc_remote_version != $nvmrc_node_version "
    nvm install --reinstall-packages-from=$nvmrc_node_version
  elif [ "$nvmrc_node_version" != "$node_version" ]; then
    echo "[NVM] Using ${nvmrc_vers} version"
    nvm use ${nvmrc_vers}
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

alias ls='lsd'


