if $GVIM_PATH == ""
   :let $GVIM_PATH  = "$TOOLS_PATH/gvim$GVIM_IMPROVED"
   :let $VIMRUNTIME = $GVIM_PATH
endif

source $GVIM_PATH/vimrc

