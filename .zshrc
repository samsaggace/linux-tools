export PATH="$PATH:$HOME/Tools/"


source antigen.zsh

antigen-use oh-my-zsh
antigen-bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle composer
antigen bundle bundler
#antigen bundle docker
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
#antigen bundle https://gist.github.com/4644554.git 
#antigen bundle ubuntu
antigen bundle colorize

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

alias vi='gvim -geometry=133x150'
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

export PATH=$PATH:/home/sebastien/dev-git/tiny-tools/bin
. /home/sebastien/dev-git/tiny-tools/bin/bashrc

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export PATH="$HOME/.composer/vendor/bin:$PATH"

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

kplasma() {
    killall plasmashell
    kstart plasmashell > /dev/null 2>&1 &
}

#Pipe vi:
alias -g V='|vi -R -'
alias -g ...='../..'

export MANPAGER='manpagervim.sh'

compdef _gnu_generic git-review
