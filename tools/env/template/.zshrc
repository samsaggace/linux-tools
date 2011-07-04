#------------------------------------------------------------------------------
# User workstation custom 
#------------------------------------------------------------------------------

 export  MATRICULE=gxxxxxxxx
 export  MYHOST=xxxxxxxxxxxx

#export  SVN_IS_DOWN=1
#export  TOOLS_SET_IN_PROFILE=1

#export  GVIM_IMPROVED=2

#export  SCRIPTS=${HOME}/tools/scripts
#export  TOOLS_ROOT=${HOME}/tools
#export  TOOLSET_ROOT=${HOME}/toolschains
#export  KERNEL_ROOT=${HOME}/kernels
#export  TARGET_ROOT=${HOME}/rootfs/uclibc_2.3
#export  NFS_ROOT=${TARGET_ROOT}



#------------------------------------------------------------------------------
# TEAM TOOLS ENV
#------------------------------------------------------------------------------

if [ -z "$TOOLS_IN_PROFILE" ]; then
   URL_SVN=http://forge-urd44.osn.sagem/svn
   ToolsBO=$URL_SVN/sagem-tools-modrivers/BO/branches/BO_sagem-tools-modrivers${TOOLS_BETA}

   if [ "$USER" = "$MATRICULE" ]; then
      if [ -z "$SVN_IS_DOWN" ]; then
         svn export -q $ToolsBO/set-tools-modrivers.sh
         mv ./set-tools-modrivers.sh $HOME/.set-tools-modrivers.sh
      fi;

     $HOME/.set-tools-modrivers.sh
   fi

   . $HOME/.tools-modrivers.env
   . $TOOLS_PATH/env/libs/zsh/profile
fi



#------------------------------------------------------------------------------
# Custom aliases & variables
#------------------------------------------------------------------------------

#e  GVIM_TAGS=CSCOPE
#e  GVIM_TAGS_IN_SRC_REF=
#e  GDB_GMODE=0

