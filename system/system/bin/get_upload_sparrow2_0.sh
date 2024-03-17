#!/system/bin/sh

stop dji_sdrs_agent

# reset sparrow
pigeon_reset.sh

while true;
do

usbfile="/sys/kernel/debug/usb/devices"

bootrom=`grep ProdID=0040 $usbfile`
bootloader=`grep ProdID=d00d $usbfile`
brexist=`echo $bootrom | wc -w`
blexist=`echo $bootloader | wc -w`

pro_dir=/mnt/encrypt

if [ $brexist -gt 0 ] ; then
    echo ------$bootrom exist info $brexist

    brload $pro_dir/bootarea.img
    [ $? -ne 0 ] && echo "loading bootarea failed" && exit 1
    sleep 0.5
fi

if [ $blexist -gt 0 ] ; then
    echo ------$bootloader exist info $blexist

    fastboot flash cmpu_ver $pro_dir/pro_prak_rsa3k.pub.mon
    [ $? -ne 0 ] && echo "fail to get cmpu ver" && exit 4

    fastboot flash cmpu_kdr $pro_dir/pro_prak_rsa3k.pub.mon
    [ $? -ne 0 ] && echo "flash kdr failed" && exit 2

    fastboot get_staged $pro_dir/upload.bin
    [ $? -ne 0 ] && echo "get upload.bin failed" && exit 3

    exit 0
fi

done;
