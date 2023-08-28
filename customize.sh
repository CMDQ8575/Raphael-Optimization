if [ $API != 31 ]; then
  abort "! Only support Android 12"
fi
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive "$MODPATH/system/vendor/lib64" 0 0 0755 0644 u:object_r:vendor_file:s0