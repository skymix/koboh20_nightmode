#! /bin/sh
#by skymix.es@gmail.com
#
#Working on H2O Kobo Ebook Edition 2 Version 2 Mark 7
#Need Kfmon installed and working
#
#Required!
#You need to add to .kobo/Kobo/Kobo eReader.conf the next section:
#[FeatureSettings]
#InvertScreen=true
#This extra section enable the inverse mode (black and white text) on the next reboot.
#The script change the InvertScreen to the other state:
#InvertScreen True = Black Background White Text
#InvertScreen False = White Background Black Text
#We use the nightmode.png icon on the icons directory to launch the script via KFMon
#
# TODO: 
#
#Copyright (C) 2019 Jose Angel Diaz Diaz
# skymix.es@gmail.com 05/2019
# This program is free software: you can redistribute 
#it and/or modify it under the terms of the GNU General 
#Public License as published by the Free Software Foundation,
#either version 3 of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful, 
#but WITHOUT ANY WARRANTY; without even the implied warranty of 
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
#See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public 
#License along with this program. If not, see http://www.gnu.org/licenses/.
#
############################################################################

WORKDIR=$(dirname "$0")
CONFFILE="/mnt/onboard/.kobo/Kobo/Kobo eReader.conf"
cd "$WORKDIR" || exit 1

#Security backup of the Config File
cp "$CONFFILE" "$CONFFILE".bak

#CHeck it Feature Exist is on Config File

if grep -q "InvertScreen" "$CONFFILE" ; then
  echo "Config_ok"
else
  echo  "[FeatureSettings]" >> "$CONFFILE"
  echo  "InvertScreen=false" >> "$CONFFILE"
fi  


#Change the InvertScreen State
if grep -q InvertScreen=false "$CONFFILE"; then
  sed -i 's/InvertScreen=false/InvertScreen=true/g' "$CONFFILE" 
else
  sed -i 's/InvertScreen=true/InvertScreen=false/g' "$CONFFILE"
fi

#Reboot nickel and apply the change 
eval "$(xargs -n 1 -0 < /proc/$(pidof nickel)/environ | grep -E 'INTERFACE|WIFI_MODULE|DBUS_SESSION|NICKEL_HOME|LANG' | sed -e 's/^/export /')"
sync
killall -TERM nickel hindenburg sickel fickel fmon > /dev/null 2>&1

export MODEL_NUMBER=$(cut -f 6 -d ',' /mnt/onboard/.kobo/version | sed -e 's/^[0-]*//')
export LD_LIBRARY_PATH="libs:${LD_LIBRARY_PATH}"


./nickel.sh &
