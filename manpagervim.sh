#!/bin/bash --norc

ManpageTitle=$(ps -p $(ps -p $$ -o ppid=) -o args= | awk '{print $NF}')
ManpageTitle="MANPAGE\ :\ $MAN_PN"

col -b | MANPAGER='toto' gvim -geometry 120x65 -R -c  "set ft=man nomod noma nolist titlestring=$ManpageTitle" -c "let \$MANPAGER='$MANPAGER'" - > /dev/null

