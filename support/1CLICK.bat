@echo OFF
rem qemu-system-i386 ../TH/xiaOS.img
rem pause
gcc -nostdlib -masm=intel ../src/main.c -o ../TH/main.exe
nasm -f bin ../src/code.asm -o ../TH/code.bin
objcopy ../TH/main.exe -O binary
rem for %%I in (../TH/code.bin) do echo %%~zI
rem plus.py
cd makefiles
makeimg ../../TH/code.bin ../../TH/main.exe ../../src/image.img
cd ..
qemu-system-i386 ../TH/xiaOS.img
rem qemu-system-i386 -d out_asm -D ../log/qemu.log ../TH/res.bin
pause