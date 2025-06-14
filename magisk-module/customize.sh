#
# fool-proof sanify chks
#

sdk_="$(getprop ro.build.version.sdk)"

if [ "$sdk_" != "35" ]
then
  ui_print "! This module is only tested on Android 15,"
  ui_print "  and it's likely to break on other versions."
fi

device_="$(getprop ro.lineage.device)"

if [ -z "$device_" ]
then
  ui_print "! This module is only tested on LineageOS,"
  ui_print "  and it may break on other ROMs."
fi

path_=/system/fonts

if [ ! -d "$path_" ]
then
  abort "! Cannot find valid directory ${path_}"
fi

xml_=/system/etc/font_fallback.xml

if [ ! -f "$xml_" ]
then
  abort "! Cannot find file ${xml_}"
fi

marker_='</familyset>'

if ! grep -q "$marker_" "$xml_"
then
  abort "! Cannot find text ${marker_} in file ${xml_}"
fi
