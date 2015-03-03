#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for f in `find "$1" -type f`; do
    bf=`basename $f`;
    res=`find $2 -name "$bf"`;
    if [ "$res" != "" ]; then
        sf=`stat -c%s $f`
        found=0
        for r in $res; do
            if [[ `stat -c%s $r` ==  $sf ]]; then
                echo "'$f' --> '$r'"
                found=1
            fi
        done
        if [ "$found" != "1" ]; then
            echo "'$f' not found in '$2' (size mismatch)"
        fi
    else
        echo "'$f' not found in '$2' (filename not found)"
    fi
done
IFS=$SAVEIFS
