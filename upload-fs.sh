#!/bin/bash
cd bin/realtek
echo -e "binary\nput openwrt-realtek-rtl8196c-nprove-squashfs.bin" | tftp 192.168.1.6
