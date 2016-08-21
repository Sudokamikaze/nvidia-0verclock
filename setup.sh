#!/bin/bash
figlet Nvidia
PWD=$(pwd | grep nvidia-0verclock)
CRDIR=$PWD
NVSTAT=$(optirun nvidia-smi | grep GeForce)
echo "$NVSTAT" | grep -q "GeForce 710M  "
if [ $? -eq 0 ];then
  echo "Your videocard supported!"
else
  echo "Your videocard is not supported :c"
  exit 1
fi
echo ==================================
echo "1. Enable overclocking support"
echo "2. Disable overclocking support"
echo ==================================
echo -n "Current status: "
if grep -q "Coolbits" /etc/bumblebee/xorg.conf.nvidia
then
  echo "Overclocing enabled"
else
  echo "Overclocing disabled"
fi
echo ==================================
echo -n "Choose an action: "
read choise
case "$choise" in
  1) echo "Enabling overclock..."
  cd /etc/bumblebee
  sudo patch < $CRDIR/0verclock.patch
  cd -
  echo "Do you want to open nvidia settings to check overclocking status? [y/n]"
  read check
  if [ $check == "y" ]; then
    optirun nvidia-settings -c :8
  elif [ $check == "Y" ]; then
    optirun nvidia-settings -c :8
  elif [ $check == "n" ]; then
  echo "Done..."
fi
  echo "After this script open your bashrc and customize values becouse there values are default"
  cat settings_bashrc >> ~/.bashrc
  echo "Setting Bumblebee Bridge to primus"
  cd /etc/bumblebee
  sudo patch < $CRDIR/bridge.patch
  cd -
  ;;
  2) echo "Disabling overclock..."
  cd /etc/bumblebee
  sudo patch < $CRDIR/disable_0verclock.patch
  cd -
  echo "Restarting bumblebeed daemon"
  sudo systemctl restart bumblebeed.service
  echo "Done"
  ;;
  *) echo "Unknown symbol, exiting..."
  ;;
esac
