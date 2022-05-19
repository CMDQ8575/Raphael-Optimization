SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=true
print_modname() {
  ui_print "*******************************"
  ui_print "      Raphael Optimization     "
  ui_print "          By：纯梅·锭清          "
  ui_print "*******************************"
}
REPLACE=""
on_install() {
  if [ $API != 28 ]; then
    abort "! Only support Android 9.0"
  fi
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}
set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}
