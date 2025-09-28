#! /bin/bash
# Советы и рекомендации:
# https://wiki.archlinux.org/title/Hwdetect
# Неиспользуемые модули:
# Чтобы сформировать список модулей, которые в данный момент не используются, используйте следующий скрипт
 awk -F: '{gsub("-","_"); print $2}'); do
    if ! grep -q "$hw" <(printf '%s\n' "${modules[@]}"); then
        printf '%s\n' "$hw";
    fi
done

