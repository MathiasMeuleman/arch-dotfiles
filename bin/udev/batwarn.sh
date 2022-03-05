#!/bin/bash
BATTERY=BAT0
LEVEL=$(cat /sys/class/power_supply/$BATTERY/capacity)
notify-send -u critical "Battery low!" "Battery has only $LEVEL% left"
