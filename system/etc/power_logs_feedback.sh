#!/system/bin/sh
STATUS_DIR="/sys/class/power_supply/battery/status"
PRESENT_DIR="/sys/class/power_supply/usb/present"
usb_present="$(cat $PRESENT_DIR 2 >&1)"
status="$(cat $STATUS_DIR 2 >&1)"
ROOT_DIR="/data/nblog/"
LOG_DIR="/data/nblog/feedback/power/"
/system/bin/mkdir -p $LOG_DIR

dump_peripheral () {
	local base=$1
	local size=$2
	local dump_path=$3
	echo $base > $dump_path/address 
	echo $size > $dump_path/count 
	cat $dump_path/data
}
	pmlog_type=`getprop persist.sys.power.pm.type`
	if [ -n "$pmlog_type" ] && [ "$pmlog_type" = "pm" ] ; then
    LOG_DIR2=$LOG_DIR/battery
    /system/bin/mkdir -p $LOG_DIR2
    /system/bin/touch $LOG_DIR2/battery_info.txt
    /system/bin/touch $LOG_DIR2/kernel.txt
    echo "###############START DUPM UEVENT##################" >> $LOG_DIR2/battery_info.txt
    cat /sys/class/power_supply/*/uevent  >>  $LOG_DIR2/battery_info.txt
    /system/bin/dmesg >> $LOG_DIR2/kernel.txt
    echo "###############START DUPM PMI REG 1##################" >> $LOG_DIR2/battery_info.txt
    dump_peripheral 0x21000 0x700 "/sys/kernel/debug/spmi/spmi-0" >> $LOG_DIR2/battery_info.txt
    echo "###############START DUPM PMI REG 2##################" >> $LOG_DIR2/battery_info.txt
    dump_peripheral 0x24000 0x700 "/sys/kernel/debug/spmi/spmi-0" >> $LOG_DIR2/battery_info.txt
    echo "###############START DUPM FG REG##################" >> $LOG_DIR2/battery_info.txt
    dump_peripheral 0x400 0x200 "/sys/kernel/debug/fg_memif" >> $LOG_DIR2/battery_info.txt
else
    /system/bin/touch $LOG_DIR/battery_status.txt
    /system/bin/touch $LOG_DIR/rpm_stats.txt
    /system/bin/touch $LOG_DIR/ps.txt
    /system/bin/touch $LOG_DIR/top.txt
    /system/bin/touch $LOG_DIR/dump_alarm.txt
    /system/bin/touch $LOG_DIR/dump_power.txt
    /system/bin/touch $LOG_DIR/dump_batterys.txt
    /system/bin/touch $LOG_DIR/uevent.txt
    /system/bin/chown -R root:system $ROOT_DIR
    /system/bin/chmod -R 766 $ROOT_DIR
    /system/bin/ps >> $LOG_DIR/ps.txt
    /system/bin/top -m 20 -n 3 -t -s cpu >> $LOG_DIR/top.txt
    /system/bin/cat /sys/class/power_supply/battery/uevent >> $LOG_DIR/uevent.txt
    /system/bin/cat /sys/kernel/debug/rpm_stats >> $LOG_DIR/rpm_stats.txt
    /system/bin/cat /sys/kernel/debug/rpm_master_stats >> $LOG_DIR/rpm_stats.txt
    /system/bin/dumpsys alarm >> $LOG_DIR/dump_alarm.txt
    /system/bin/dumpsys power >> $LOG_DIR/dump_power.txt
    /system/bin/dumpsys battery >> $LOG_DIR/dump_batterys.txt
    /system/bin/dumpsys batteryproperties >> $LOG_DIR/dump_batterys.txt
    /system/bin/dumpsys batterystats >> $LOG_DIR/dump_batterys.txt
fi

