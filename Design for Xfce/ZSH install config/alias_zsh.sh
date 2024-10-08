#!/bin/bash

echo " Создать файл .alias_zsh в ~/ (home_user) "
touch ~/.alias_zsh   # Создать файл в ~/.alias_zsh
cat > ~/.alias_zsh <<EOF
#!/usr/bin/zsh

# cat molot-tora.mp4 eraz.zip > data.mp4
# unzip date.mp4

# git.io custom url
# curl -i https://git.io -F "url=https://github.com/creio" -F "code=YOUR_CUSTOM_NAME"

alias sz="source $HOME/.zshrc"
alias ez="$EDITOR $HOME/.zshrc"
alias ea="$EDITOR $HOME/.alias_zsh"
alias merge="xrdb -merge $HOME/.Xresources"
alias xcolor="xrdb -query | grep"
alias vga="lspci -k | grep -A 2 -E '(VGA|3D)'"
alias upgrub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias updir="LC_ALL=C xdg-user-dirs-update --force"

alias dmrun="dmenu_run -l 10 -p 'app>' -fn 'ClearSansMedium 9' -nb '#282c37' -nf '#f2f3f4' -sb '#5a74ca' -sf '#fff'"

alias iip="curl --max-time 10 -w '\n' http://ident.me"
alias tb="nc termbin.com 9999"
alias tbc="nc termbin.com 9999 | xsel -b -i"
alias speed="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

doiso() {
  rsync -auvCL ~/ctlosiso/out/ cretm@${dev_ctlos_ru}:~/app/dev.ctlos.ru/iso/$1
}

# blur img: blur 4 .wall/wl3.jpg blur.jpg
blur() {
  convert -filter Gaussian -blur 0x$1 $2 $3
}

tbg() {
  urxvt -bg '[0]red' -b 0 -depth 32 +sb -name urxvt_bg &
}

# fzf
zzh() {
  du -a ~/ | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zz() {
  du -a . | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzd() {
  du -a $1 | awk '{print $2}' | fzf | xargs -r $EDITOR
}
zzb() {
  find -H "/usr/bin" "$HOME/.bin" -executable -print | sed -e 's=.*/==g' | fzf | sh
}

# зависимость source-highlight
hcat () {
  /usr/bin/src-hilite-lesspipe.sh "$1" | less -m -N
}
ccat () {
  cat "$1" | xsel -b -i
}

# share vbox В локальной машине mkdir vboxshare
# в виртуалке uid={имя пользователя} git={группа}
vboxshare () {
  [[ ! -d ~/vboxshare ]] && mkdir -p ~/vboxshare
  sudo mount -t vboxsf -o rw,uid=1000,gid=985 vboxshare vboxshare
  # sudo mount -t vboxsf -o rw,uid=st,gid=users vboxshare vboxshare
}
# share qemu
vmshare () {
  [[ ! -d ~/vmshare ]] && mkdir -p ~/vmshare
  sudo mount -t 9p -o trans=virtio,version=9p2000.L host0 vmshare
}

# aur pkg
amake () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  cd $1
  makepkg -s
  # makepkg -s --sign
  cd ..
}

# aur clean chroot manager
accm () {
  git clone https://aur.archlinux.org/"$2".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $2
  sudo ccm "$1" &&
  gpg --detach-sign "$2"-*.pkg*
  cd ..
}

# pkg clean chroot manager
lccm () {
  sudo ccm "$1" &&
  gpg --detach-sign *.pkg*
}

aget () {
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
}

# build and install pkg from aur
abuild () {
  cd ~/.build
  git clone https://aur.archlinux.org/"$1".git
  # curl -fO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz
  # tar -xvf $1.tar.gz
  cd $1
  makepkg -si --skipinteg
  cd ~
  # rm -rf ~/.build/$1 ~/.build/$1.tar.gz
  rm -rf ~/.build/$1
}


alias neofetch="neofetch --ascii ~/.config/neofetch/ctlos"
alias neoa="neofetch --ascii ~/.config/neofetch/mario"
alias neo="neofetch --w3m ~/.config/neofetch/cnr.png"
# alias neo="neofetch --kitty ~/.config/neofetch/cn.jpg"
# alias neo="neofetch --w3m"

# Погода, не только по городу, но и по месту. Нет привязки к регистру и языку.
# alias wtr="curl 'wttr.in/Москва?M&lang=ru'"
# alias wtr="curl 'wttr.in/Москва?M&lang=ru' | sed -n '1,17p'"
# alias wtr="curl 'wttr.in/?M1npQ&lang=ru'"
wtr () {
  # curl "wttr.in/?M$1npQ&lang=ru"
  curl "wttr.in/Moscow?M$1npQ&lang=ru"
}
wts () {
  curl "wttr.in/$1?M&lang=ru"
}
alias moon="curl 'wttr.in/Moon'"

alias srm="sudo rm -rfv"
alias rm="rm -rfv"
brm () {
  /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}
sbrm () {
  sudo /bin/bash -c "yes | rm -rfv $1"{.\*\,\*}
}

alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=always"
#alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias ls="ls --color=auto"
alias la="ls -alFh --color=auto"
alias llp="stat -c '%A %a %n' {*,.*}"
alias ll="ls -a --color=auto"
alias l="ls -CF --color=auto"
alias .l="dirs -v"
alias lss="ls -sh | sort -h"
alias duh="du -d 1 -h | sort -h"

alias mk="mkdir"
mkj () {
  mkdir -p "$1"
  cd "$1"
}

alias /="cd /"
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias q="exit"
alias gh="cd /media/files/github"
alias dot="cd /media/files/github/creio/dots"

function gc () {
  git clone "$1"
}

function gcj () {
  git clone "$1"
  cd "$2"
  # $EDITOR .
}
alias gi="git init"
alias gs="git status"
alias gl="git log --stat --pretty=oneline --graph --date=short"
# alias gg="gitg &"
alias ga="git add --all"
gac () {
  git add --all
  git commit -am "$1"
}
alias gr="git remote"
alias gf="git fetch"
alias gpl="git pull"
alias gp="git push"
alias gpm="git push origin master"
# yarn global add github-search-repos-cli
# alias gsc="github-search-repos -i"

# tor chromium
alias torc="$BROWSER --proxy-server='socks://127.0.0.1:9050' &"
alias psi="$BROWSER --proxy-server='socks://127.0.0.1:1081' &"

# full screen flags -fs
alias yt="straw-viewer"
ytv () {
  straw-viewer "$1"
}

# youtube-dl --ignore-errors -o '~/Видео/youtube/%(playlist)s/%(title)s.%(ext)s' https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
# Загрузка Видео ~/Videos или ~/Видео
# Пример: dlv https://www.youtube.com/watch?v=gBAfejjUQoA
dlv () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(title)s.%(ext)s' "$1"
}
# dlp https://www.youtube.com/playlist?list=PL-UzghgfytJQV-JCEtyuttutudMk7
dlp () {
  youtube-dl --ignore-errors -o '~/Videos/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

# Загрузка аудио ~/Music или ~/Музыка
# Пример: mp3 https://www.youtube.com/watch?v=gBAfejjUQoA
mp3 () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(title)s.%(ext)s' "$1"
}
# mp3p https://www.youtube.com/watch?v=-F7A24f6gNc&list=RD-F7A24f6gNc
mp3p () {
  youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/Music/youtube/%(playlist)s/%(title)s.%(ext)s' "$1"
}

