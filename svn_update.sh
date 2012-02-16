#!/bin/bash --norc

#Stop on error
set -e

if [ $# -ne 1 ]; then
    echo "Missing argument"
    exit 1
fi

if [[ `git status -s` != '' ]]; then
    echo -e "Stashing local diff to enable rebase (Warning : Manual stash pop needed if script interrupted)"
    stashed=1
    git stash
fi;

master=$1
br_list=`git br`
current=`echo "$br_list" | grep "^\*" | awk '{print $2}'`
up_list=`echo "$br_list" | sed "s/[ *]//g" | grep -v "$master" | grep -v "\-[0-9]\{10\}"`
now=`date +%y%m%d%H%M`

echo -e "Branches to update :\n$up_list\n"
git co $master
git svn fetch
git svn rebase
for branch in $up_list; do
    if [[ `git rev-list $master -n1` == `git merge-base $branch $master` ]]; then
        echo -e "\nBranch '$branch' up-to-date";
        continue;
    fi;

    echo -e "\nSaving branch in '$branch-$now'"
    git branch $branch-$now $branch
    echo -e "\nRebasing '$branch'"
    git rebase $master $branch
done
echo -e "\n"
git co $current

if [ "$stashed" = "1" ]; then
    echo -e "Restoring stashed data"
    git stash pop
fi
