#!/bin/bash
set -e

# Export Fcitx5 and Locale variables
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

source /opt/gow/launch-comp.sh

launcher