alias porn="mpv 'http://www.pornhub.com/random'"

alias mvis="ncmpcpp -S visualizer"
alias m="ncmpcpp"

pf () {
  peerflix "$1" --mpv
}
alias rss="newsboat"
# download web site
wgetw () {
  wget -rkx "$1"
}
iso () {
  sudo dd bs=4M if="$1" of=/dev/"$2" status=progress && sync
}

alias -s {mp3,m4a,flac,mp4,mkv,webm}="mpv"
alias -s {png,jpg,tiff,bmp,gif}="viewnior"
# alias -s {conf,txt}="nvim"
# alias {aurman,pikaur,trizen,yaourt}="yay"

alias mi="micro"
alias smi="sudo micro"
alias s="subl3"
alias ss="sudo subl3"
alias tm="tmux attach || tmux new -s work"
alias tmd="tmux detach"
alias tmk="tmux kill-server"
alias rr="ranger"
alias srr="sudo ranger"
alias h="htop"
# alias {v,vi,vim}="nvim"

# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $2}' > ~/.pkglist.txt
# LANG=C pacman -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > ~/.pkglist.txt
# alias mirftu='pacman-mirrors --fasttrack 10 && pacman -Syyu'
alias pkglist="pacman -Qneq > ~/.pkglist.txt"
alias aurlist="pacman -Qmeq > ~/.aurlist.txt"

alias packey="sudo pacman-key --init && sudo pacman-key --populate && sudo pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com && sudo pacman -Syy"
alias y="yay -S"
alias yn="yay -S --noconfirm"
alias yl="yay -S --noconfirm --needed - < ~/.pkglist.txt"
alias ys="yay"
alias ysn="yay --noconfirm"
alias yo="yay -S --overwrite='*'"
alias yU="yay -U"
alias yUo="yay -U --overwrite='*'"
alias yc="yay -Sc"
alias ycc="yay -Scc"
alias yy="yay -Syy"
alias yu="yay -Syyu"
alias yun="yay -Syyu --noconfirm"
alias yr="yay -R"
alias yrs="yay -Rs"
alias yrsn="yay -Rsn"
alias yrn="yay -R --noconfirm"
alias ynskip='yay --noconfirm --mflags "--nocheck --skipchecksums --skippgpcheck"'
alias ygpg='yay --noconfirm --gpgflags "--keyserver keys.gnupg.net"'

# alias pres="sudo pacman -S $(pacman -Qqn)"
# alias yrsnp="yay -Rsn $(pacman -Qdtq)"
# alias yal="yay -S --noconfirm --needed $(cat ~/.aurlist.txt)"
# pacman -Qqo /usr/lib/python3.9/



# распаковать архив не указывая тип распаковщика
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Использование: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xvjf ./"$1"    ;;
          *.tar.gz)    tar xvzf ./"$1"    ;;
          *.tar.xz)    tar xvJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xvf ./"$1"     ;;
          *.tbz2)      tar xvjf ./"$1"    ;;
          *.tgz)       tar xvzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           echo "ex: '$1' - Не может быть распакован" ;;
        esac
    else
        echo "'$1' - не является допустимым файлом"
    fi
fi
}

# Упаковка в архив командой pk 7z /что/мы/пакуем имя_файла.7z
function pk () {
  if [ $1 ] ; then
    case $1 in
      tbz)       tar cjvf $2.tar.bz2 $2      ;;
      tgz)       tar czvf $2.tar.gz  $2       ;;
      txz)       tar -caf $2.tar.xz  $2       ;;
      tar)       tar cpvf $2.tar  $2       ;;
      bz2)       bzip $2 ;;
      gz)        gzip -c -9 -n $2 > $2.gz ;;
      zip)       zip -r $2.zip $2   ;;
      7z)        7z a $2.7z $2    ;;
      *)         echo "'$1' не может быть упакован с помощью pk()" ;;
    esac
  else
    echo "'$1' не является допустимым файлом"
  fi
}

EOF
#########
echo " Сделайте файл .alias_zsh исполняемым "
sudo chmod a+x ~/.alias_zsh
### end of script