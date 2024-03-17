#!/system/bin/sh
echo "start script"
filepath="/blackbox/dongle_iperf.txt"

rm -f $filepath
setprop lte.usb.iperf start

if [ ! -f "$filepath" ]; then
    echo "start usb iperf success"
    exit 0
else
    echo "start usb iperf fail"
    exit 1
fi
