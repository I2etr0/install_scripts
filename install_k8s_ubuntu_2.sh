#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo "${bold} Установка CRI-O ${normal}"

# задаем переменные, которые пригодятся нам для того, чтобы скачать необходимую версию Crio для определенной версии ОС
export OS=xUbuntu_22.04
export CRIO_VERSION=1.25

# Добавляем  репозитории openSUSE в систему
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /"| tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /"| tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

# Импортируем GPG-ключи от репозиториев
sudo curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/Release.key | apt-key add -
sudo curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

# Обновляем списки репозиториев и устанавливаем CRIO
sudo apt update 
sudo apt -y install cri-o cri-o-runc cri-tools

# Запускаем crio и добавляем его в автозагрузку
sudo systemctl start crio 
sudo systemctl enable crio

# Проверяем статус crio:
systemctl status crio

echo "${bold} Установка K&S ${normal}"

# Добавляем GPG-ключ от репозитория Kubernetes и  подключаем официальный репозиторий
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Обновляем списки репозиториев, устанавливаем пакеты kubelet, kubeadm, kubectl
apt update && apt -y install kubelet kubeadm kubectl && apt-mark hold kubelet kubeadm kubectl

# Инициализируем мастер-ноду а также выделяем подсеть, адреса которой будут назначаться подам в кластере
kubeadm init --pod-network-cidr=10.244.0.0/16

# Выполняем шаги, перечисленные в конце вывода, а именно
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Выводим список всех нод кластера
kubectl get nodes

# Выводим список всех подов в кластере
kubectl get po -A

# Установка flannel выполняем команду
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

# Проверка статуса запущенных подов
kubectl get po -n kube-flannel