#!/system/bin/sh
#lock permission
lock() 
{
	if [ -f $2 ]; then
		chmod 0666 $2
		echo $1 > $2
		chmod 0444 $2
	fi
}

#
while [ "$(getprop sys.boot_completed)" != "1" ]
do
 sleep 1
done

#I/O
setenforce 0
echo 0 > /sys/block/loop0/queue/iostats
echo 0 > /sys/block/loop1/queue/iostats
echo 0 > /sys/block/loop2/queue/iostats
echo 0 > /sys/block/loop3/queue/iostats
echo 0 > /sys/block/loop4/queue/iostats
echo 0 > /sys/block/loop5/queue/iostats
echo 0 > /sys/block/loop6/queue/iostats
echo 0 > /sys/block/loop7/queue/iostats
echo 0 > /sys/block/loop0/queue/nomerges
echo 0 > /sys/block/loop1/queue/nomerges
echo 0 > /sys/block/loop2/queue/nomerges
echo 0 > /sys/block/loop3/queue/nomerges
echo 0 > /sys/block/loop4/queue/nomerges
echo 0 > /sys/block/loop5/queue/nomerges
echo 0 > /sys/block/loop6/queue/nomerges
echo 0 > /sys/block/loop7/queue/nomerges
echo 128 > /sys/block/loop0/queue/read_ahead_kb
echo 128 > /sys/block/loop1/queue/read_ahead_kb
echo 128 > /sys/block/loop2/queue/read_ahead_kb
echo 128 > /sys/block/loop3/queue/read_ahead_kb
echo 128 > /sys/block/loop4/queue/read_ahead_kb
echo 128 > /sys/block/loop5/queue/read_ahead_kb
echo 128 > /sys/block/loop6/queue/read_ahead_kb
echo 128 > /sys/block/loop7/queue/read_ahead_kb
echo 0 > /sys/block/sda/queue/iostats
echo 0 > /sys/block/sdb/queue/iostats
echo 0 > /sys/block/sdc/queue/iostats
echo 0 > /sys/block/sdd/queue/iostats
echo 0 > /sys/block/sde/queue/iostats
echo 0 > /sys/block/sdf/queue/iostats
echo 0 > /sys/block/sda/queue/nomerges
echo 0 > /sys/block/sdb/queue/nomerges
echo 0 > /sys/block/sdc/queue/nomerges
echo 0 > /sys/block/sdd/queue/nomerges
echo 0 > /sys/block/sde/queue/nomerges
echo 0 > /sys/block/sdf/queue/nomerges
echo 128 > /sys/block/sda/queue/read_ahead_kb
echo 128 > /sys/block/sdb/queue/read_ahead_kb
echo 128 > /sys/block/sdc/queue/read_ahead_kb
echo 128 > /sys/block/sdd/queue/read_ahead_kb
echo 128 > /sys/block/sde/queue/read_ahead_kb
echo 128 > /sys/block/sdf/queue/read_ahead_kb
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo 0 > /sys/module/subsystem_restart/parameters/enable_ramdumps
echo 0 > /sys/module/subsystem_restart/parameters/enable_mini_ramdumps
echo 3 > /proc/sys/vm/drop_caches
echo 1 > /proc/sys/vm/compact_memory
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
echo 0 > /proc/sys/kernel/sched_schedstats
echo "off" > /proc/sys/kernel/printk_devkmsg

#Disable log
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


#Charging
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

#Governer
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 6 > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
lock "0:0" /sys/module/cpu_boost/parameters/input_boost_freq
lock "0" /sys/module/cpu_boost/parameters/input_boost_ms
lock "0:0" /sys/module/cpu_boost/parameters/powerkey_input_boost_freq
lock "0" /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
lock "N" /sys/module/cpu_boost/parameters/sched_boost_on_powerkey_input
until [ `cat /sys/class/kgsl/kgsl-3d0/devfreq/governor` == "simple_ondemand" ]; do
echo "simple_ondemand" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
done

#Frequency
echo 585000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo 1036800 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo 2016000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
echo 2419200 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_load
echo 710400 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_load
echo 825600 > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_freq
echo 100 > /sys/devices/system/cpu/cpu7/cpufreq/schedutil/hispeed_load
echo 762 > /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/max_freq
echo 2288 > /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/max_freq
echo 762 > /sys/class/devfreq/soc:qcom,gpubw/max_freq

#Speed
cmd package compile -m speed -a
fstrim -v /data
fstrim -v /cache
fstrim -v /system
fstrim -v /vendor