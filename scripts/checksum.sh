#!/bin/bash
# loadkeys ru
# setfont cyr-sun16
# clear
#### Смотрите пометки (справочки) и доп.иформацию в самом скрипте! #### 

# verify file checksum from a file (проверьте контрольную сумму файла из файла)

# checksum algorithms (алгоритмы определения контрольной суммы)
algorithms=( 1 224 256 384 512 512224 512256 )

# file to check
file="$1"

# execute when there is one parameter (выполняется при наличии одного параметра)
if [ "$#" -eq "1" ]; then
  # check if file exist (проверьте, существует ли файл)
  if [ -f "${file}" ]; then
    # find checksum file (find checksum file)
    for algorithm in "${algorithms[@]}"; do
      if [ -f "${file}.sha${algorithm}" ]; then
        echo "Found SHA${algorithm} checksum"
        words="$(wc -w < ${file}.sha${algorithm})"
        # verify checksum and pass the exit code (проверьте контрольную сумму и передайте код выхода)
        if [ "$words" == "1" ]; then
          shasum --algorithm $algorithm --check <(echo $(cat ${file}.sha${algorithm})\ \ $file)
          exit $?
        elif [ "$words" == "2" ] || [ "$words" == "4" ]; then
          shasum --algorithm $algorithm --check ${file}.sha${algorithm}
          exit $?
        fi
      fi
    done
  fi
fi