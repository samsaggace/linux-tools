#! /bin/sh

ManpageTitle=$(ps -p $(ps -p $$ -o ppid=) -o args= | awk '{print $NF}')
ManpageTitle="MANPAGE\ :\ $ManpageTitle"

col -b | gvim -R -c -geometry 103x54 "set ft=man nomod nolist titlestring=$ManpageTitle" - > /dev/null 

