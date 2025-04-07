#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Обновляем списки репозиториев, производим обновление всех пакетов в ОС, а также устанавливаем необходимые пакеты
echo "${bold}Update system ${normal}"
sleep 3

sudo apt update 
sudo apt -y upgrade 
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Выполняем команду и сохраняем её вывод в переменную
output=$(free -h 2>&1)

# Делаем бекап /etc/fstab
echo "${bold}Делаем бекап /etc/fstab${normal}"
sleep 3
sudo cp /etc/fstab /etc/fstab.bak 

# Проверяем, пустой ли вывод
echo "${bold}Проверяем, пустой ли вывод ${normal}"
sleep 3
if [ -z "$output" ]; then
    # Если вывод пустой, выполняем одно действие
    echo "${bold}Вывод команды пуст. Продолжаем выполнение скрипта. ${normal}"
    # Здесь можно добавить дополнительные команды
else
    # Если вывод не пустой, выполняем другое действие
    echo "${bold}Команда вернула следующий вывод: ${normal}"
    echo "$output"
    echo "${bold}Отключаем swap командой swapoff -a ${normal}"
    swapoff -a

    # # Файл, который нужно изменить
    # file="/etc/fstab"

    # # Строка, которую нужно закомментировать
    # target_line="/swap.img       none    swap    sw      0       0"

    # # Закомментировать строку, добавив "#" в начало
    # sudo sed -i "s/^$target_line/#$target_line/" "$file"
fi

# Загружаем дополнительные сетевые модули из ядра операционной системы
echo "${bold}Загружаем дополнительные сетевые модули из ядра операционной системы ${normal}"
sleep 3
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Загружаем ранее указанные модули
echo "${bold}Загружаем ранее указанные модули ${normal}"
sleep 3
modprobe overlay
modprobe br_netfilter

# Проверяем, что сетевые модули были успешно загружены и активированы
echo "${bold}Проверяем, что сетевые модули были успешно загружены и активированы ${normal}"
sleep 3
lsmod | egrep "br_netfilter|overlay"

# Активируем соответствующие сетевые параметры
echo "${bold}Активируем соответствующие сетевые параметры ${normal}"
sleep 3
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Перезапускаем параметры ядра
echo "${bold}Перезапускаем параметры ядра ${normal}"
sleep 3
sysctl --system

# Выключаем и убираем из автозагрузки UFW
echo "${bold}Выключаем и убираем из автозагрузки UFW ${normal}"
sleep 3
systemctl stop ufw && systemctl disable ufw


echo -n "${bold} Ready for REBOOT? [Y/n] ${normal}"
read answer

# Проверяем ответ
if [[ -z "$answer" || "$answer" == "Y" || "$answer" == "y" ]]; then
    echo "${bold}OK. Rebooting...${normal}"
    sleep 3
    reboot
else
    echo "${bold}OK. System not reboot. Exit from script.${normal}"
    exit 1
fi