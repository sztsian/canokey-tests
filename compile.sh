#!/bin/bash
pushd /home/zsun/canokeys/canokey-stm32

git reset --hard HEAD
git pull --rebase
git submodule update --init --recursive
rm -rf build
mkdir build
cd build
cmake -DCROSS_COMPILE=/home/zsun/canokeys/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi- -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DCMAKE_BUILD_TYPE=Release .. && make canokey.bin

../enter-dfu.sh "Kingtrust Multi-Reader [OpenPGP PIV OATH] (00000000) 00 00"


sudo ../../dfu-util/src/dfu-util -l

sudo ../../dfu-util/src/dfu-util -i 0 -a 0 -D canokey.bin -s 0x08000000

openocd -f interface/stlink-v2-1.cfg -f target/stm32l4x.cfg & 

sleep 3

echo "reset; shutdown" | nc 127.0.0.1 4444

popd
