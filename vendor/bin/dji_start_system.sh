#! /system/bin/sh
prop_log_memory=persist.sys.memory_monitor
value_log_memory=`getprop $prop_log_memory`
function memory_monitor()
{
    if [ "$value_log_memory" != "" ]; then
        echo "persist.sys.memory_monitor: '$value_log_memory' enable memory monitor" > /dev/kmsg
        logwrapper  memory_monitor.sh &
    fi

    logwrapper  memory_monitor.sh &
}
function iproute()
{
    ip rule add from all lookup main pref 9999
    ip -6 rule add table main 
    busybox route add -net 192.168.41.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.100.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.101.0  netmask 255.255.255.0 gw 192.168.50.2

    busybox route add -net 192.168.120.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.121.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.130.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.131.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.140.0  netmask 255.255.255.0 gw 192.168.50.2
    busybox route add -net 192.168.141.0  netmask 255.255.255.0 gw 192.168.50.2
}

function system_performance()
{
	echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
	echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor

	echo 1 > /sys/devices/system/cpu/cpu0/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu2/online
	echo 1 > /sys/devices/system/cpu/cpu3/online
	echo 1 > /sys/devices/system/cpu/cpu4/online
	echo 1 > /sys/devices/system/cpu/cpu5/online
	echo 1 > /sys/devices/system/cpu/cpu6/online
	echo 1 > /sys/devices/system/cpu/cpu7/online

	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
	cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
}


version="1254"
function sandisk_ufs_upgrade()
{
	result=$(cat /proc/scsi/scsi | grep "${version}")
	if [[ "$result" != "" ]]
	then
		echo "scsi version is 1254 need upgrade now"
		/vendor/bin/ufs  ffu -t 0 -p /dev/block/sda -w /vendor/firmware/IEG03nE1308001801M110000A9DB.fluf
        sleep 1
		#reboot
	else
		echo "scsi version is ok, don't upgrade"
	fi
}

function mainroute()
{
    ip rule add from all lookup main pref 5000
    ip -6 rule add table main
}

##COUNTER=1
##while [ "$COUNTER" -lt 3 ]; do
##    COUNTER=$(($COUNTER+1))
##
##    iproute
##    ret_route=$?
##    echo "the return value is $ret_route"
##    sandisk_ufs_upgrade
##    ret_ufs=$?
##    echo "the return value is $ret_ufs"
##    if [ $? -ne 0 ]; then
##      echo " dji_start_system.sh return ok"
##      break;
##    else
##      echo " dji_start_system.sh failed counter: $COUNTER"
##    fi
##
##    sleep 5
##done

# pull up gpio 62 for lte dongel of rm510
#echo --pin 62 > /d/gpio_dbg/pin
#echo --dir 62 1 > /d/gpio_dbg/pin
#echo --pull 62 3 > /d/gpio_dbg/pin
#echo --out 62 1 > /d/gpio_dbg/pin

## set system performance temp
system_performance

#add mainroute
mainroute

echo "mount logfs begin"
#mount logfs
mount -t vfat /dev/block/by-name/logfs /data/bootlog/ &
echo "mount logfs done"

logwrapper  wifi_info.sh &

## memory monitor enable
memory_monitor

if [ ! -d "/blackbox/RMRecord" ]; then
    mkdir -p /blackbox/RMRecord/
    chmod 777 -R /blackbox/RMRecord/
fi

set_fly_home=`getprop persist.dji.sysboot.set_fly_home`
if [ "$set_fly_home" == "1" ]; then
    pm disable com.android.launcher3
    am force-stop com.android.launcher3
else
    pm enable com.android.launcher3
fi

# trim boot services
dji_boot_trim_services=`getprop persist.dji.boot_trim_services`
if [ "$dji_boot_trim_services" == "1" ]; then
    echo "dji_boot_trim_services begin"
    am force-stop com.android.permissioncontroller
    am force-stop com.dpad.fuli
    am force-stop com.android.packageinstaller
    am force-stop com.android.shell
    stop vendor.camera-provider-2-4
    stop cameraserver
    stop vendor.imsdaemon
    stop iop-hal-2-0
    stop vendor.ssgtzd
    stop vendor.cnd
    stop statsd
    stop wifidisplayhalservice
    stop vendor.qwesd
    stop vendor.ims_rtp_daemon
    stop vendor.perfservice
    stop update_engine
    stop vendor.boot-hal-1-1
    stop wfdhdcphalservice
    stop eid-1-0
    stop vendor.qcc-trd
    stop vendor.trustedui-1-0
    stop credstore
    stop vendor.servicetracker-1-2
    stop vendor.ipacm
    stop vendor.drm-clearkey-hal-1-3
    stop vendor.qesdk-mgr
    stop cnss-daemon
    stop vendor.cnss_diag
    stop vendor.wifi_hal_legacy
    stop gatekeeperd
    stop qspmhal
    stop pasr-hal
    stop vendor.usb-hal-1-2
    stop feature_enabler_client
    stop dpmQmiMgr
    stop nqnfc_2_0_hal_service
    stop display-color-hal-1-0
    stop poweropt-service
    stop incidentd
    stop secureelement-hal_1_2
    stop vendor.keymaster-4-1
    stop vendor.sec_nvm
    stop qteeconnector-hal-1-0
    stop qfp-daemon
    stop spu_service
    stop idmap2d
    stop qti_esepowermanager_service_1_1
    stop vendor.per_mgr
    stop vendor.capabilityconfigstore
    stop vendor.dspservice
    stop vendor.memtrack-hal-1-0
    stop soter-1-0
    stop gatekeeper-1-0
    stop sensorscal-hal-1-0
    stop secureprocessor-1-0
    stop vendor.cdsprpcd
    stop vendor.sensors.qti
    stop vendor.qspmsvc
    stop tui_comm-1-0
    stop vendor.tlocd
    stop qccvndhalservice
    stop vendor.cas-hal-1-2
    stop vendor.sensors
    stop vendor.adsprpcd
    stop vendor.spdaemon
    stop loc_launcher
    stop qccsyshalservice
    stop vendor.qconfig
    stop vendor.limits-hal
    stop wfdvndservice
    stop vendor.pd_mapper
    stop vendor.atrace-hal-1-0
    stop vendor.msm_irqbalance
    stop traced
    stop vendor.per_proxy
    stop traced_probes
    stop mlid
    stop vendor.rmt_storage
    stop vendor.tftp_server
    stop dpmd
    stop vendor.ipacm-diag
    stop vendor.qrtr-ns
    stop vendor.lowi
    stop ssgqmigd
    echo "dji_boot_trim_services end"
else
    echo "dji_boot_trim_services disabled"
fi

## reset passthrough enable true
setprop persist.sys.fuse.passthrough.enable true

## reset logd buffer size
sleep 20
stop logd
start logd
sleep 5
logcat -G 128K
killall logcat

sleep 352800
