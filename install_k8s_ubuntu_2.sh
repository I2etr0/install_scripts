#!/bin/bash

sudo mount -o remount,rw /

bold=$(tput bold)
normal=$(tput sgr0)

#отключаем swap
echo "${bold} Повторно отключаем SWAP ${normal}"
swapoff -a

echo "${bold} Установка CRI-O ${normal}"
sleep 3
# задаем переменные, которые пригодятся нам для того, чтобы скачать необходимую версию Crio для определенной версии ОС
export OS=xUbuntu_22.04
export CRIO_VERSION=1.28w

# Добавляем  репозитории openSUSE в систему
echo "${bold} Добавляем  репозитории openSUSE ${normal}"
sleep 3
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.28/xUbuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
# Импортируем GPG-ключи от репозиториев
sudo curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.28/xUbuntu_22.04/Release.key | apt-key add -
sudo curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/Release.key | apt-key add -

# Обновляем списки репозиториев и устанавливаем CRIO
echo "${bold} Обновляем списки репозиториев и устанавливаем CRIO ${normal}"
sleep 3
sudo apt update 
sudo apt -y install cri-o cri-o-runc cri-tools

# Запускаем crio и добавляем его в автозагрузку
echo "${bold} Запускаем crio ${normal}"
sleep 3
sudo systemctl start crio 
sudo systemctl enable crio

# Проверяем статус crio:
echo "${bold} Проверяем статус crio ${normal}"
sleep 3
systemctl status crio

echo "${bold} Установка K&S ${normal}"
sleep 3

# Добавляем GPG-ключ от репозитория Kubernetes и  подключаем официальный репозиторий
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Обновляем списки репозиториев, устанавливаем пакеты kubelet, kubeadm, kubectl
echo "${bold} Установка kubelet, kubeadm, kubectl ${normal}"
sleep 3
apt update && apt -y install kubelet kubeadm kubectl && apt-mark hold kubelet kubeadm kubectl

# Инициализируем мастер-ноду а также выделяем подсеть, адреса которой будут назначаться подам в кластере
echo "${bold} Инициализируем мастер-ноду ${normal}"
sleep 3
kubeadm init --pod-network-cidr=10.244.0.0/16

# Выполняем шаги, перечисленные в конце вывода, а именно
echo "${bold} Выполняем шаги, перечисленные в конце вывода ${normal}"
sleep 3
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Выводим список всех нод кластера
echo "${bold} Выводим список всех нод кластера ${normal}"
sleep 3
kubectl get nodes

# Выводим список всех подов в кластере
echo "${bold} Выводим список всех подов в кластере ${normal}"
sleep 3
kubectl get po -A

# Установка flannel выполняем команду
echo "${bold} Установка flannel выполняем команду ${normal}"
sleep 3
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

# Проверка статуса запущенных подов
echo "${bold} Проверка статуса запущенных подов ${normal}"
sleep 3
kubectl get po -n kube-flannel