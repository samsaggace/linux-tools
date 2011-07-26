echo "   _________  _   _ ____   ____ "
echo "  |__  / ___|| | | |  _ \ / ___|"
echo "    / /\___ \| |_| | |_) | |    "
echo " _ / /_ ___) |  _  |  _ <| |___ "
echo "(_)____|____/|_| |_|_| \_\\\\\____|"
echo ""

#------------------------------------------------------------------------------
# Compinstall configuration
#------------------------------------------------------------------------------
zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1 not-numeric
zstyle ':completion:*' original true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle ':completion:*' menu select=2
zstyle ':completion:*' force-list always
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle :compinstall filename '/home/g133090/.zshrc'

autoload -Uz compinit
compinit

#autoload zsh/complist

HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
bindkey -e


#------------------------------------------------------------------------------
# Options
#------------------------------------------------------------------------------
setopt appendhistory autocd extendedglob nomatch notify

# Input/Output Options
setopt correct short_loops

#Expansion and Globbing
setopt bad_pattern extendedglob case_glob nullglob

#Options controlling the history
setopt bang_hist append_history extended_history hist_ignore_space hist_verify

#Completion Options
setopt list_ambiguous #glob_complete rec_exact

#cd Options
setopt autocd auto_pushd pushd_to_home

#Job Control Options
setopt notify check_jobs

#ooooo
setopt complete_in_word extended_history multios


#------------------------------------------------------------------------------
# Custom environment variables
#------------------------------------------------------------------------------
alias e='export'
alias a='alias'
alias u='unset'

e  TMPDIR="${HOME}/tmp"
e  SVN_EDITOR='gvim -geometry 88x68'

#------------------------------------------------------------------------------
# Custom aliases
#------------------------------------------------------------------------------

a  vi='gvim -geometry 88x68 -O'

a ll="ls -o -h -N --color=auto"
a lla="ls -o -h -A --color=auto"

a gp="grep --exclude-dir='.svn' --color=always -n -r"
a gpi="gp -i"

#Pipe vi:
a -g V='|vi -R -'


# Directory comparaison with vim
vid () {
   
   # Check if args are url
   res1=`echo $1 | grep "^[[:alpha:]]\+://"`
   res2=`echo $2 | grep "^[[:alpha:]]\+://"`

   if [ "$res1" != "" ]; then
      # Export dir to tmp dir
      dir1="$TMPDIR/$RANDOM"
      echo "Exporting $1 to $dir1 to be compared..."
      svn export $1 $dir1 > /dev/null;
      if [ $? != 0 ]; then
         echo "Error : Could not export $1 !!"
         exit 1;
      fi
      dirnamea='+let g:DirDiffNameA = "'$1'"'
   else
      dir1=$1
      dirnamea=
   fi

   if [ "$res2" != "" ]; then
      # Export dir to tmp dir
      dir2="$TMPDIR/$RANDOM"
      echo "Exporting $2 to $dir2 to be compared..."
      svn export $2 $dir2 > /dev/null;
      if [ $? != 0 ]; then
         echo "Error : Could not export $1 !!"
         exit 1;
      fi
      dirnameb='+let g:DirDiffNameB = "'$2'"'
   else
      dir2=$2
      dirnameb=
   fi

   gvim -geometry 176x68+0+0 +'let g:DirDiffExcludes = ".svn, .*.swp"' \
                             $dirnamea                         \
                             $dirnameb                         \
                             +'DirDiff '$dir1' '$dir2''
}

#Open a greped file with vi at the right line :
vig () {
   vi_file=`echo "$1" | awk -F : '{print $1}'`;
   vi_line=`echo "$1" | awk -F : '{print $2}'`;
   vi $vi_file +$vi_line;
}

