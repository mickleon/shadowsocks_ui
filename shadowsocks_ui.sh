#!/bin/bash

cd $1
LOCAL_HOST="'127.0.0.1'"
LOCAL_PORT="1080"
CONFIGS=config/configs
CURRENT_CONF=config/current_conf

function notificate {
    config=$(cat $CURRENT_CONF)
    echo "$1"
    notify-send -i shadowsocks \
        --expire-time=5000 \
        -h string:sound:false \
        -h int:transient:5 \
        -a "shadowsocks_ui.sh" "$1" "$config"
}

function start {
    config=$(cat $CURRENT_CONF)
    ssservice local -c $config --daemonize && \
    dconf write /system/proxy/mode "'manual'" && \
    dconf write /system/proxy/socks/host $LOCAL_HOST && \
    dconf write /system/proxy/socks/port $LOCAL_PORT
}

function kill {
    pkill -f ssservice && dconf write /system/proxy/mode "'none'"
}

if [ "$2" == "--change-conf" ]; then
    choise=$(find $CONFIGS -name "*.json" -exec zenity --list \
        --title="Choose configuration" \
        --height=400 \
        --column="Cofiguration" {} +)
    if [ $? != "1" ]; then
        echo "$choise" > $CURRENT_CONF
        kill
        start && notificate "Proxy enabled"
    fi
else
    if [ $(dconf read /system/proxy/mode) == "'none'" ]; then
        start && notificate "Proxy enabled"
    else
        kill && notificate "Proxy disabled"
    fi
fi
