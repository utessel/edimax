Disclaimer
----------

This is just a documentation what I did. 
I will not do any support for that device!

Most of the code is originally from openwrt:
The repository is based on the git found here:

http://git.advem.lv/

The discussion about the chipset etc is found here 

https://forum.openwrt.org/viewtopic.php?id=46606

Special thanks to Tomate for the hints I got to make this working.


Openwrt on Edimax 3G-6200nL V2
------------------------------

Steps:

1) clone this repository

My config-file is stored as `myconfig`: You can copy that to `.config`:
then you have a good start for menuconfig.
(I have a few USB things inside that config, so I expect you will modify
yours, but maybe you should first try to compile without real changes!)

I have installed `ddserver`:

        git clone git://github.com/hubaiz/DslrDashboardServer package/DslrDashboardServer

You might want to install luci (not in this repository)

        ./scripts/feeds update
        ./scripts/feeds install -a -p luci

Then you can create the image with

        make

When that is done, you will have the firmware files here:

        bin/realtek/openwrt-realtek-rtl8196c-nprove-squashfs.bin
        bin/realtek/openwrt-realtek-rtl8196c-nprove-kernel.bin

Now you can upload the firmware to your router:

2) Bring the router into its bootloader:

For this simply press the button and connect power. Now hold the button
for some time (5-10 seconds). When the LED next to the button goes off,
it is ok.

3) Allow your Linux machine to send to the fixed IP of the router:

        sudo route add -host 192.168.1.6 eth0

4) enter the directory with your generated images:

        cd bin/realtek/

5) tftp the files to the router:

        tftp 192.168.1.6
        binary
        put openwrt-realtek-rtl8196c-nprove-squashfs.bin

Now you have to wait: this will take some time, because first the image is
uploaded to RAM: TFTP will say its done then. But now (on the device) the the checksum is 
checked and the real flashing starts: This takes more time than the tftp transfer! 
So wait about 1-2 Minutes.

6) Now you put the new kernel to the device: still in tftp

        put openwrt-realtek-rtl8196c-nprove-kernel.bin

and wait again!
This time the router you get a feedback: the router will reboot when the flashing is done and your new image will be started.
It will take some time, but finally the LED next to the button will light up. 

7) you can login on your router now:

        telnet 192.168.1.1

or with your browser if you have luci:

        http://192.168.1.1


Note:
Sometimes, my router did not load the kernel in the second step of the tftp
upload: Without a serial console you won'' get any feedback here, maybe a
tftp timeout. At least on my device I had to reboot it to upload the kernel:
so press the button and disconnect and reconnect the power. 
You don''t have to leave tftp for that.


Serial Console
--------------

The device has four pads, on the side with the USB connector, next to
the capacitor. You can connect a 3.3V USB to TTL converter to these
pins.
The router uses 38400 Baud.

GPIO Pins
---------

GPIO2, 13 and 14 can control the LEDs on the side

GPIO5 is connected to the button

GPIO6 controls the USB Power

GPIO16 control the LED between USB and the button

To control all LEDs, one has to write `0x343FC0` to `/sys/module/gpio_rtl819x/parameters/rtl819x_mux`
Have a look to the datasheet of RTL8196C for more details of that MUX Register.


