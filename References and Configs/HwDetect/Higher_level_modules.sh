#! /bin/bash
# Советы и рекомендации:
# https://wiki.archlinux.org/title/Hwdetect
# Модули более высокого уровня:
# Обратный сценарий также интересен, поскольку в нем перечислены модули более высокого уровня, в том смысле, что они менее связаны с конкретными аппаратными средствами:
 awk -F: '{gsub("-","_"); print $2}'))

for mod in $(awk '{print $1}' /proc/modules); do
    if ! grep -q "$mod" <(printf '%s\n' "${lowlevel[@]}"); then
        printf '%s\n' "$mod";
    fi
done