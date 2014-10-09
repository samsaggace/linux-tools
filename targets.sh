#!/bin/sh

targ=`cat .targets | grep TARGET_LIST | cut -d= -f2`
echo $targ
