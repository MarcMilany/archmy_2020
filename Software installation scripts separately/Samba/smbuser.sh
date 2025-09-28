#!/bin/bash
echo ""
#Добавляет пользователя в группу, группа должна существовать.
echo "Для добавления учетных записей пользователя Linux и SAMBA введите Имя Пользователя и Название его рабочей группы (группа должна существовать)."
user_name=""
while [ "${user_name}" = "" ]
do
echo Введите имя добавляемого пользователя:
read user_name
done
echo Введите название группы, в которую добавить пользователя:
read group_name
if [ "`cat /etc/group | grep ${group_name}`" = "" ]
then
Группы с таким именем не существует.
else
echo Добавление учетной записи пользователя ${user_name} в группу ${group_name}...
sudo useradd -m -g ${group_name} ${user_name}
echo Добавление учетной записи пользователя ${user_name} SAMBA...
sudo smbpasswd -a ${user_name}
echo Включение учетной записи SAMBA ${user_name}...
sudo smbpasswd -e ${user_name}
fi