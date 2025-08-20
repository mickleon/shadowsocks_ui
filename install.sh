#!/bin/bash

EXEC=$PWD/shadowsocks_ui.sh
ICON=$PWD/shadowsocks.png
DESKTOP_FILE=$HOME/.local/share/applications/shadowsocks.desktop
DESKTOP_ICON_PATH=$HOME/.local/share/icons/hicolor/256x256/apps

if [ ! -d "$DESKTOP_ICON_PATH" ]; then
    mkdir -p $DESKTOP_ICON_PATH
fi
cp $ICON $DESKTOP_ICON_PATH

cat > $DESKTOP_FILE << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Shadowsocks
Comment=Manage your shadowsocks connection
Exec=$EXEC $PWD
Icon=shadowsocks
Terminal=false
Categories=Utility;
Actions=change-conf;

[Desktop Action change-conf]
Name=Сhange configuration
Exec=$EXEC $PWD --change-conf
Icon=shadowsocks
EOF
chmod +x $DESKTOP_FILE && echo "Icon added to menu"
