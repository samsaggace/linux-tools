#!/bin/sh

name=`getent passwd "$1" | cut -d ':' -f 5 | cut -d ',' -f 1`

if [[ -z "$name"  ]] ; then
echo "$1 <$1@netgem.com>"
else
echo "$name <$1@netgem.com>"
fi
