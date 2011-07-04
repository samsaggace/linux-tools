#!/bin/bash --norc
#*******************************************************************************
# *             Copyright (c) 2000 2009 SAGEM SA.
# *
# * Author        : CHEMIN Sebastien (& THIEMONGE Gregory)
# * Creation date : 17/04/2009
# *..............................................................................
# * Print all the available Firmwares. FOR DRIVER TEAM ONLY !
# *******************************************************************************
if [ -z $FIRMWARES_PATH ]; then
   echo -e "\e[38;1mPlease, execute '7env' command\e[0m"
   exit 10
fi

ABS_SCB_CONFIG=`readlink -f $SCB_CONFIG`

CURRENT_PROJECT_NAME=$(/bin/grep PROJECT_NAME $ABS_SCB_CONFIG | sed -n '/\<setenv[[:space:]]*\<PROJECT_NAME\>/ { s/#.*$//g; /\<PROJECT_NAME\>/ { s/^\<setenv[[:space:]]*\<PROJECT_NAME\>[[:space:]]*\([^[:space:]]*\)[[:space:]]*$/\1/;p } }' | tail -1)

echo -e "\n-----------------------------------------------------------------------"
echo -e "       Firmwares available for $DVD_FRONTEND (current in \e[1;31mred\e[0m ):"
echo -e "       -----------------------------------------------\n"


Files=$(find $FIRMWARES_PATH/* -name "*.mak")
Output=
Choices=
i=1
for Line in $Files
do
   Audio_Codecs=`grep AUDIO_STRING $Line | awk -F "=" '{print $2}' | sed 's/"//g'`
   Video_Codecs=`grep VIDEO_STRING $Line | awk -F "=" '{print $2}' | sed 's/"//g'`
   ProjectPrint=$(basename $Line .mak)
   Project=$(echo -e $ProjectPrint)
   Chip=`grep FIRMWARES_CHIP $Line | awk -F "=" '{print $2}'`
   Multicom=`grep FIRMWARES_MULTICOM_VERSION $Line | awk -F "=" '{print $2}'`
   AddrMode=`grep FIRMWARES_ADDRESSMODE $Line | awk -F "=" '{print $2}'`
   if [ "$Chip" != " $DVD_FRONTEND" ]; then
      continue
   fi
   if [ "$Project" = "$CURRENT_PROJECT_NAME" ]; then
      color="\e[1;31m"
   else
      color="\e[1m"
   fi
   Output=$Output"$i - $color$ProjectPrint\e[0m\e[32mAUDIO :$Audio_Codecs\e[0m\e[33mVIDEO :$Video_Codecs\e[0m\e[35mMULTICOM : $Multicom\t\t\e[36mADDRESS MODE : $AddrMode\e[0m\n\n"
   Choices=$Choices"$i $Project\n"
   i=$((i + 1))
done

echo -e "$Output" | sed 's//\n\t\t/g'
echo -e "------------------------------------------------------------------------"

echo -n "Select new project_name (0 to exit): "
read choice
NEW_PROJECT=$(echo -e $Choices | awk '/^'$choice'[[:space:]]/ { print $2 }')

if [ -z $NEW_PROJECT ] || [ "$NEW_PROJECT" = "$CURRENT_PROJECT_NAME" ]; then
   echo -e "No changes\n"
   exit 20
else
   sed -i 's/\([[:space:]]*\<setenv[[:space:]]*\<PROJECT_NAME\>[[:space:]]*\)'$CURRENT_PROJECT_NAME'/\1'$NEW_PROJECT'/' $ABS_SCB_CONFIG
   echo -e "New project name : \e[1;31m$NEW_PROJECT\e[0m"
   echo -e "\e[1mUse '7env' and rebuild SYSINI to apply changes\e[0m\n"
fi

