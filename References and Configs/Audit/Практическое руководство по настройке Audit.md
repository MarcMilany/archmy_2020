Практическое руководство по настройке Audit

https://people.redhat.com/sgrubb/audit
https://github.com/ilpianista/arch-audit
https://archlinux.org/packages/core/x86_64/audit/
https://www.archlinux.org/packages/core/x86_64/audit/
https://wiki.archlinux.org/title/Audit_framework
https://man.archlinux.org/man/auditd.8.en
Auditd:
https://github.com/trimstray/the-practical-linux-hardening-guide/wiki/Auditd

############# Справка ##############
Для просмотра записей в журнале выполните команду:
sudo ausearch -f /etc/resolv.conf

Для начала, убедитесь, что это настоящий файл, а не символьная ссылка:
sudo ls -l /etc/resolv.conf

Если это символьная ссылка, удалите её:
sudo rm /etc/resolv.conf

Как узнать, какой процесс изменяет файл /etc/resolv.conf
sudo auditctl -w /etc/resolv.conf -p wa
sudo systemctl start auditd.service
systemctl stop auditd.service


*Практическое руководство по усилению защиты Linux содержит общий обзор мер по усилению защиты систем GNU/Linux. Оно не является официальным стандартом или руководством, но соответствует отраслевым стандартам и использует их.

https://github.com/trimstray/the-practical-linux-hardening-guide/wiki/Auditd

Оглавление
Аудит
Включить аудит для процессов, которые запускаются до демона аудита
Включить службу auditd
Максимальный размер файла журнала
Уведомление о малом количестве места на диске
Действия при недостатке места на диске
Действия при достижении максимального размера журнала
Запись информации о загрузке и выгрузке модуля ядра
Запись попыток изменить события входа и выхода из системы
Запишите попытки изменить время с помощью stime
Запись попыток изменить время через settimeofday
Запись попыток изменить файл локального времени
Запись попыток изменения времени через clock_settime
Запись попыток изменить время через adjtimex
Запись событий, которые изменяют дискреционные средства управления доступом системы
Убедитесь, что auditd собирает события удаления файлов пользователем.
Запись информации об использовании привилегированных команд
Регистрировать попытки несанкционированного доступа к файлам
Убедитесь, что auditd собирает данные о действиях системного администратора
Запись событий, которые изменяют сетевую среду системы
Сделайте конфигурацию auditd неизменяемой
Запись попыток изменить информацию об инициировании процесса и сеанса
Запись событий, которые изменяют информацию о пользователе/группе
Убедитесь, что auditd собирает информацию об экспорте на носитель
Запись событий, которые изменяют обязательные элементы управления доступом системы


Аудит:
Служба аудита предоставляет существенные возможности для регистрации действий системы.

По умолчанию служба проверяет отклонения SELinux AVC и определенные типы событий, связанных с безопасностью, такие как входы в систему, изменения учетных записей и события аутентификации, выполняемые такими программами, как sudo.

Включить аудит для процессов, которые запускаются до демона аудита
Обоснование
Каждый процесс в системе имеет флаг «auditable», который указывает, можно ли проводить аудит его действий. Хотя auditd включает этот флаг для всех процессов, запускаемых после него, добавление аргумента ядра гарантирует, что он будет установлен для каждого процесса во время загрузки.

Решение
Установите значение
# Add to /etc/default/grub:
GRUB_CMDLINE_LINUX="... audit=1"

Обновить конфигурации grub в директории исходника:
sudo grub-mkconfig -o /boot/grub/grub.cfg
# Updated grub configuration:
grub2-mkconfig -o

############################

Включить службу auditd:
Обоснование
Без определения типа произошедших событий будет сложно установить, сопоставить и расследовать события, приведшие к сбою или атаке. Активность службы auditd гарантирует надлежащую регистрацию записей аудита, генерируемых ядром.

Решение
Установите значение
systemctl enable auditd.service

Максимальный размер файла журнала
Обоснование
Общий объём хранилища для файлов журнала аудита должен быть достаточным для хранения информации в течение требуемого периода. Это зависит от максимального размера файла журнала и количества сохраняемых журналов.

Решение
Установите значение
# Edit /etc/audit/auditd.conf:
max_log_file = STOREMB


Уведомление о малом количестве места на диске:
Обоснование
Электронная почта, отправляемая на учетную запись root, обычно перенаправляется администраторам системы, которые могут предпринять соответствующие действия.

Решение
Установите значение
# Edit /etc/audit/auditd.conf:
action_mail_acct = root

Действия при недостатке места на диске:
Обоснование
Администраторы должны быть осведомлены о невозможности записи записей аудита. При использовании отдельного раздела или логического тома достаточного размера нехватка места для записей аудита недопустима.

Решение
Установите значение
# Edit /etc/audit/auditd.conf:
admin_space_left_action = ACTION


Действия при достижении максимального размера журнала:
Обоснование
Автоматическая ротация журналов (путем настройки ротации) сводит к минимуму вероятность того, что система неожиданно исчерпает место на диске из-за переполнения данными журналов.

