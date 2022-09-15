#!/system/bin/sh

# Lock Permission
lock() 
{
	if [ -f $2 ]; then
		chmod 0666 $2
		echo $1 > $2
		chmod 0444 $2
	fi
}

while [ "$(getprop sys.boot_completed)" != "1" ]
do
 sleep 1
done

# Color
echo 256 230 256 > /sys/devices/platform/kcal_ctrl.0/kcal

# I/O
for i in loop0 loop1 loop2 loop3 loop4 loop5 loop6 loop7 sda sdb sdc sdd sde sdf
do
   echo 0 > "/sys/block/${i}/queue/nomerges"
done
echo 0 > /sys/module/subsystem_restart/parameters/enable_ramdumps
echo 0 > /sys/module/subsystem_restart/parameters/enable_mini_ramdumps
echo 3 > /proc/sys/vm/drop_caches
echo 1 > /proc/sys/vm/compact_memory
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
echo 0 > /proc/sys/kernel/sched_schedstats
echo "off" > /proc/sys/kernel/printk_devkmsg

# Disable log
stop cnss_diag
stop tcpdump
am kill mdnsd
killall -9 mdnsd
am kill mdnsd.rc
killall -9 mdnsd.rc
am kill logd
killall -9 logd
am kill logd.rc
killall -9 logd.rc
stop logd 2> /dev/null
killall -9 logd 2> /dev/null
stop logd.rc 2> /dev/null
killall -9 logd.rc 2> /dev/null
am kill tcpdump
killall -9 tcpdump
am kill cnss_diag
killall -9 cnss_diag
stop cnss_diag 2> /dev/null
killall -9 cnss_diag 2> /dev/null
stop tcpdump 2> /dev/null
killall -9 tcpdump 2> /dev/null
echo 0 > /sys/module/binder/parameters/debug_mask
echo 0 > /sys/module/binder_alloc/parameters/debug_mask
echo 0 > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "N" > /sys/kernel/debug/debug_enabled

# Charging
chmod 0644 /sys/class/power_supply/battery/charge_full
chmod 0644 /sys/class/power_supply/main/constant_charge_current_max
chmod 0644 /sys/class/power_supply/main/current_max
chmod 0644 /sys/class/power_supply/usb/current_max
chmod 0644 /sys/class/power_supply/usb/pd_current_max
chmod 0644 /sys/class/power_supply/battery/constant_charge_current_max
chmod 0644 /sys/class/power_supply/usb/boost_current
chmod 0644 /sys/class/power_supply/usb/boost_current
echo 0 > /sys/class/power_supply/battery/step_charging_enabled
echo 1 > /sys/class/power_supply/usb/boost_current
# echo 4200000 > /sys/class/power_supply/battery/charge_full

# Governer
echo 1 > /sys/module/thermal_sys/parameters/skip_therm
echo 105000 > /sys/class/thermal/thermal_zone32/trip_point_0_temp
lock "0:0" /sys/module/cpu_boost/parameters/input_boost_freq
lock "0" /sys/module/cpu_boost/parameters/input_boost_ms
lock "0:0" /sys/module/cpu_boost/parameters/powerkey_input_boost_freq
lock "0" /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
lock "N" /sys/module/cpu_boost/parameters/sched_boost_on_powerkey_input

# Frequency
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 345000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo 1036000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 2016000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
#echo 2419200 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load
echo 710400 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_load
echo 825600 > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_load
echo 762 > /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/max_freq
echo 2288 > /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/max_freq

# Speed
# cmd package compile -m speed -a
fstrim -v /data
fstrim -v /cache
fstrim -v /system
fstrim -v /vendor