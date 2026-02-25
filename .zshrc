export PATH="$PATH:$HOME/Tools:$HOME/go/bin/"

FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH


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
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/ruby
    zgen oh-my-zsh plugins/rbenv
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/docker
    #zgen oh-my-zsh plugins/thefuck
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

#export GPG_TTY="$(tty)"
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

fpath=($HOME/.zsh-completion.d/ $fpath)
compinit


alias ls='lsd'


export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
 source /Users/sebastien/.support-tools/install/support-tools-rc.sh ## ADDED BY SUPPORT TOOLS
export CHECKOUT_REPOSITORIES_PATH="/Users/sebastien/git/" ## ADDED BY SUPPORT TOOLS

export CLOUDSDK_PYTHON_SITEPACKAGES=1


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

#Bind command left and command right to beginning and end of line
bindkey "\e\eOD" beginning-of-line
bindkey "\e\eOC" end-of-line

# bun completions
[ -s "/Users/sebastien/.bun/_bun" ] && source "/Users/sebastien/.bun/_bun"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sebastien/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_HOST_OVERRIDE=$(colima ls -j | jq -r '.address')
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"


# Added by dbt installer
export PATH="$PATH:/Users/sebastien/.local/bin"

# dbt aliases
alias dbtf=/Users/sebastien/.local/bin/dbt
