#!/usr/bin/env bash
# Install script prog_cpu
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget git.io/prog_cpu.sh && sh prog_cpu.sh

echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo ""
echo -e "${BLUE}:: ${NC}Проверим корректность загрузки установленных микрокодов "
#echo " Давайте проверим, правильно ли загружен установленный микрокод "
# Let's check whether the installed microcode is loaded correctly
echo -e "${MAGENTA}=> ${NC}Если таковые (микрокод-ы: amd-ucode; intel-ucode) были установлены! "
echo " Если микрокод был успешно загружен, Вы увидите несколько сообщений об этом "
echo " Будьте внимательны! Вы можете пропустить это действие. "
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Да проверим корректность загрузки,    0 - Нет пропустить: " x_ucode  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$x_ucode" =~ [^10] ]]
do
    :
done
if [[ $x_ucode == 0 ]]; then
  echo ""
  echo " Проверка пропущена "
elif [[ $x_ucode == 1 ]]; then
  echo ""
  echo " Выполним проверку корректности загрузки установленных микрокодов "
  sudo dmesg | grep microcode
# dmesg | grep microcode
fi
sleep 04
###
#clear
echo ""
echo -e "${GREEN}==> ${NC}Установить Микрокод для процессора INTEL_CPU, AMD_CPU?"
echo -e "${BLUE}:: ${BOLD}Обновление Microcode (matching CPU) ${NC}"
echo -e "${BLUE}:: ${BOLD}Процессор — уникальный идентификационный номер каждого процессора, начиная с 0.
название модели — полное название процессора, включая марку процессора. После того, как вы точно узнаете, какой у вас тип ЦП, вы можете проверить в документации по продукту технические характеристики вашего процессора. ${NC}"
echo " Производители процессоров выпускают обновления стабильности и безопасности
        для микрокода процессора "
echo " Огласите весь список, пожалуйста! :) "
echo " 1 - Для процессоров AMD установите пакет amd-ucode . "
echo " 2 - Для процессоров Intel установите пакет intel-ucode . "
echo " 3 - Если Arch находится на съемном носителе, Вы должны установить микрокод для обоих производителей процессоров!!! "
echo -e "${GREEN}==> ${BOLD}Вот ВАШ процессор (название модели — полное название процессора),включая количество процессоров:${NC}"
grep -m 1 'model name' /proc/cpuinfo  # model name
# lscpu | grep -i 'Model name'  # BIOS Model name
# lscpu | grep -i "Model name:" | cut -d':' -f2- -   # model name
grep -c 'model name' /proc/cpuinfo  # распечатать количество процессоров
# lscpu | grep -i "CPU(s)"  # сведения о ЦП, например количество ядер ЦП
echo -e "${BLUE}:: ${BOLD} Для Arch Linux на съемном носителе добавьте оба файла initrd в настройки загрузчика!${NC}"
echo " Их порядок не имеет значения, если они оба указаны до реального образа initramfs. "
echo -e "${MAGENTA}=> ${NC}Вы можете пропустить этот шаг, если не уверены в правильности выбора"
echo " Будьте внимательны! Без этих обновлений Вы можете наблюдать ложные падения или неожиданные зависания системы, которые может быть сложно отследить. "
echo -e "${YELLOW}==> ${NC}Установка производится в порядке перечисления"
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "
    1 - Для процессоров AMD,    2 - Для процессоров INTEL,

    3 - Для процессоров AMD и INTEL,

    0 - Нет Пропустить этот шаг: " prog_cpu  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$prog_cpu" =~ [^1230] ]]
do
    :
done
if [[ $prog_cpu == 0 ]]; then
  echo ""
  echo " Установка микрокода процессоров пропущена "
elif [[ $prog_cpu == 1 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - AMD "
  sudo pacman -S amd-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - AMD "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
  sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
  sudo update-initramfs -u
elif [[ $prog_cpu == 2 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - INTEL "
  sudo pacman -S intel-ucode --noconfirm  # Образ обновления микрокода для процессоров INTEL
  sudo pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
  echo " Установлены обновления стабильности и безопасности для микрокода процессора - INTEL "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
  sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
  sudo update-initramfs -u
elif [[ $prog_cpu == 3 ]]; then
  echo ""
  echo " Устанавливаем uCode для процессоров - AMD и INTEL "
  sudo pacman -S amd-ucode intel-ucode --noconfirm  # Образ обновления микрокода для процессоров AMD и INTEL
  sudo pacman -S iucode-tool --noconfirm  # Инструмент для управления пакетами микрокода Intel® IA-32 / X86-64
  echo " Установлены обновления стабильности и безопасности для микрокода процессоров - AMD и INTEL "
  echo " После завершения установки пакета программного обеспечения нужно перезагрузить компьютер "
  echo ""
  echo -e "${BLUE}:: ${NC}Обновляем grub.cfg (Сгенерируем grub.cfg)"
  sudo grub-mkconfig -o /boot/grub/grub.cfg   # создаём конфигурационный файл
  echo ""
  echo -e "${BLUE}:: ${NC}Воссоздайте загрузочный RAM диск (initramfs)"
fi
###########
sleep 2

clear
echo -e "${GREEN}
  <<< Поздравляем! Установка завершена. Перезагрузите систему. >>>
${NC}"
echo -e "${BLUE}:: ${BOLD}Посмотрим дату и время ... ${NC}"
date
date +'%d/%m/%Y  %H:%M:%S [%:z  %Z]'    # одновременно отображает дату и часовой пояс
echo -e "${BLUE}:: ${BOLD}Отобразить время работы системы ... ${NC}"
uptime
echo -e "${MAGENTA}==> ${BOLD}После перезагрузки и входа в систему проверьте ваши персональные настройки. ${NC}"
echo -e "${CYAN}:: ${NC}Скриптом можно пользоваться как шпаргалкой, открыв его в текстовом редакторе, копируя команды по установке необходимых пакетов, и запуска служб."
echo -e "${GREEN}
  <<< Желаю Вам удачи во всех начинаниях, верных и точных решений! >>> ${NC}"
echo ""
echo -e "${RED}### ${BLUE}########################################################### ${RED}### ${NC}"
echo -e "${RED}==> ${BOLD}Выходим из установленной системы ${NC}"
echo -e "${BLUE}:: ${BOLD}Теперь вам надо ввести (exit) reboot, чтобы перезагрузиться ${NC}"
sleep 03
exit
exit

### end of script

# <<< Делайте выводы сами! >>>

