#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# Обновляем списки репозиториев, производим обновление всех пакетов в ОС, а также устанавливаем необходимые пакеты
echo "update system"
sleep 3

sudo apt update 
sudo apt -y upgrade 
sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Выполняем команду и сохраняем её вывод в переменную
output=$(free -h 2>&1)

# Проверяем, пустой ли вывод
echo "Проверяем, пустой ли вывод"
sleep 3
if [ -z "$output" ]; then
    # Если вывод пустой, выполняем одно действие
    echo "${bold} Вывод команды пуст. Продолжаем выполнение скрипта.${normal}"
    # Здесь можно добавить дополнительные команды
else
    # Если вывод не пустой, выполняем другое действие
    echo "Команда вернула следующий вывод:"
    echo "$output"
    swapoff -a

    # Файл, который нужно изменить
    file="/etc/fstab"

    # Строка, которую нужно закомментировать
    target_line="/swap.img       none    swap    sw      0       0"

    # Закомментировать строку, добавив "#" в начало
    sudo sed -i "s/^$target_line/#$target_line/" "$file"
fi

# Загружаем дополнительные сетевые модули из ядра операционной системы
echo "Загружаем дополнительные сетевые модули из ядра операционной системы"
sleep 3
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Загружаем ранее указанные модули
echo "Загружаем ранее указанные модули"
sleep 3
modprobe overlay
modprobe br_netfilter

# Проверяем, что сетевые модули были успешно загружены и активированы
echo "Проверяем, что сетевые модули были успешно загружены и активированы"
sleep 3
lsmod | egrep "br_netfilter|overlay"

# Активируем соответствующие сетевые параметры
echo "Активируем соответствующие сетевые параметры"
sleep 3
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Перезапускаем параметры ядра
echo "Перезапускаем параметры ядра"
sleep 3
sysctl --system

# Выключаем и убираем из автозагрузки UFW
echo "Выключаем и убираем из автозагрузки UFW"
sleep 3
systemctl stop ufw && systemctl disable ufw


echo -n "${bold} Ready for REBOOT? (Y/n) ${normal}"
read answer

if [[ "$answer" == "Y" || "$answer" == "y"]]; then
    echo "OK. Rebooting"
    sleep 3
    reboot
else
    echo "OK. System not reboot. Exit from script"
    exit 1