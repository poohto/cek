#!/system/bin/sh
USB="USB"
SIM="SIM"
NET="NET"
OK="ok"
NO="no"

b_usb=0
b_sim=1
b_net=1

setprop lte.dev.test end

while read LINE
do
    head=${LINE:0:3}
    tail=${LINE:4:5}
    #echo $head
    if [ "$head" == "$USB" ]; then
        #echo $tail
        if [ "$tail" == "$OK" ]; then
            b_usb=1
            echo "dongle usb is ok"
        else
            b_usb=0
            echo "dongle usb is not ok"
        fi
    elif [ "$head" == "$SIM" ];then
        #echo $tail
        if [ "$tail" == "$OK" ]; then
            b_sim=1
            echo "dongle sim is ok"
        else
            b_sim=0
            echo "dongle sim is not ok"
        fi
    elif [ "$head" == "$NET" ];then
        #echo $tail
        if [ "$tail" == "$OK" ]; then
            b_net=1
            echo "dongle net is ok"
        else
            b_net=1
            echo "dongle net is not ok"
        fi
    else
        echo "ERROR"
    fi

done < /blackbox/4G_check.txt


if [ $b_usb -eq 0 ];then
    #echo "b_usb: $b_usb"
    echo "dongle is not ok"
    exit 1
elif [ $b_sim -eq 0 ]; then
    #echo "b_sim: $b_sim"
    echo "dongle is not ok"
    exit 1
elif [ $b_net -eq 0 ]; then
    #echo "b_net: $b_net"
    echo "dongle is not ok"
    exit 1
else
    echo "dongle is ok"
    exit 0
fi


