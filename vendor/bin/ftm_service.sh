if [ "$1" = "wlan" ] ; then
    ifconfig wlan0 up
    echo 5 > /sys/module/wlan/parameters/con_mode
fi

ftmdaemon -n -dd
