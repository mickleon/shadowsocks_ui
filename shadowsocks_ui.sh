#!/bin/bash

BASE_NAME=$(basename "$0")
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
        -a "$BASE_NAME" "$1" "$config"
}

function ssservice_start {
    config=$(cat $CURRENT_CONF)
    ssservice local -c $config --daemonize &&
        dconf write /system/proxy/mode "'manual'" &&
        dconf write /system/proxy/socks/host $LOCAL_HOST &&
        dconf write /system/proxy/socks/port $LOCAL_PORT &&
        notificate "Proxy enabled"
}

function ssservice_kill {
    pkill -f ssservice
    if [[ $? != "1" ]]; then
        dconf write /system/proxy/mode "'none'" &&
            notificate "Proxy disabled"
    else
        ssservice_start
    fi
}

function ssservice_restart {
    pkill -f ssservice
    ssservice_start
}

if [ "$2" == "--change-conf" ]; then
    choise=$(find $CONFIGS -name "*.json" -exec zenity --list \
        --title="Choose configuration" \
        --height=400 \
        --column="Cofiguration" {} +)
    if [ $? != "1" ]; then
        echo "$choise" >$CURRENT_CONF
        ssservice_restart
    fi
else
    if [ $(dconf read /system/proxy/mode) != "'manual'" ]; then
        ssservice_start
    else
        ssservice_kill
    fi
fi
