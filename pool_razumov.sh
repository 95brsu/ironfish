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
 source ~/.profile
 KEY=$(ironfish accounts:publickey  | grep "public key:" | awk '{print $5}')
 
 sudo tee <<EOF >/dev/null $HOME/docker-compose.yaml
version: "3.3"
services:
 ironfish:
  container_name: ironfish
  image: ghcr.io/iron-fish/ironfish:latest
  restart: always
  entrypoint: sh -c "sed -i 's%REQUEST_BLOCKS_PER_MESSAGE.*%REQUEST_BLOCKS_PER_MESSAGE = 5%' /usr/src/app/node_modules/ironfish/src/syncer.ts && apt update > /dev/null && apt install curl -y > /dev/null; ./bin/run start"
  healthcheck:
   test: "curl -s -H 'Connection: Upgrade' -H 'Upgrade: websocket' http://127.0.0.1:9033 || killall5 -9"
   interval: 180s
   timeout: 180s
   retries: 3
  volumes:
   - $HOME/.ironfish:/root/.ironfish
 ironfish-miner:
  depends_on:
   - ironfish
  container_name: ironfish-miner
  image: ghcr.io/iron-fish/ironfish:latest
  command: miners:start -v --pool pool.ironfish.network --address $KEY --threads=1
  restart: always
  volumes:
   - $HOME/.ironfish:/root/.ironfish
EOF

docker-compose up -d
}



colors

line
logo
line
echo -e "${RED}Устанавливаем ПУЛ${NORMAL}"
pool
line
line
echo -e "${RED}Скрипт завершил свою работу!!! Извините за внимание${NORMAL}"
