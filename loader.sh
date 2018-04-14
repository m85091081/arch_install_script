#!/bin/bash
function buildscript(){
    echo "    exit" >> arch.sh 
    echo "}" >> arch.sh 
    echo "if [ \$# != 0 ] && [ "\$1" == "--config" ]; then" >> arch.sh
    echo "    hostname=\$2" >> arch.sh
    echo "    username=\$3" >> arch.sh 
    echo "    password=\$4" >> arch.sh
    echo "    step2;" >> arch.sh 
    echo "else" >> arch.sh 
    echo "    step1;" >> arch.sh 
    echo "fi"
}

function uefi(){
    curl -fsSL https://raw.githubusercontent.com/m85091081/arch_install_script/master/arch.part > arch.sh 
    buildscript;
    echo "    echo 'Configure Grub-UEFI:'">> arch.sh 
    echo "    pacman -Sy --noconfirm grub efibootmgr os-prober"
    echo "    grub-install -target=x86_64-efi --efi-directory=/boot --bootloader-id=grub ">> arch.sh 
    echo "    grub-mkconfig -o /boot/grub/grub.cfg" >> arch.sh
    buildscript;
    chmod +x arch.sh 
    ./arch.sh 
}

function bios(){
    curl -fsSL https://raw.githubusercontent.com/m85091081/arch_install_script/master/arch.part > arch.sh 
    echo "    echo 'Configure Grub-BIOS:'">> arch.sh 
    echo "    pacman -Sy --noconfirm grub-bios os-prober"
    echo "    grub-install --target=i386-pc --recheck --debug /dev/sda">> arch.sh 
    echo "    grub-mkconfig -o /boot/grub/grub.cfg" >> arch.sh
    buildscript;
    chmod +x arch.sh 
    ./arch.sh
}

echo "==archlinux install script loader =="
echo "==Please choose verison to install"
echo "1.UEFI Mode"
echo "2.BIOS Mode"
echo "0.End"
echo "==archlinux install script loader =="
read -p ": " choose

if [[ "$choose" =~ ^[0-2]+$ ]]; then
    if [[ "$choose" == 1 ]]; then
        uefi;
    elif [[ "$choose" == 2 ]]; then
        bios;
    elif [[ "$choose" == 0 ]]; then
        exit
    fi 
fi
