#!/bin/sh
PASS='0'
cp /etc/sdc/* /home/root
mv /home/root/SE05x-MW-v04.03.01.zip.txt /home/root/SE05x-MW-v04.03.01.zip
mv /home/root/UWBIOT_SR150_v04.06.00_libuwbd.zip.txt /home/root/UWBIOT_SR150_v04.06.00_libuwbd.zip
mv /home/root/UWBIOT_SR150_v04.06.00_Linux.zip.txt /home/root/UWBIOT_SR150_v04.06.00_Linux.zip
mv /home/root/bin.zip.txt /home/root/bin.zip
mv /home/root/uwb.zip.txt /home/root/uwb.zip
mv /home/root/uwb-se.zip.txt /home/root/uwb-se.zip
mv /home/root/bluetooth.service /lib/systemd/system/
cd /home/root/
unzip -o bin.zip
unzip -o uwb.zip
mkdir /usr/local
unzip -o uwb-se.zip -d /usr/local
# python3 simw-top/scripts/create_cmake_projects.py
# cd /home/root/simw-top_build/imx_native_se050_t1oi2c
# cmake --build .
# make install
# clean up
rm /home/root/*.zip


ldconfig /usr/local/lib

ex_ecc "/dev/i2c-2:0x48"

ldconfig /usr/local/uwbiot/lib/

cd /home/root/

echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ###Secure element test complete.                                ### \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p "Did the Secure Element test pass? (y/n)" SECURE
if [ "${SECURE,,}" == "y" ]
then
	PASS=$(($PASS + 1))
	echo -e "\e[1;33m ################################################################### \e[0m"
	echo -e "\e[1;33m ###Number of tests passed so far $PASS                          ### \e[0m"
	echo -e "\e[1;33m ################################################################### \e[0m"
fi

# Load the UWB driver
modprobe nxp-sr1xx

cd /home/root
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ##testing microphones on HoneyPot board - Say something!         ## \e[0m"
echo -e "\e[1;33m ## Press <enter>to continue                                      ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p " "
arecord -D hw:2,0 -f S32_LE -d 3 sample.wav
arecord -D hw:3,0 -f S32_LE -d 3 sample.wav
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ##Playing back the recorded audio                                ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
aplay ./sample.wav
read -p "Did you hear the recorded audio playing back? (y/n)" MICS
if [ "${MICS,,}" == "y" ]
then
	PASS=$(($PASS + 1))
	echo -e "\e[1;33m ################################################################### \e[0m"
	echo -e "\e[1;33m ###Number of tests passed so far $PASS                          ### \e[0m"
	echo -e "\e[1;33m ################################################################### \e[0m"

fi
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ##Playing back sample audio                                      ## \e[0m"
echo -e "\e[1;33m ##Press <enter>to continue                                       ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p " "
aplay -d 1 /home/root/Moldova.wav
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ## launching the camera test - please note:                      ## \e[0m"
echo -e "\e[1;33m ## if using the raspi V2 camera - please ensure that the proper  ## \e[0m"
echo -e "\e[1;33m ## device tree file is set in u-boot and the camera is connected ## \e[0m"
echo -e "\e[1;33m ## to use the IMX219 Module, in u-boot execute:                  ## \e[0m"
echo -e "\e[1;33m ## $ setenv fdtfile imx8mp-ddr4-evk-imx219.dtb                   ## \e[0m"
echo -e "\e[1;33m ## $ saveenv                                                     ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p "is the OV5640 camera module connected? (y/n)" OV5640
if [ "${OV5640,,}" == "y" ]
then
	gst-launch-1.0 v4l2src device=/dev/video3 num-buffers=150 ! waylandsink sync=false &
else
	read -p "is the RasPi V2 (IMX219) camera module connected? (y/n)" IMX219
	if [ "${IMX219,,}" == "y" ]
	then
		gst-launch-1.0 v4l2src device=/dev/video2 num-buffers=150 ! waylandsink sync=false &
	else
		gst-launch-1.0 videotestsrc num-buffers=150 ! waylandsink sync=false &
	fi
fi

sleep 10
killall gst-launch-1.0
read -p "Did the Camera test pass? (y/n)" CAMERA
if [ "${CAMERA,,}" == "y" ]
then
	PASS=$(($PASS + 1))   
	echo -e "\e[1;33m ################################################################### \e[0m"
	echo -e "\e[1;33m ###Number of tests passed so far $PASS                              ### \e[0m"
	echo -e "\e[1;33m ################################################################### \e[0m"
fi

read -p "Please enter the WiFi SSID:" SSID
read -p "please enter the WiFi Password:" PASSWORD
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ##About to connect to the following WiFi network:                ## \e[0m"
echo -e "\e[1;33m ##SSID=$SSID Password=$PASSWORD                        ## \e[0m"
echo -e "\e[1;33m ##Press <enter>to continue                                       ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p " "
wpa_passphrase $SSID $PASSWORD > /etc/wpa_supplicant.conf
echo
echo
echo

source /home/root/wifi-bt.sh
sleep 1
echo
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ##Did the WiFi test pass (y/n)?                                  ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo

read -p "Did the WiFi test pass (y/n)? " WIFI
if [ "${WIFI,,}" == "y" ]
then
	echo -e "\e[1;33m PASS=$PASS \e[0m"
	PASS=$(($PASS + 1))
	echo -e "\e[1;33m ################################################################### \e[0m"
	echo -e "\e[1;33m ###Number of tests passed so far $PASS                              ### \e[0m"
	echo -e "\e[1;33m ################################################################### \e[0m"
fi
echo
echo
echo
echo -e "\e[1;33m ################################################################### \e[0m"
echo -e "\e[1;33m ## Launching the UWB test application                            ## \e[0m"
echo -e "\e[1;33m ## Press <enter>to continue                                      ## \e[0m"
echo -e "\e[1;33m ################################################################### \e[0m"
echo
echo
echo
read -p "  "
/home/root/bin/demo_ranging_controlee &
sleep 10
killall demo_ranging_controlee
read -p "Did the UWB test pass (y/n)? " UWB
if [ "${UWB,,}" == "y" ]
then
	PASS=$(($PASS + 1))
	echo -e "\e[1;33m ################################################################### \e[0m"
	echo -e "\e[1;33m ###Number of tests passed so far $PASS                              ### \e[0m"
	echo -e "\e[1;33m ################################################################### \e[0m"
fi

if [ "${PASS,,}" == "5" ]
then
	echo
	echo
	echo
	echo -e "\e[1;32m ################################################################### \e[0m"
	echo -e "\e[1;32m ## All Tests have passed!                                        ## \e[0m"
	echo -e "\e[1;32m ## Secure element test passed:  $SECURE                                ## \e[0m"
	echo -e "\e[1;32m ## Mic and Speaker test passed: $MICS                                ## \e[0m"
	echo -e "\e[1;32m ## camera tests passed:         $CAMERA                                ## \e[0m"
	echo -e "\e[1;32m ## Wi-Fi module test passed:    $WIFI                                ## \e[0m"
	echo -e "\e[1;32m ## UWB test passed:             $UWB                                ## \e[0m"
	echo -e "\e[1;32m ################################################################### \e[0m"
	echo
	echo
	echo
else 
	echo
	echo
	echo
	echo -e "\e[1;31m ################################################################### \e[0m"
	echo -e "\e[1;31m ## ERROR: Not All Tests have passed!                             ## \e[0m"
	echo -e "\e[1;31m ## number of tests passed:      $PASS                                ## \e[0m"
	echo -e "\e[1;31m ## Secure element test passed:  $SECURE                                ## \e[0m"
	echo -e "\e[1;31m ## Mic and Speaker test passed: $MICS                                ## \e[0m"
	echo -e "\e[1;31m ## camera tests passed:         $CAMERA                                ## \e[0m"
	echo -e "\e[1;31m ## Wi-Fi module test passed:    $WIFI                                ## \e[0m"
	echo -e "\e[1;32m ## UWB test passed:             $UWB                                ## \e[0m"
	echo -e "\e[1;31m ################################################################### \e[0m"
	echo
	echo
	echo
fi



