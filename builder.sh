#!/bin/bash

# Syntax: 
# ./builder.sh yourdevicecodename
# Example:
# ./builder.sh capricorn

if [ $1 ]
then
 
echo "Building for $1"
KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel3
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Havoc"
DEVICE="$1"
VER="testing"
FINAL_ZIP="$KERNEL_NAME-$DEVICE-$DATE-$VER".zip

if [ -e $ANYKERNEL_DIR/Image.gz-dtb ]
then
rm $ANYKERNEL_DIR/Image.gz-dtb
fi

if [ -e $KERNEL_DIR/arch/arm64/boot/Image.gz ]
then
rm $KERNEL_DIR/arch/arm64/boot/Image.gz 
fi

if [ -e $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb ]
then
rm $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
fi

# export CROSS_COMPILE=~/kernel/linaro-64-dev/bin/aarch64-linux-gnu-

make clean mrproper
make $1_defconfig
make -j3

{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/
} || {
  if [ $? != 0 ]; then
    echo Noooope
    exit
  fi
}

cd $ANYKERNEL_DIR/
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
mv $FINAL_ZIP $KERNEL_DIR/../builds/$FINAL_ZIP


else
echo "You should specify codename of the your device"
fi

