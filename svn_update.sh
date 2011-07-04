#!/bin/bash --norc

#Stop on error
set -e

if [ $# -ne 1 ]; then
    echo "Missing argument"
    exit 1
fi

master=$1
br_list=`git br`
current=`echo "$br_list" | grep "^\*" | awk '{print $2}'`
up_list=`echo "$br_list" | sed "s/[ *]//g" | grep -v "$master"`

echo -e "Branches to update :\n$up_list\n"
git co $master
git svn rebase
for branch in $up_list; do
    echo -e "\nRebasing '$branch'"
    git rebase $master $branch
done
echo -e "\n"
git co $current