Однако для систем, которые никогда не должны сбрасывать данные журнала или которые используют внешние процессы для их передачи и освобождения места, можно использовать keep_logs.

Решение
Установите значение
# Edit /etc/audit/auditd.conf:
max_log_file_action = ACTION

######################################

Собирает информацию о загрузке и выгрузке модулей ядра.
Обоснование
Добавление/удаление модулей ядра может быть использовано для изменения поведения ядра и потенциального внедрения вредоносного кода в пространство ядра. Важно иметь журнал аудита модулей, добавленных в ядро.

Решение
Установите значение:
# Add to /etc/audit/rules.d/extended.rules
-w /usr/sbin/insmod -p x -k modules
-w /usr/sbin/rmmod -p x -k modules
-w /usr/sbin/modprobe -p x -k modules

-a always,exit -F arch=ARCH -S init_module,finit_module,create_module,delete_module -F key=modules

Запись попыток изменить события входа и выхода из системы:
Обоснование
Ручное редактирование этих файлов может указывать на злонамеренную деятельность, например, на попытку злоумышленника удалить доказательства вторжения.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-w /var/log/tallylog -p wa -k logins
-w /var/run/faillock -p wa -k logins
-w /var/log/lastlog -p wa -k logins


Запишите попытки изменить время с помощью stime
Обоснование
Произвольные изменения системного времени могут быть использованы для сокрытия вредоносных действий в файлах журналов, а также для сбивания с толку сетевых служб, сильно зависящих от точного системного времени (например, sshd). Все изменения системного времени должны быть проверены.

Решение
Установите значение:
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S stime -F key=audit_time_rules

Запись попыток изменить время через settimeofday
Обоснование
Произвольные изменения системного времени могут быть использованы для сокрытия вредоносных действий в файлах журналов, а также для сбивания с толку сетевых служб, сильно зависящих от точного системного времени (например, sshd). Все изменения системного времени должны быть проверены.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S settimeofday -F key=audit_time_rules
-a always,exit -F arch=b64 -S settimeofday -F key=audit_time_rules

Запись попыток изменить файл локального времени:
Обоснование
Произвольные изменения системного времени могут быть использованы для сокрытия вредоносных действий в файлах журналов, а также для сбивания с толку сетевых служб, сильно зависящих от точного системного времени (например, sshd). Все изменения системного времени должны быть проверены.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-w /etc/localtime -p wa -k audit_time_rules

Запись попыток изменения времени через clock_settime:
Обоснование
Произвольные изменения системного времени могут быть использованы для сокрытия вредоносных действий в файлах журналов, а также для сбивания с толку сетевых служб, сильно зависящих от точного системного времени (например, sshd). Все изменения системного времени должны быть проверены.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -F key=time-change
-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -F key=time-change

Запись попыток изменить время через adjtimex:
Обоснование
Произвольные изменения системного времени могут быть использованы для сокрытия вредоносных действий в файлах журналов, а также для сбивания с толку сетевых служб, сильно зависящих от точного системного времени (например, sshd). Все изменения системного времени должны быть проверены.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S adjtimex -F key=audit_time_rules
-a always,exit -F arch=b64 -S adjtimex -F key=audit_time_rules

Запись событий, которые изменяют дискреционные средства управления доступом системы:
Обоснование
Изменение прав доступа к файлу может указывать на то, что пользователь пытается получить доступ к информации, которая в противном случае была бы запрещена. Аудит изменений DAC может облегчить выявление закономерностей злоупотреблений как со стороны авторизованных, так и неавторизованных пользователей.

Решение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fchown -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fchown -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S setxattr -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S setxattr -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S chown -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chown -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S removexattr -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S removexattr -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fchownat -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S chmod -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S chmod -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fsetxattr -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fsetxattr -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fchmod -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fchmod -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S lchown -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S lchown -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b64 -S fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S lremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod
-a always,exit -F arch=b32 -S lremovexattr -F auid>=1000 -F auid!=unset -F key=perm_mod

Убедитесь, что auditd собирает события удаления файлов пользователем:
Обоснование
Аудит удаления файлов создаст аудиторский след для файлов, удаляемых из системы. Этот след может помочь в устранении неполадок системы, а также в обнаружении вредоносных процессов, пытающихся удалить файлы журналов, чтобы скрыть своё присутствие.

Решение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S unlinkat -F auid>=1000 -F auid!=unset -F key=delete
-a always,exit -F arch=ARCH -S unlinkat -F auid>=1000 -F auid!=unset -F key=delete

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S rename -F auid>=1000 -F auid!=unset -F key=delete
-a always,exit -F arch=ARCH -S rename -F auid>=1000 -F auid!=unset -F key=delete

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S renameat -F auid>=1000 -F auid!=unset -F key=delete
-a always,exit -F arch=ARCH -S renameat -F auid>=1000 -F auid!=unset -F key=delete

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S unlink -F auid>=1000 -F auid!=unset -F key=delete
-a always,exit -F arch=ARCH -S unlink -F auid>=1000 -F auid!=unset -F key=delete

