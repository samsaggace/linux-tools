#!/bin/tcsh -f

#Take the 1st argument, or the DIRWORK or PWD for the Workset
if ( "$1" != "" && -d $1 ) then
   set WorksetPath = "$1"
else if ( $?DIRWORK == 1 ) then
   set WorksetPath = "$DIRWORK"
else
   set WorksetPath = "$PWD"
endif


setenv VIMTAGSPATH "$WorksetPath/.vimtags"
setenv CSCOPE_DB   "$VIMTAGSPATH/cscope.out"
setenv tagsfile    "$VIMTAGSPATH/tags"


if ( "`echo "$GVIM_TAGS" | grep "CSCOPE"`" != "" ) then
   set Tags_cscope = "y"
else
   set Tags_cscope = "n"
endif

if ( "`echo "$GVIM_TAGS" | grep "CTAGS"`" != "" ) then
   set Tags_ctags  = "y"
else
   set Tags_ctags  = "n"
endif


set VimPath = `echo $VIMTAGSPATH | sed s@"$PWD/"@@g`


#Create the folder for the first use and update with makecpenv
if (! -e $VIMTAGSPATH || $2 == "0") then
   echo "Creating/Updating Vimtags file list in [0;35m$VimPath[0m"
   
   mkdir -p $VIMTAGSPATH
   find     $WorksetPath/ -name "*.h"                                            >  $VIMTAGSPATH/files.list
   find     $WorksetPath/ -name "*.c"                                            >> $VIMTAGSPATH/files.list
   find     $WorksetPath/ -name "*.config"                                       >> $VIMTAGSPATH/files.list
   find     $WorksetPath/ -path "*\.svn" -prune -o -iname "*mak*" -type f -print >> $VIMTAGSPATH/files.list
   touch    $VIMTAGSPATH/cscope.out
   touch    $VIMTAGSPATH/tags
endif

#Generating/Updating csope.out if not disabled
if ( "$2" != "0" ) then
   set   CscopeAbs = `readlink -f $CSCOPE_DB`
   set   TagsAbs   = `readlink -f $VIMTAGSPATH/tags`
   set   FilesAbs  = `readlink -f $VIMTAGSPATH/files.list`

   if ( "$3" == "bg" ) then
      if ( "$Tags_cscope" == "y" ) then
         echo "Generating/Updating CSCOPE in [0;35m$VimPath[0m (background job)"
         (cscope -Rbk -i $FilesAbs -f $CscopeAbs &) >& /dev/null
   endif

      if ( "$Tags_ctags"  == "y" ) then
         echo "Generating/Updating CTAGS  in [0;35m$VimPath[0m (background job)"
         (ctags -R --fields=+lStn --extra=+f --tag-relative=yes -L $FilesAbs -f $TagsAbs  && sed -i '/EXPORT_SYMBOL/d' $TagsAbs &) >& /dev/null
      endif
   else
      if ( "$Tags_cscope" == "y" ) then
         echo "Generating/Updating CSCOPE in [0;35m$VimPath[0m"
         cscope -Rbk -i $FilesAbs -f $CscopeAbs;
      endif

      if ( "$Tags_ctags"  == "y" ) then
         echo "Generating/Updating CTAGS  in [0;35m$VimPath[0m"
         ctags -R --fields=+lStn --extra=+f --tag-relative=yes -L $FilesAbs -f $TagsAbs  && sed -i '/EXPORT_SYMBOL/d' $TagsAbs;
      endif
      echo "Done."
   endif
endif

