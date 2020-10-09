@echo OFF
echo %PATH% > path.backup
rem setx path "%PATH%;C:\путь\к\директории\"
setx path "%PATH%;C:\NASM;C:\MinGW\bin;C:\qemu"
pause
