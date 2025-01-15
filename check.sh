#!/bin/bash

datetime=$(date "+%d-%m-%Y %H:%M:%S")  # dia/mes/ano  horas:minutos:segundos
red='\033[0;31m'  # define a cor vermelha segundo o codigo ANSI
green='\033[0;32m'  # define a cor verde usando o mesmo codigo ANSI
nocolor='\033[0m'  # texto sem cor
service="nginx"

if [ "$(systemctl is-active $service)" = "active" ]; then
  echo -e "$datetime ${green}[OK] O servidor $service está online!${nocolor}" >> /var/log/nginx-server/checkOn.log
else
  echo -e "$datetime ${red}[ERROR] O servidor $service está offline!${nocolor}" >> /var/log/nginx-server/checkOff.log
fi
