#!/bin/bash --norc
shname=`echo "$0" | awk -F / '{print $NF}'`

. $LIBS_PATH/debug

PTypeList="T Z"

Opt=

if [ $# -gt 1 -o "$1" == "-h" -o "$1" == "help" ]; then
   echo "--------------------------------------------------------------------------------"
   echo "Usage : $shname [options]"
   echo "   options"
   echo "            Killing '$PTypeList' child processes of current terminal"
   echo "      -a    Killing all '$PTypeList' system processes associated with a terminal"
   echo "--------------------------------------------------------------------------------"
   exit 1
fi

if [ "$1" == "-a" ]; then
   disp-info "Killing all '$PTypeList' system processes associated with a terminal..."
   Opt=$1
else
   disp-info "Killing '$PTypeList' child processes of current terminal..."
fi

ProcessesList=`ps $Opt -o pid,comm,state | sort -rn`

for PType in $PTypeList; do
IFS="
"
   for Process in $ProcessesList; do
      TypeProcess=`echo $Process | grep "$PType"`

      for ProcToKill in $TypeProcess; do
         PidToKill=`echo $ProcToKill | awk '{print $1}'`
         if [ "$PidToKill" != "PID" ]; then
            kill -9 $PidToKill
            Ret=$?
            ProcToKill=`echo $ProcToKill | sed "s@\([0-9]*\)@${COL_DEBUG}\1${COL_RST}@g"`
            if [ $Ret -ne 0 ]; then
               echo "$ProcToKill   ${COL_ERROR}KO${COL_RST}"
            else
               echo "$ProcToKill   ${COL_SUCCESS}OK${COL_RST}"
            fi
         fi
      done
   done
IFS=" "
done

disp-success "Done."
