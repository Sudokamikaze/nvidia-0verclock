#!/bin/bash

function checkenabled {
  case "$choise" in
  0)
  if grep -q "Coolbits" /etc/bumblebee/xorg.conf.nvidia
  then
    echo "Overclocing enabled"
  else
    echo "Overclocing disabled"
  fi
  ;;
  1)
  if grep -q "Coolbits" /etc/bumblebee/xorg.conf.nvidia
  then
    echo "Overclocing is already enabled. Exiting..."
  else
    echo " "
  fi
  ;;
esac
}

function checknvidia {
  NVSTAT=$(optirun nvidia-smi | grep GeForce)
  echo "$NVSTAT" | grep -q "GeForce 710M  "
  if [ $? -eq 0 ];then
    echo "Your videocard supported!"
  else
    echo "Your videocard is not supported :c"
    exit 1
  fi
}

figlet Nvidia
PWD=$(pwd | grep nvidia-0verclock)
CRDIR=$PWD
checknvidia
echo ==================================
echo "1. Enable overclocking support"
echo "2. Disable overclocking support"
echo ==================================
echo -n "Current status: "
choise=0
checkenabled
echo ==================================
echo -n "Choose an action: "
read choise
case "$choise" in
  1) checkenabled
  echo "Enabling overclock..."
  cd /etc/bumblebee
  sudo patch < $CRDIR/0verclock.patch
  cd -
  echo "After this script open your bashrc and customize values becouse there values are default"
  cat settings_bashrc >> ~/.bashrc
  eval $(grep Bridge= /etc/bumblebee/bumblebee.conf)
  if [ $Bridge == auto ]; then
  echo "Setting Bumblebee Bridge to primus"
  sudo find /etc/bumblebee -name bumblebee.conf -exec sed -i "s/Bridge=auto/Bridge=primus/g" {} \;
else
  echo "Bridge set to primus already."
fi
  ;;
  2) echo "Disabling overclock..."
  sudo sed -i '/Option "Coolbits" "8"/d' /etc/bumblebee/xorg.conf.nvidia
  echo "Restarting bumblebeed daemon"
  sudo systemctl restart bumblebeed.service
  echo "Done"
  ;;
  *) echo "Unknown symbol, exiting..."
  ;;
esac
