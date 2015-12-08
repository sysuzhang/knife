#!/bin/sh
function_meminfo()
{
     echo "==========Memory Detail Infomation==============="
     hdinfo=`dmidecode -t memory | egrep "Memory Device|Data Width|Size|Locator|Type|Type Detail|Speed|Manufacturer|Configured Clock Speed" | egrep -v "Bank Locator|Unknown|\[Empty\]"`
     echo "$hdinfo"
     echo "==================Summary========================"
     info=`dmidecode|grep -P -A5 "Memory\s+Device"|egrep Size|grep -v Range`
     echo "$info"
     echo "================================================="
}
case $1 in
   meminfo)
        function_meminfo
        ;;
   *)
       printf "Usage hds{meminfo}\n"
esac
