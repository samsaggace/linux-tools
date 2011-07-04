#!/bin/bash --norc
# Add ccache dir to the path
export PATH=$ENV_PATH/ccachebin:$PATH

export CCACHE_BASEDIR=$(pwd)
unset  CCACHE_HARDLINK
export CCACHE_UMASK=002
export CCACHE_COMPRESS=y
export CCACHE_COMPILERCHECK=content


