#!/system/bin/sh
b_usb=0
b_sim=0

echo "usb and sim check"
grep "disconnected from" /blackbox/system/kmsg.log | grep -v grep
if [ $? == 0 ];then
    b_usb=1
	echo "Has found dongle disconnected events."
fi

grep "dev_dji: no sim card" /blackbox/system/system.log | grep -v grep
if [ $? == 0 ];then
    b_sim=1
	echo "Has found sim card disconnected events."
fi

if [ $b_usb -eq 1 ];then
	echo "usb and sim are not ok"
	dji_mb_ctrl -S test -R diag -g 17 -t 2 -s 0x52 -c 0x9 02
    exit 1
elif [ $b_sim -eq 1 ]; then
	echo "usb and sim are not ok"
	dji_mb_ctrl -S test -R diag -g 17 -t 2 -s 0x52 -c 0x9 02
    exit 1
else
    echo "usb and sim are ok"
	dji_mb_ctrl -S test -R diag -g 17 -t 2 -s 0x52 -c 0x9 03
    exit 0
fi
