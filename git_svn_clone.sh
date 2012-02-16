#!/bin/sh --norc

mkdir nsv
cd nsv
git init
git remote add origin git://sch1/git_full/nsv
git config --replace-all remote.origin.fetch '+refs/remotes/*:refs/remotes/*'
git fetch

git config --remove-section remote.origin
git checkout -b master remotes/nsv-tangox

git svn init -s svn+ssh://svn/repos/nsv
git svn rebase
