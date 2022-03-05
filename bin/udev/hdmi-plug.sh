#!/usr/bin/bash
exec 3>&1 1>>${hdmiplug.log} 2>&1

OUTPUTS=$(swaymsg -t get_outputs)
echo $(echo $OUTPUTS | jq '.[0]')
NAMES=$(echo $OUTPUTS | jq '.[] | {name: .name, current_mode: .current_mode}')
echo $NAMES
swaymsg 'output HDMI-A-1 disable'
swaymsg 'output HDMI-A-1 enable'
