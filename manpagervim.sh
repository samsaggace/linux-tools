#!/bin/bash --norc

ManpageTitle=$(ps -p $(ps -p $$ -o ppid=) -o args= | awk '{print $NF}')
ManpageTitle="MANPAGE\ :\ $ManpageTitle"

col -b | gvim -R -c -geometry 120x65 "set ft=man nomod nolist titlestring=$ManpageTitle" - > /dev/null

