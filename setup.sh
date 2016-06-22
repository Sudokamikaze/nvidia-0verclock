#!/bin/bash
figlet Nvidia
PWD=$(pwd)
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
  sudo patch < ./$PWD/0verclock.patch
  cd -
  echo "Do you want to open nvidia settings to check overclocking support? [y/n]"
  read check
  if [ $check == y ]; then
    optirun nvidia-settings -c :8
  elif [ $check == n ]; then
  echo "Done..."
fi
  echo "After this script open your bashrc and customize values becouse there values for 710m"
  cat settings_bashrc >> ~/.bashrc
  echo "Setting Bumblebee Bridge to primus"
  cd /etc/bumblebee
  sudo patch < ./$PWD/disable_0verclock.patch
  cd -
  ;;
  2) echo "Disabling overclock..."
  cd /etc/bumblebee
  sudo patch < ./$PWD/bridge.patch
  cd -
  echo "Restarting bumblebeed daemon"
  sudo systemctl restart bumblebeed.service 
  echo "Done"
  ;;
  *) echo "Unknown symbol, exiting..."
  ;;
esac
