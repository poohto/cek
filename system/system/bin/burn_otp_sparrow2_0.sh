#!/system/bin/sh

pro_dir=/mnt/encrypt

fastboot flash cmpu_otp $pro_dir/otp.sec
[ $? -ne 0 ] && echo "cmpu otp failed" && exit 5

fastboot reboot
start dji_sdrs_agent

exit 0
