#------------------------------------------------------------------------------
# VARS ENV
#------------------------------------------------------------------------------

 setenv   MATRICULE      xxxxxxxx
 setenv   MY_HOST        xxxxxxxx
#setenv   SVN_IS_DOWN    1
 setenv   GVIM_IMPROVED  2
#setenv   GVIM_TAGS      CSCOPE


#------------------------------------------------------------------------------
# PATHs
#------------------------------------------------------------------------------

 setenv   SCRIPTS        ${HOME}/tools/scripts
 setenv   PATH           "$SCRIPTS":"$PATH" 
 setenv   TOOLS_ROOT     ${HOME}/tools
 setenv   TOOLSET_ROOT   ${HOME}/toolschains
 setenv   KERNEL_ROOT    ${HOME}/kernels
 setenv   TARGET_ROOT    ${HOME}/rootfs/uclibc_2.3
 setenv   NFS_ROOT       ${TARGET_ROOT}


#------------------------------------------------------------------------------
# TOOLS ENV
#------------------------------------------------------------------------------

if ($USER == $MATRICULE) then
   if ($?SVN_IS_DOWN == 0) then
      svn export -q http://forge-urd44.osn.sagem/svn/sagem-tools-modrivers/BO/branches/BO_sagem-tools-modrivers/set-tools-modrivers.sh
      mv ./set-tools-modrivers.sh $HOME/.set-tools-modrivers.sh
   endif
   $HOME/.set-tools-modrivers.sh
   source $HOME/.tools-modrivers.env
else
   echo "[Warning] USER != MATRICULE"
endif


#------------------------------------------------------------------------------
# USER CUSTOM ENV
#------------------------------------------------------------------------------

set    User       = "" 
set    Host       = "%{^[[0;1;32m%}$HOST%{^[[0m%}"
set	 Separator  = ""
set    CurPwd     = "%{^[[0;1;36m%} %B%c03 %{^[[0m%}"
set    Prompt     = "%{^[[0;1;33m%}>>%{^[[0m%} %b"


if ($USER != $MATRICULE) then
set    User 	   = "%{^[[0;1;31m%}NOT_ME%{^[[0m%}" 
set    Host       =
endif

if ($HOST != $MY_HOST) then
set    Host       = "%{^[[0;1;31m%}$HOST%{^[[0m%}"
endif

if (($USER != $MATRICULE)  && \
    ($HOST != $MY_HOST))   then
set    Separator  = "::"
endif


set   prompt="[$User$Separator$Host]$CurPwd \n$Prompt"
set   autolist


alias    vi          'gvim -g -geometry 140x50'

setenv   SVN_EDITOR  vi
setenv   LC_ALL      en_US.UTF-8

