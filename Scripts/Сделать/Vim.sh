#!/usr/bin/env bash
# Install script Vim
# autor: Marc Milany 
# baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
# wget 
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 
apptitle="Arch Linux Fast Install v2.4 LegasyBIOS - Version: 2024.07.31.00.40.38 (GPLv3)"
baseurl=https://raw.githubusercontent.com/MarcMilany/archmy_2020/master/url%20links%20abbreviated/git%20url
cpl=0
skipfont="0"
fspkgs=""
EDITOR=nano
#EDITOR=nano visudo  # Выполните команду с правами суперпользователя

VIM_LANG="russian"  # Installer default language (Язык установки по умолчанию)

script_path=$(readlink -f ${0%/*})

umask 0022 # Определение окончательных прав доступа
# Для суперпользователя (root) umask по умолчанию равна 0022

##################################################################

set -e "\n${RED}Error: ${YELLOW}${*}${NC}"  # Эта команда остановит выполнение сценария после сбоя команды и будет отправлен код ошибки
 
###################################################################

### Help and usage (--help or -h) (Справка)
_help() {
    echo -e "${BLUE}
Installation guide - Arch Wiki
${BOLD}For more information, see the wiki: \
${GREY}<https://wiki.archlinux.org/index.php/Installation_guide>${NC}"
}

### SHARED VARIABLES AND FUNCTIONS (ОБЩИЕ ПЕРЕМЕННЫЕ И ФУНКЦИИ)
### Shell color codes (Цветовые коды оболочки)
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"; GREY="\e[3;93m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; BOLD="\e[1;37m"; MAGENTA="\e[1;35m"; NC="\e[0m"

### Automatic error detection (Автоматическое обнаружение ошибок)
_set() {
    set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
}

_set() {
    set -e "\n${RED}Error: ${YELLOW}${*}${NC}"
    _note "${MSG_ERROR}"
    sleep 1; $$
}

### Display install steps (Отображение шагов установки)
_info() {
    echo -e "${YELLOW}\n==> ${CYAN}${1}...${NC}"; sleep 1
}
  
### Download show progress bar only (Скачать показывать только индикатор выполнения)
_wget() {
    wget "${1}" --quiet --show-progress
}
###############

echo ""
echo -e "${BLUE}:: ${NC}Установка и настройка начата в $(date +%T)" 
#echo "Установка и настройка начата в $(date +%T)"
# Installation and configuration started in $(date +%T)
echo ""
echo -e "${GREEN}=> ${NC}Для проверки интернета можно пропинговать какой-либо сервис"
echo -e "${MAGENTA}==> ${BOLD}Если у Вас беспроводное соединение, запустите nmtui (Network Manager Text User Interface) и подключитесь к сети. ${NC}"
#echo 'Для проверки интернета можно пропинговать какой-либо сервис'
# To check the Internet, you can ping a service
ping -c2 archlinux.org  # Утилита ping - это очень простой инструмент для диагностики сети
#ping google.com -W 2 -c 1

echo -e "${CYAN}==> ${NC}Если пинг идёт едем дальше ... :)"
#echo 'Если пинг идёт едем дальше ... :)'
# If the ping goes we go further ... :)
sleep 03

echo ""    
echo " Обновим базы данных пакетов... "
###  sudo pacman -Sy
sudo pacman -Syy  # обновление баз пакмэна (pacman) 
echo -e " Установка базовых программ и пакетов wget, curl, git "
# sudo pacman -S --needed base-devel git
sudo pacman -S --noconfirm --needed wget curl git

clear
echo -e "${MAGENTA}
  <<< Установка дополнительного программного обеспечения (пакетов) для редактирования и разработки в Archlinux >>> ${NC}"
# Installing additional software (packages) for editing and development in Archlinux

echo ""
echo -e "${GREEN}==> ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)"
#echo -e "${BLUE}:: ${NC}Установка текстового редактора Vim или gVim (графическая оболочка для редактора Vim)" 
#echo 'Установка текстового редактора Vim или gVim'
# Installing the Vim or gVim text editor
echo -e "${CYAN}=> ${BOLD}В сценарии (скрипте) присутствуют следующие варианты: ${NC}"
echo -e "${MAGENTA}=> ${BOLD}Vim - это свободный текстовый редактор, созданный на основе более старого vi. Ныне это мощный текстовый редактор с полной свободой настройки и автоматизации, возможными благодаря расширениям и надстройкам. Пользовательский интерфейс Vim’а может работать в чистом текстовом режиме. Для поклонников vi - практически стопроцентная совместимость с vi. ${NC}"
echo -e "${CYAN}:: ${NC}Функционал утилиты Vim как при работе с текстовыми файлами, так и цикл разработки (редактирование; компиляция; исправление программ; и т.д.) очень обширен. (https://www.vim.org/)"
echo -e "${CYAN}:: ${NC}Существует и модификация для использования в графическом оконном интерфейсе - GVim."
echo -e "${MAGENTA}=> ${BOLD}gVim - представляет собой версию Vim, скомпилированную с поддержкой графического интерфейса. Обычно редактор Vim используют, запуская его в консоли или эмуляторе терминала. ${NC}"
echo -e "${CYAN}:: ${NC}Однако если вы активно используете GUI, вам может быть полезен gVim. (https://www.vim.org/)"
echo -e "${YELLOW}==> Примечание: ${BOLD}При установке приложение gVim пакета (gvim), само приложение Vim пакет (vim) будет удален (просто заменён на gvim). ${NC}"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. "
# Be careful! The installation process was fully automatic.
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo "" 
while 
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p "      
    1 - Установить редактор Vim,   2 - Установить приложение gVim (GUI),  3 - Установить редактор NeoVim,   

    0 - НЕТ - Пропустить установку: " i_gvim  # sends right after the keypress; # отправляет сразу после нажатия клавиши    
    echo ''
    [[ "$i_gvim" =~ [^1230] ]]
do
    :
done 
if [[ $i_gvim == 0 ]]; then 
echo ""   
echo " Установка пропущена "
elif [[ $i_gvim == 1 ]]; then
  echo ""    
  echo " Установка редактора Vim "
sudo pacman -S --noconfirm --needed vim  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки ; https://www.vim.org/ ; https://archlinux.org/packages/extra/x86_64/vim/
echo ""
echo " Установка редактора Vim выполнена "
elif [[ $i_gvim == 2 ]]; then
  echo ""    
  echo " Установка приложение gVim графической оболочки для редактора Vim "
# sudo pacman -Rsn vim  # Удалить пакет с зависимостями (не используемыми другими пакетами) и его конфигурационные файлы
# sudo pacman -Rs vim  # Удалить пакет с зависимостями (не используемыми другими пакетами)
#sudo pacman -R vim  # Удалить пакет vim
sudo pacman -S --noconfirm --needed gvim  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (с расширенными функциями, такими как графический интерфейс) ; https://www.vim.org/ ; https://archlinux.org/packages/extra/x86_64/gvim/ ; Конфликты: с vim, vim-minimal
echo ""
echo " Установка gVim графической оболочки для редактора Vim выполнена "
elif [[ $i_gvim == 3 ]]; then
  echo ""    
  echo " Установка приложение NeoVim (Форк Vim) "
# sudo pacman -Rsn vim  # Удалить пакет с зависимостями (не используемыми другими пакетами) и его конфигурационные файлы
# sudo pacman -Rs vim  # Удалить пакет с зависимостями (не используемыми другими пакетами)
#sudo pacman -R vim  # Удалить пакет vim
sudo pacman -S --noconfirm --needed neovim  # Форк Vim с целью улучшить пользовательский интерфейс, плагины и графические интерфейсы ; https://ubunlog.com/ru/neovim-fork-configurable-de-vim-para-una-mejor-experiencia-de-usuario/ ; файл конфигурации он находится в ~ / .config / nvim / init.vim. https://wiki.archlinux.org/title/Neovim
sudo pacman -S --noconfirm --needed neovim-qt  # Графический интерфейс для Neovim ; https://github.com/equalsraf/neovim-qt ; https://archlinux.org/packages/extra/x86_64/neovim-qt/ ; Neovim Qt — это легкий кроссплатформенный графический интерфейс Neovim, написанный на C++ с использованием Qt ; Neovim Qt доступен на всех платформах, поддерживаемых Qt. Быстрый, легкий и настраиваемый Qt GUI. Предоставляет современный интерфейс, включая поддержку нескольких вкладок, разделенных окон и настраиваемых тем.
# sudo pacman -S --noconfirm --needed neovide  # Без излишеств Neovim Client в Rust ; https://github.com/neovide/neovide ; https://archlinux.org/packages/extra/x86_64/neovide/ ; графический интерфейс Rust.
# yay -S neovim-gtk --noconfirm  # GTK UI для Neovim, написанный на Rust ; GTK GUI. Предоставляет современный настраиваемый интерфейс, включая поддержку разделенных окон, нескольких вкладок и настраиваемых тем ; https://aur.archlinux.org/neovim-gtk.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/Lyude/neovim-gtk ; https://aur.archlinux.org/packages/neovim-gtk 
### yay -S uivonim-git --noconfirm  # Форк графического интерфейса Veonim Neovim ; Простой и легкий GTK GUI. Предоставляет минималистичный интерфейс, включая поддержку разделенных окон и настраиваемых тем ; https://aur.archlinux.org/uivonim-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/smolck/uivonim ; https://aur.archlinux.org/packages/uivonim-git ; Конфликты: с uivonim ; Uivonim — это ответвление Veonim, «простой модальной IDE, построенной на расширениях Neovim и VSCode», написанной на Electron с рендерингом WebGL GPU и многопоточностью. Цель Uivonim — использовать Veonim в качестве основы для создания многофункционального кроссплатформенного GUI, который использует новейшие функции Neovim (плавающие окна, встроенный LSP, Lua) без зависимости от расширений VSCode. 
# yay -S neoray-git --noconfirm  # графический интерфейс Go ; Go GUI для neovim ; https://aur.archlinux.org/neoray-git.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/hismailbulut/neoray ; https://aur.archlinux.org/packages/neoray-git ; Neoray — это простой и легкий GUI-клиент для Neovim. Он написан на Go с использованием привязок GLFW и OpenGL. Neoray прост в использовании и имеет небольшой размер двоичного кода. Поддерживает большинство функций Neovim. Использует небольшой объем оперативной памяти и не оставляет следов на вашем компьютере.
# yay -S gnvim --noconfirm  # Графический интерфейс пользователя для neovim, без лишних веб-затрат ; графический интерфейс GTK ; https://aur.archlinux.org/gnvim.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/vhakulinen/gnvim ; https://aur.archlinux.org/packages/gnvim ; GNvim - графический интерфейс GTK4 Neovim ; Gnvim, своеобразный графический интерфейс Neovim. Для предыдущей версии gtk3 проверьте legacyветку.
# yay -S fvim --noconfirm  # Кроссплатформенный интерфейс Neovim, созданный с использованием F# + Avalonia ; графический интерфейс F# ; https://aur.archlinux.org/fvim.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/yatli/fvim ; https://aur.archlinux.org/packages/fvim
###################### 
### Пользовательский файл конфигурации Nvim $XDG_CONFIG_HOME/nvim/init.vim по умолчанию находится в Системный файл конфигурации по умолчанию ~/.config/nvim/init.vim
### Nvim совместим с большинством опций Vim; однако есть опции, специфичные для Nvim. Полный список опций Nvim см. в файле справки Neovim (https://neovim.io/doc/user/options.html).
### Каталог данных Nvim находится в ~/.local/share/nvim/и содержит файл подкачки для открытых файлов, файл ShaDa (Shared Data) и каталог сайта для плагинов.
### Начиная с версии Nvim 0.5, можно настроить Nvim через Lua, по умолчанию ~/.config/nvim/init.lua, API все еще молодой, но общие конфигурации работают из коробки без дополнительных шагов. 
### Neovim использует $XDG_CONFIG_HOME/nvimвместо него ~/.vimв качестве основного каталога конфигурации и $XDG_CONFIG_HOME/nvim/init.vimвместо него ~/.vimrcв качестве основного файла конфигурации.
# Neovim — это ответвление Vim , направленное на улучшение кодовой базы, что позволяет упростить реализацию API, улучшить пользовательский опыт и реализацию плагинов. Neovim вдохновил такие редакторы, как Helix .
# https://wiki.archlinux.org/title/Neovim
########### расширения возможностей редактора Neovim из AUR (через - yay) ################
# yay -S neovim-doxygentoolkit --noconfirm  # Этот скрипт упрощает документацию doxygen на C/C++ ; https://aur.archlinux.org/neovim-doxygentoolkit.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=987 ; https://aur.archlinux.org/packages/neovim-doxygentoolkit
# yay -S neovim-jellybeans --noconfirm  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками ; https://aur.archlinux.org/neovim-jellybeans.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nanotech/jellybeans.vim ; https://aur.archlinux.org/packages/neovim-jellybeans
# yay -S neovim-project --noconfirm  # Организация и навигация по проектам файлов (как в обозревателе IDE/буфера) ; https://aur.archlinux.org/neovim-project.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=69 ; https://aur.archlinux.org/packages/neovim-project
# yay -S neovim-taglist --noconfirm  # Плагин браузера исходного кода для Neovim ; https://aur.archlinux.org/neovim-taglist.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=273 ; https://aur.archlinux.org/packages/neovim-taglist
# yay -S neovim-workspace --noconfirm  # Плагин Neovim Workspace Manager для управления группами файлов ; https://aur.archlinux.org/neovim-workspace.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=1410 ; https://aur.archlinux.org/packages/neovim-workspace
echo ""
echo " Установка приложение NeoVim (Форк Vim) выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim или gVim'
# Installing additional packages to extend the capabilities of the Vim or gVim editor
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vi, vim-ansible, vim-ale, vim-airline, vim-airline-themes, vim-align, vim-bufexplorer, vim-ctrlp, vim-fugitive, vim-indent-object, vim-jad, vim-jedi, vim-latexsuite, vim-molokai, vim-nerdcommenter, vim-nerdtree, vim-pastie, vim-runtime, vim-seti, vim-spell-ru, vim-supertab, vim-surround, vim-syntastic, vim-tagbar, vim-ultisnips, vim-coverage-highlight, vim-csound, vim-easymotion, vim-editorconfig, vim-gitgutter, vim-grammalecte, vimpager)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " i_vi  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$i_vi" =~ [^10] ]]
do
    :
done
if [[ $i_vi == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim пропущена "
elif [[ $i_vi == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim "
# (https://www.vim.org/)
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!
sudo pacman -S --noconfirm --needed vi  # Оригинальный текстовый редактор ex / vi ; https://ex-vi.sourceforge.net/ ; https://archlinux.org/packages/core/x86_64/vi/
sudo pacman -S --noconfirm --needed vim-ansible  # Плагин vim для подсветки синтаксиса распространенных типов файлов Ansible ; https://github.com/pearofducks/ansible-vim ; https://archlinux.org/packages/extra/any/vim-ansible/
sudo pacman -S --noconfirm --needed vim-ale  # Асинхронный движок Lint с поддержкой протокола языкового сервера (LSP) ; https://github.com/dense-analysis/ale ; https://archlinux.org/packages/extra/any/vim-ale/ 
sudo pacman -S --noconfirm --needed vim-airline  # Строка состояния, написанная в Vimscript ; https://github.com/vim-airline/vim-airline ; https://archlinux.org/packages/extra/any/vim-airline/
sudo pacman -S --noconfirm --needed vim-airline-themes  # Темы для vim-airline (вим-авиакомпании) ; https://github.com/vim-airline/vim-airline-themes ; https://archlinux.org/packages/extra/any/vim-airline-themes/
sudo pacman -S --noconfirm --needed vim-bufexplorer  # Простой список буферов / переключатель для vim ; https://github.com/jlanzarotta/bufexplorer ; https://archlinux.org/packages/extra/any/vim-bufexplorer/
sudo pacman -S --noconfirm --needed vim-ctrlp  # Поиск нечетких файлов, буферов, mru, тегов и т.д. ; https://github.com/ctrlpvim/ctrlp.vim ; https://archlinux.org/packages/extra/any/vim-ctrlp/
sudo pacman -S --noconfirm --needed vim-fugitive  # Git-обертка настолько крута, что должна быть запрещена ; https://github.com/tpope/vim-fugitive ; https://archlinux.org/packages/extra/any/vim-fugitive/
sudo pacman -S --noconfirm --needed vim-indent-object  # Текстовые объекты на основе уровней отступа ; https://www.vim.org/scripts/script.php?script_id=3037 ; https://archlinux.org/packages/extra/any/vim-indent-object/
sudo pacman -S --noconfirm --needed vim-jad  # Автоматическая декомпиляция файлов классов Java и отображение кода Java ; https://www.vim.org/scripts/script.php?script_id=446 ; https://archlinux.org/packages/extra/any/vim-jad/
sudo pacman -S --noconfirm --needed vim-jedi  # Плагин Vim для jedi, потрясающее автодополнение Python ; https://github.com/davidhalter/jedi-vim ; https://archlinux.org/packages/extra/any/vim-jedi/
sudo pacman -S --noconfirm --needed vim-latexsuite  # Инструменты для просмотра, редактирования и компиляции документов LaTeX в Vim ; http://vim-latex.sourceforge.net/ ; https://archlinux.org/packages/extra/any/vim-latexsuite/
sudo pacman -S --noconfirm --needed vim-molokai  # Порт цветовой схемы монокаи для TextMate ; https://www.vim.org/scripts/script.php?script_id=2340 ; https://archlinux.org/packages/extra/any/vim-molokai/
sudo pacman -S --noconfirm --needed vim-nerdcommenter  # Плагин, позволяющий легко комментировать код для многих типов файлов ; https://github.com/preservim/nerdcommenter ; https://archlinux.org/packages/extra/any/vim-nerdcommenter/
sudo pacman -S --noconfirm --needed vim-nerdtree  # Плагин Tree explorer для навигации по файловой системе ; https://github.com/preservim/nerdtree ; https://archlinux.org/packages/extra/any/vim-nerdtree/
sudo pacman -S --noconfirm --needed vim-runtime  # Vi Improved, улучшенная версия текстового редактора vi с широкими возможностями настройки (общая среда выполнения) ; https://www.vim.org/ ; https://archlinux.org/packages/extra/x86_64/vim-runtime/
sudo pacman -S --noconfirm --needed vim-seti  # Цветовая схема на основе темы Сети Джесси Вида для редактора Atom ; https://github.com/trusktr/seti.vim ; https://archlinux.org/packages/extra/any/vim-seti/
sudo pacman -S --noconfirm --needed vim-spell-ru  # Языковые файлы для проверки орфографии Vim (ru) ; http://ftp.vim.org/pub/vim/runtime/spell ; https://archlinux.org/packages/extra/any/vim-spell-ru/
sudo pacman -S --noconfirm --needed vim-supertab  # Плагин Vim, который позволяет использовать клавишу табуляции для выполнения всех операций вставки ; Плагин Vim, позволяющий использовать клавишу Tab для завершения всех вставок ; https://github.com/ervandew/supertab ;https://archlinux.org/packages/extra/any/vim-supertab/
sudo pacman -S --noconfirm --needed vim-surround  # Предоставляет сопоставления для простого удаления, изменения и добавления парного окружения ; https://github.com/tpope/vim-surround ; https://archlinux.org/packages/extra/any/vim-surround/
sudo pacman -S --noconfirm --needed vim-syntastic  # Автоматическая проверка синтаксиса для Vim ; https://github.com/vim-syntastic/syntastic ; https://archlinux.org/packages/extra/any/vim-syntastic/
sudo pacman -S --noconfirm --needed vim-tagbar  # Плагин для просмотра тегов текущего файла и получения обзора его структуры ; https://github.com/preservim/tagbar ; https://archlinux.org/packages/extra/any/vim-tagbar/
sudo pacman -S --noconfirm --needed vim-ultisnips  # Фрагменты для Vim в стиле TextMate ; https://github.com/SirVer/ultisnips ; https://archlinux.org/packages/extra/any/vim-ultisnips/
sudo pacman -S --noconfirm --needed vim-csound  # Инструменты csound для Vim ; https://github.com/luisjure/csound-vim ; https://archlinux.org/packages/extra/any/vim-csound/
sudo pacman -S --noconfirm --needed vim-easymotion  # Vim движение по скорости ; https://github.com/easymotion/vim-easymotion ; https://archlinux.org/packages/extra/any/vim-easymotion/
sudo pacman -S --noconfirm --needed vim-gitgutter  # Плагин Vim, показывающий разницу git в желобе (столбец со знаком) ; https://github.com/airblade/vim-gitgutter ; https://archlinux.org/packages/extra/any/vim-gitgutter/
sudo pacman -S --noconfirm --needed vim-grammalecte  # Интегрирует Grammalecte в Vim ; https://github.com/dpelle/vim-Grammalecte ; https://archlinux.org/packages/extra/any/vim-grammalecte/
sudo pacman -S --noconfirm --needed vimpager  # Сценарий на основе vim для использования в качестве ПЕЙДЖЕРА ; https://www.vim.org/scripts/script.php?script_id=1723 ; https://archlinux.org/packages/extra/any/vimpager/
sudo pacman -S --noconfirm --needed lua-stdlib  # Библиотека модулей для решения общих задач программирования ; https://github.com/lua-stdlib/lua-stdlib ; https://archlinux.org/packages/extra/any/lua-stdlib/ ; help lua-stdlib
# sudo pacman -S --noconfirm --needed   #
# sudo pacman -S  --noconfirm  #
echo ""
echo " Установка дополнительных пакетов для редактора Vim выполнена "
fi

clear
echo ""
echo -e "${GREEN}==> ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)"
#echo -e "${BLUE}:: ${NC}Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)" 
#echo 'Установка дополнительных пакетов для расширения возможностей редактора Vim из AUR (через - yay)'
# Installing additional packages to extend the capabilities of the Vim editor from AUR (via - yay)
echo -e "${MAGENTA}=> ${NC}Список программ (пакетов) для установки: - (vim-colorsamplerpack, vim-doxygentoolkit, vim-guicolorscheme, vim-jellybeans, vim-minibufexpl, vim-omnicppcomplete, vim-project, vim-rails, vim-taglist, vim-vcscommand, vim-workspace)."
echo -e "${CYAN}:: ${NC}Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты!"
echo " Будьте внимательны! Процесс установки, был прописан полностью автоматическим. " 
# Be careful! The installation process was fully automatic
echo " Если Вы сомневаетесь в своих действиях, ещё раз обдумайте... "
# If you doubt your actions, think again... 
echo ""
while
echo " Действия ввода, выполняется сразу после нажатия клавиши "
    read -n1 -p " 
    1 - Да установить,     0 - НЕТ - Пропустить действие: " t_vim  # sends right after the keypress; # отправляет сразу после нажатия клавиши
    echo ''
    [[ "$t_vim" =~ [^10] ]]
do
    :
done
if [[ $t_vim == 0 ]]; then
echo ""  
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) пропущена "
elif [[ $t_vim == 1 ]]; then
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) "
# yay -S vim-colorsamplerpack vim-doxygentoolkit vim-guicolorscheme vim-jellybeans vim-minibufexpl vim-omnicppcomplete vim-project vim-rails vim-taglist vim-vcscommand vim-workspace --noconfirm  
# Вы МОЖЕТЕ в скрипте закомментировать НЕнужные вам пакеты !
yay -S vim-colorsamplerpack --noconfirm  # Различные цветовые схемы для vim ; https://aur.archlinux.org/vim-colorsamplerpack.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=625 ; https://aur.archlinux.org/packages/vim-colorsamplerpack
yay -S vim-doxygentoolkit --noconfirm  # Этот скрипт упрощает документацию doxygen на C / C ++ ; https://aur.archlinux.org/vim-doxygentoolkit.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=987 ; https://aur.archlinux.org/packages/vim-doxygentoolkit
yay -S vim-guicolorscheme --noconfirm  # Автоматическое преобразование цветовых схем только для графического интерфейса в схемы цветовых терминалов 88/256 ; https://aur.archlinux.org/vim-guicolorscheme.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=1809 ; https://aur.archlinux.org/packages/vim-guicolorscheme
yay -S vim-jellybeans --noconfirm  # Яркая, темная цветовая гамма, вдохновленная ir_black и сумерками ; https://aur.archlinux.org/vim-jellybeans.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/nanotech/jellybeans.vim ; https://aur.archlinux.org/packages/vim-jellybeans
yay -S vim-minibufexpl --noconfirm  # Элегантный обозреватель буферов для vim ; https://aur.archlinux.org/vim-minibufexpl.git (только для чтения, нажмите, чтобы скопировать) ; http://fholgado.com/minibufexpl ; https://aur.archlinux.org/packages/vim-minibufexpl
yay -S vim-omnicppcomplete --noconfirm  # vim c ++ завершение omnifunc с базой данных ctags ; https://aur.archlinux.org/vim-omnicppcomplete.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=1520 ; https://aur.archlinux.org/packages/vim-omnicppcomplete
yay -S vim-project --noconfirm  # Организовывать и перемещаться по проектам файлов (например, в проводнике ide / buffer) ; https://aur.archlinux.org/vim-project.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=69 ; https://aur.archlinux.org/packages/vim-project
yay -S vim-projectionist --noconfirm  # Детальная конфигурация проекта ; https://aur.archlinux.org/vim-projectionist.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/tpope/vim-projectionist ; https://aur.archlinux.org/packages/vim-projectionist
yay -S vim-rails --noconfirm  # Плагин ViM для усовершенствованной разработки приложений Ruby on Rails ; https://aur.archlinux.org/vim-rails.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=1567 ; https://aur.archlinux.org/packages/vim-rails
yay -S vim-railscasts --noconfirm  # Цветовая тема railscasts, которая работает в 256-цветных терминалах, а также в графическом интерфейсе ; https://aur.archlinux.org/vim-railscasts.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=2175 ; https://aur.archlinux.org/packages/vim-railscasts
yay -S vim-taglist --noconfirm  # Плагин браузера с исходным кодом для vim ; https://aur.archlinux.org/vim-taglist.git (только для чтения, нажмите, чтобы скопировать) ; http://vim-taglist.sourceforge.net/ ; https://aur.archlinux.org/packages/vim-taglist
yay -S vim-vcscommand --noconfirm  # Плагин интеграции системы контроля версий vim ; https://aur.archlinux.org/vim-vcscommand.git (только для чтения, нажмите, чтобы скопировать) ; http://www.vim.org/scripts/script.php?script_id=90 ; https://aur.archlinux.org/packages/vim-vcscommand
yay -S vim-workspace --noconfirm  # Плагин vim workspace manager для управления группами файлов ; https://aur.archlinux.org/vim-workspace.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/thaerkh/vim-workspace ; https://aur.archlinux.org/packages/vim-workspace
# yay -S vim-coverage-highlight --noconfirm  # Плагин Vim для подсветки строк исходного кода Python, не покрытых тестами ; https://aur.archlinux.org/vim-coverage-highlight.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/mgedmin/coverage-highlight.vim ; https://aur.archlinux.org/packages/vim-coverage-highlight
# yay -S vim-editorconfig --noconfirm  # Плагин EditorConfig для Vim ; https://aur.archlinux.org/vim-editorconfig.git (только для чтения, нажмите, чтобы скопировать) ; https://github.com/editorconfig/editorconfig-vim ; https://aur.archlinux.org/packages/vim-editorconfig
# yay -S vim-pastie --noconfirm  # Плагин Vim, позволяющий читать и создавать вставки на сайте http://pastie.org/ ; https://aur.archlinux.org/vim-pastie.git (только для чтения, нажмите, чтобы скопировать) ; https://www.vim.org/scripts/script.php?script_id=1624 ; https://aur.archlinux.org/packages/vim-pastie
# ay -S vim-align --noconfirm  # Позволяет выравнивать строки с помощью регулярных выражений ; https://aur.archlinux.org/vim-align.git (только для чтения, нажмите, чтобы скопировать) ; https://www.vim.org/scripts/script.php?script_id=294 ; https://aur.archlinux.org/packages/vim-align
# yay -S  --noconfirm  #
pwd  # покажет в какой директории мы находимся
echo ""
echo " Установка дополнительных пакетов для редактора Vim из AUR (через - yay) выполнена "
fi
sleep 03

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

