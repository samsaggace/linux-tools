#!/bin/bash --norc

#Stop on error
set -e

if [[ `git status -s -uno` != '' ]]; then
    echo -e "Stashing local diff to enable rebase (Warning : Manual stash pop needed if script interrupted)"
    stashed=1
    git stash
fi;

root_dir="/home/$USER/Patches/git_backup"
br_list=`git br`
current=`echo "$br_list" | grep "^\*" | awk '{print $2}'`
up_list=`echo "$br_list" | sed "s/[ *]//g" | grep -v "\-[0-9]\{10\}" | grep -v "^__"`
now=`date +%y%m%d%H%M`

echo -e "Branches to update :\n$up_list\n"
git svn fetch
for branch in $up_list; do
    echo -e "\nSaving branch in '$branch-$now'"
    git branch $branch-$now $branch
    echo -e "\nRebasing '$branch' on svn"
    git co $branch
    git svn rebase -l
    git-patch-svn.sh "$root_dir/$now/$branch"
done
echo -e "\n"
git co $current

if [ "$stashed" = "1" ]; then
    echo -e "Restoring stashed data"
    git stash pop
fi
