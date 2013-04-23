#!/bin/bash --norc

#Stop on error
set -e

#Proto :
dirname="$1"

if [[  "$dirname" == "" ]]; then
    echo -e "Error in prototype, should be : $0 dirname"
    exit 1;
fi;


to_dcomm=`git svn dcommit -n`
if [[ `echo $to_dcomm | grep "diff-tree"` != "" ]]; then
    svn_reb=`echo "$to_dcomm"  | sed -n 's@Committing.*svn.*/branches/\(.*\) ...@remotes/\1@p'`
    echo -e "Debug branch svn_reb=$svn_reb"
    if [[ "$svn_reb" == "" ]]; then
        svn_reb=`echo "$to_dcomm"  | sed -n "s@Committing.*svn.*/\(tags\)/\(.*\) ...@remotes/\1/\2@p"`
        echo -e "Debug tag svn_reb=$svn_reb"
    fi;
    if [[ "$svn_reb" != "" ]]; then
        echo -e "\nCreating directory '$dirname'"
        mkdir -p $dirname
        echo -e "\nSaving patch from '$svn_reb'"
        git format-patch $svn_reb -o $dirname
    else
        echo -e "Could not find branch from dcommit :"
        echo -e "$to_dcomm"
    fi;
else
    echo -e "No diff to save :"
    echo -e "$to_dcomm"
fi;
