#!/bin/bash

#file_path="$HOME/.config/hypr/settings/monitors.conf"

# Comment Enable Monitor
#sed -i 's/^#monitor=desc:Dell Inc. DELL P2210 W466K95C596S,1680x1050@60.883,0x0,1.0/Monitor 1 Main/' "$file_path"
#sed -i 's/^#monitor=desc:Hewlett Packard HP w1907 CNN72236DL,1440x900@60.887,1680x150,1.0/Monitor 2/' "$file_path"

# #Uncomment Disable Monitor
#sed -i 's/^monitor=desc:Dell Inc. DELL P2210 W466K95C596S,disable/#monitor=desc:Dell Inc. DELL P2210 W466K95C596S,disable/' "$file_path"
#sed -i 's/^monitor=desc:Hewlett Packard HP w1907 CNN72236DL,disable/#monitor=desc:Hewlett Packard HP w1907 CNN72236DL,disable/' "$file_path"
#hyprctl reload

# Disable Display Managers
systemctl stop sddm.service

# Unload GPU
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia


