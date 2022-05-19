#!/bin/bash

function logo {
  curl -s https://raw.githubusercontent.com/95brsu/tools/main/nuts.sh | bash
}

function line {
  echo "----20.05.2022--------------------------------------------------------------------"
}

function colors {
  GREEN="\e[1m\e[32m"
  RED="\e[1m\e[39m"
  NORMAL="\e[0m"
}


function pool {

source ~/.bash_profile
KEY=$(ironfish accounts:publickey  | grep "public key:" | awk '{print $5}')
echo "[Unit]
Description=IronFish Pool
After=network-online.target
[Service]
User=$USER
ExecStart=/usr/bin/yarn --cwd $HOME/ironfish/ironfish-cli/ start miners:start -t -1 --pool pool.ironfish.host --address $KEY --no-richOutput -v 
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/ironfishd-pool.service

sudo mv $HOME/ironfishd-pool.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl stop ironfishd-miner
sudo systemctl disable ironfishd-miner
sudo systemctl enable ironfishd-pool
sudo systemctl restart ironfishd-pool
sudo service ironfishd-pool status

}



colors

line
logo
line
echo -e "${RED}подключаемся к пулу${NORMAL}"
pool
line
line
echo -e "${RED}Скрипт завершил свою работу!!!Извините за внимание!${NORMAL}"
