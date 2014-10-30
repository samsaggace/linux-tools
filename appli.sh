#!/bin/sh

targ=`cat .application_config | grep APPLICATION_LIST | cut -d= -f2`
echo $targ
