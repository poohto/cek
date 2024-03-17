#!/system/bin/sh
echo 0 > /sys/class/gpio/unexport
echo 0 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio0/direction

cat /sys/class/gpio/gpio0/value | while read LINE
do

if [[ $LINE == "0" ]]; then
	echo "dongle insert ok"
	exit 0
else
    echo "dongle not inserted"
	exit 1
fi

done