Запись информации об использовании привилегированных команд:
Обоснование
Привилегированные программы подвержены атакам с повышением привилегий, которые пытаются подорвать их обычную роль, заключающуюся в предоставлении необходимых, но ограниченных возможностей. В связи с этим существует необходимость отслеживать необычную активность этих программ.

Решение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F path=SETUID_PROG_PATH -F perm=x -F auid>=1000 -F auid!=unset -F key=privileged


Чтобы найти соответствующие setuid программы setgid:

find / -xdev -type f -perm -4000 -o -type f -perm -2000 2>/dev/null

Регистрировать попытки несанкционированного доступа к файлам:
Обоснование
Неудачные попытки доступа к файлам могут быть признаком вредоносной активности в системе. Аудит этих событий может служить доказательством потенциальной компрометации системы.

Решение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S truncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S truncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S truncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S truncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S creat -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S creat -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S creat -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S creat -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S open -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S open -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S open -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S open -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S open_by_handle_at -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S ftruncate -F exiu=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access

# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=b32 -S openat -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b32 -S openat -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S openat -F exit=-EACCES -F auid>=1000 -F auid!=unset -F key=access
-a always,exit -F arch=b64 -S openat -F exit=-EPERM -F auid>=1000 -F auid!=unset -F key=access


Убедитесь, что auditd собирает данные о действиях системного администратора:
Обоснование
Действия, предпринимаемые системными администраторами, должны подвергаться аудиту для ведения учета того, что было выполнено в системе, а также в целях подотчетности.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-w /etc/sudoers -p wa -k actions
-w /etc/sudoers.d/ -p wa -k actions

Запись событий, которые изменяют сетевую среду системы:
Обоснование
Сетевая среда не должна изменяться кем-либо, кроме администратора. Любые изменения сетевых параметров должны подвергаться аудиту.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S sethostname,setdomainname -F key=audit_rules_networkconfig_modification
-w /etc/issue -p wa -k audit_rules_networkconfig_modification
-w /etc/issue.net -p wa -k audit_rules_networkconfig_modification
-w /etc/hosts -p wa -k audit_rules_networkconfig_modification
-w /etc/sysconfig/network -p wa -k audit_rules_networkconfig_modification

Запись попыток изменить информацию об инициировании процесса и сеанса:
Обоснование
Ручное редактирование этих файлов может указывать на злонамеренную деятельность, например, на попытку злоумышленника удалить доказательства вторжения.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-w /var/run/utmp -p wa -k session
-w /var/log/btmp -p wa -k session
-w /var/log/wtmp -p wa -k session

Сделайте конфигурацию auditd неизменяемой:
Обоснование
Неизменяемость конфигурации аудита предотвращает как случайное, так и злонамеренное изменение правил аудита, хотя это может быть проблематично, если в процессе работы системы потребуются законные изменения.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-e 2

Запись событий, которые изменяют информацию о пользователе/группе:
Обоснование
Помимо аудита новых учётных записей пользователей и групп, эти средства мониторинга будут оповещать системного администратора(ов) о любых изменениях. Любые непредвиденные пользователи, группы или изменения должны быть проверены на легитимность.

Решение
/etc/shadow
# Add to /etc/audit/rules.d/extended.rules
-w /etc/shadow -p wa -k audit_rules_usergroup_modification

/etc/security/opasswd
# Add to /etc/audit/rules.d/extended.rules
-w /etc/security/opasswd -p wa -k audit_rules_usergroup_modification

/etc/gshadow
# Add to /etc/audit/rules.d/extended.rules
-w /etc/gshadow -p wa -k audit_rules_usergroup_modification

/etc/passwd
# Add to /etc/audit/rules.d/extended.rules
-w /etc/passwd -p wa -k audit_rules_usergroup_modification

/etc/group
# Add to /etc/audit/rules.d/extended.rules
-w /etc/group -p wa -k audit_rules_usergroup_modification


Убедитесь, что auditd собирает информацию об экспорте на носитель:
Обоснование
Несанкционированный экспорт данных на внешние носители может привести к утечке информации, в результате которой могут быть утрачены конфиденциальная информация, информация, предусмотренная Законом о конфиденциальности, и интеллектуальная собственность. Для каждого монтирования файловой системы необходимо создавать контрольный журнал, чтобы помочь выявить и предотвратить потерю информации.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-a always,exit -F arch=ARCH -S mount -F auid>=1000 -F auid!=unset -F key=export

Запись событий, которые изменяют обязательные элементы управления доступом системы:
Обоснование
Политика обязательного доступа системы (SELinux) не должна произвольно изменяться кем-либо, кроме администратора. Все изменения политики MAC должны проходить аудит.

Решение
Установите значение
# Add to /etc/audit/rules.d/extended.rules
-w /etc/selinux/ -p wa -k MAC-policy

###########################################################