vgp () {
   if [ $# = "0" ]; then
      echo "Error : Need to specify a Pattern"
      echo "Usage : vgp Pattern [directory]"
      return;
   fi
   if [ $# -gt 2 ]; then
      echo "Error : To many directories, only none or one supported"
      echo "Usage : vgp Pattern [directory]"
      return;
   fi
   if [ "$2" = "" ]; then
      arg2="**/*[^ao]"
   else
      arg2="$2/**/*[^ao]"
   fi
   vi -geometry 176x68 +'GREP /'"$1"'/j '"$arg2"''
}
#------------------------------------------------------------------------------
# Custom suffixes aliases
#------------------------------------------------------------------------------
a -s pdf="kpdf "
a -s c="vi "
a -s cpp="vi "
a -s h="vi "
a -s txt="vi "
a -s log="vi "
a -s htm="opera "
a -s html="opera "

#------------------------------------------------------------------------------
# HOOKS
#------------------------------------------------------------------------------
CmdTimeProcess="no"
CmdLaunched="yes"


#------------------------------------------------------------------------------
precmd () {
#------------------------------------------------------------------------------
#echo "precmd"
   
   title %d

   # For command time
   local promptsize=${#${--(%l:%L:%j)--(%d)---(%n)--(%m)--}}
   local pwdsize=${#${(%):-%d}}
   local termwidth

   (( termwidth = ${COLUMNS} - 33 ))
   PR_FILLBAR=""
   PR_PWDLEN=""
    
   if [[ "$promptsize + $pwdsize" -gt $termwidth ]]; then
      ((PR_PWDLEN=$termwidth - $promptsize))
   else
       PR_FILLBAR="\${(l.(($termwidth - ($promptsize + $pwdsize)))..${PR_HB}.)}"
   fi

   # For command time
   CmdTime=0

   if [ "$CmdTimeProcess" = "yes" ] && [ "$CmdLaunched" = "yes" ]; then
      CmdLaunched="no"
      CmdTime=$(($SECONDS-$TimeRemind))
   fi
}


#------------------------------------------------------------------------------
preexec()
#------------------------------------------------------------------------------
{
#echo "preexec"
   title %d

   if [ "x$TTY" != "x" ]; then
      # For command time
      CmdTimeProcess="yes"
      TimeRemind="$SECONDS"
      CmdLaunched="yes"
   fi
}


#------------------------------------------------------------------------------
postcmd () {
#------------------------------------------------------------------------------
#echo "postcmd"
}


#------------------------------------------------------------------------------
# Utils functions
#------------------------------------------------------------------------------

title() {
   print -Pn "\e]2; $* \a" # plain xterm title
}


#------------------------------------------------------------------------------
# Prompt
#------------------------------------------------------------------------------

myprompt () {
   setopt prompt_subst
   autoload colors zsh/terminfo

   if [[ "$terminfo[colors]" -ge 8 ]]; then
       colors
   fi

   PR_NO_COLOR="%{$terminfo[sgr0]%}"
   for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE BLACK; do
       eval PR_$color='$PR_NO_COLOR%{$terminfo[bold]$fg[${(L)color}]%}'
       eval PR_L$color='$PR_NO_COLOR%{$fg[${(L)color}]%}'
       (( count = $count + 1 ))
   done

   typeset -A altchar
   set -A altchar ${(s..)terminfo[acsc]}
   PR_SET_CHARSET="%{$terminfo[enacs]%}"
   PR_IN="%{$terminfo[smacs]%}"
   PR_OUT="%{$terminfo[rmacs]%}"
   PR_HB=${altchar[q]:--}
   PR_UL=${altchar[l]:--}
   PR_LL=${altchar[m]:--}
   PR_LR=${altchar[j]:--}
   PR_UR=${altchar[k]:--}

   PR_LINE_COLOR=$PR_BLUE
   PR_TL_COLOR=$PR_BLUE
   PR_UL_COLOR=$PR_CYAN
   PR_UR_COLOR=$PR_GREEN
   PR_MR_COLOR=$PR_MAGENTA
   PR_LL_COLOR=$PR_YELLOW
   PR_LR_COLOR=$PR_WHITE
   PR_TR_COLOR=$PR_WHITE
   PR_CT_COLOR=$PR_YELLOW


if [ "$HOST" != "$MYHOST" ]; then
   PR_UL_COLOR=$PR_YELLOW
   PR_MR_COLOR=$PR_MAGENTA
fi
if [ "$USER" != "$MATRICULE" ]; then
   PR_UL_COLOR=$PR_RED
   PR_UR_COLOR=$PR_RED
fi
if [ "$SHLVL" != "3"  ]; then
   PR_TL_COLOR=$PR_RED
fi



   PROMPT='$PR_SET_CHARSET\
$PR_LINE_COLOR$PR_IN$PR_UL$PR_HB$PR_OUT(\
$PR_TL_COLOR%l:%L:%j\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_HB$PR_OUT(\
$PR_UL_COLOR%d\
$PR_LINE_COLOR)$PR_IN$PR_HB${(e)PR_FILLBAR}$PR_HB$PR_OUT(\
$PR_UR_COLOR%$PR_PWDLEN<...<%n$PR_LINE_COLOR)$PR_IN$PR_HB$PR_HB($PR_MR_COLOR%m%<<$PR_OUT\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_UR$PR_OUT\

$PR_IN$PR_LL$PR_HB$PR_OUT($PR_LL_COLOR%h%(?..$PR_LINE_COLOR:$PR_RED%?)$PR_LINE_COLOR)\
$PR_LINE_COLOR$PR_IN$PR_HB>$PR_OUT$PR_NO_COLOR '

   RPROMPT=' $PR_LINE_COLOR<>$PR_IN$PR_HB$PR_OUT(\
$PR_CT_COLOR$CmdTime sec\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_OUT(\
$PR_TR_COLOR%D{%H:%M:%S}\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_HB$PR_OUT(\
$PR_LR_COLOR%D{%a,%d%b20%y}\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_LR$PR_OUT$PR_NO_COLOR'

   PS2='$PR_LINE_COLOR$PR_IN$PR_HB$PR_HB$PR_OUT(\
$PR_LL_COLOR%_\
$PR_LINE_COLOR)$PR_IN$PR_HB$PR_HB$PR_OUT$PR_NO_COLOR '
}

myprompt

