#!/bin/bash
#
# Wrapper around make, to colorize it's output and pipe through less.
# Jumps to the first gcc error that occurs during the build process.
#

/usr/bin/make $* 2>&1 | colormake.pl `stty size`
