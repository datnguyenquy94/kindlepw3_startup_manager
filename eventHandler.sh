#!/bin/sh
# eventHandler 0.2 by dos
# http://dosowisko.net/
# GPLv3+

mkdir -p /mnt/us/scripts/startup /mnt/us/scripts/suspend /mnt/us/scripts/resume
cp -r /mnt/us/scripts /tmp/root/
chmod 755 -R /tmp/root/scripts

execute() {
  echo $1
  for file in /tmp/root/scripts/$1/*; do
    if [[ -f "$file" -a "${file##*.}" = "sh" ]]; then
      echo "... $file"
      $file &
    fi
  done
}

execute startup

lipc-wait-event -m com.lab126.powerd goingToScreenSaver,outOfScreenSaver | while read event; do
  case "$event" in
    goingToScreenSaver*)
      execute suspend;;
    outOfScreenSaver*)
      execute resume;
 esac
done;
