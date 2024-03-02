#!/bin/bash

# Load GPU
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia

# Enable display managers
sleep 1
systemctl start sddm.service

#file_path="$HOME/.config/hypr/settings/monitors.conf"

# Comment Disable Monitor
#sed -i 's/^monitor=desc:Dell Inc. DELL P2210 W466K95C596S,1680x1050@60.883,0x0,1.0/#monitor=desc:Dell Inc. DELL P2210 W466K95C596S,1680x1050@60.883,0x0,1.0/' "$file_path"
#sed -i 's/^monitor=desc:Hewlett Packard HP w1907 CNN72236DL,1440x900@60.887,1680x150,1.0/#monitor=desc:Hewlett Packard HP w1907 CNN72236DL,1440x900@60.887,1680x150,1.0/' "$file_path"

## Uncomment Enable Monitor
#sed -i 's/^#monitor=desc:Dell Inc. DELL P2210 W466K95C596S,disable/monitor=desc:Dell Inc. DELL P2210 W466K95C596S,disable/' "$file_path"
#sed -i 's/^#monitor=desc:Hewlett Packard HP w1907 CNN72236DL,disable/monitor=desc:Hewlett Packard HP w1907 CNN72236DL,disable/' "$file_path"

