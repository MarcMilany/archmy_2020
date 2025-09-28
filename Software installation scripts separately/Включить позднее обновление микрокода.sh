#!/bin/bash
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! ####

clear
echo ""
echo -e "${GREEN}==> ${NC}Включить позднее обновление микрокода для процессора INTEL_CPU, AMD_CPU?"
echo -e "${BLUE}:: ${BOLD}Это позволяет применять обновления микрокода после обновления linux-firmware без перезагрузки системы. ${NC}"
echo -e "${CYAN}:: ${NC}Поздняя загрузка обновления микрокода происходит после запуска системы. Для этого используются файлы в /usr/lib/firmware/amd-ucode/ и /usr/lib/firmware/intel-ucode/."
echo -e "${YELLOW}:: ${NC}Для процессоров AMD файлы обновления микрокода предоставляются пакетом linux-firmware."
echo -e "${YELLOW}:: ${NC}Для процессоров Intel ни один пакет не предоставляет файлы обновления микрокода (FS#59841). Чтобы использовать позднюю загрузку, вам необходимо вручную извлечь intel-ucode/ из предоставленного Intel архива."
echo -e "${RED}=> ${NC}Включение позднего обновления микрокода: - В отличие от ранней загрузки, поздняя загрузка обновлений микрокода в Arch Linux включена по умолчанию, используя /usr/lib/tmpfiles.d/linux-firmware.conf."
echo " После загрузки файл анализируется с помощью systemd-tmpfiles-setup.service(8), а микрокод ЦП обновляется. "
echo -e "${MAGENTA}=> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! Вы можете пропустить это действие. В данной опции выбор всегда остаётся за вами. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да включить,    0 - Нет пропустить: " x_reload  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_reload" =~ [^10] ]]
do
    :
done
 if [[ $x_reload == 0 ]]; then
echo ""
echo " Включение позднего обновления микрокода пропущено " 
elif [[ $x_reload == 1 ]]; then
echo ""
echo " Для ручного обновления микрокода на запущенной системе выполним команду: "
echo " Это позволяет применять обновления микрокода после обновления linux-firmware без перезагрузки системы "
sudo su
echo 1 > /sys/devices/system/cpu/microcode/reload
echo " Автоматизируем этот процесс с помощью хука pacman "
echo " Создадим папку /hooks в директории /etc/pacman.d/ "
mkdir /etc/pacman.d/hooks
echo " Создадим файл microcode_reload.hook в директории /etc/pacman.d/hooks/ "
touch /etc/pacman.d/hooks/microcode_reload.hook
echo " Пропишем нужные нам значения в созданном файле microcode_reload.hook "
> /etc/pacman.d/hooks/microcode_reload.hook
cat <<EOF >>/etc/pacman.d/hooks/microcode_reload.hook 
[Trigger]
Operation = Install
Operation = Upgrade
Operation = Remove
Type = File
Target = usr/lib/firmware/amd-ucode/*   

[Action]
Description = Applying CPU microcode updates...
When = PostTransaction
Depends = sh
Exec = /bin/sh -c 'echo 1 > /sys/devices/system/cpu/microcode/reload'

EOF
# echo " Отключение позднего обновления микрокода "
# Для систем AMD микрокод процессора будет обновляться, даже если пакет amd-ucode не установлен, так как файлы предоставлены linux-firmware (FS#59840). Чтобы отключить позднюю загрузку, вы должны переопределить временные файлы /usr/lib/tmpfiles.d/linux-firmware.conf. Это можно сделать, создав файл с тем же именем в /etc/tmpfiles.d/:
# ln -s /dev/null /etc/tmpfiles.d/linux-firmware.conf
echo " После перезагрузки! Выполните проверку корректности загрузки (обновился ли microcode) установленных микрокодов "
echo " Воспользовавшись командой: - dmesg | grep microcode "
# dmesg | grep microcode
fi
sleep 04
exit




