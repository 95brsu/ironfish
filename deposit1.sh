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


function deposit {
 sudo apt-get install -y php-cli
 wget -q -O ~/deposit.php https://raw.githubusercontent.com/95brsu/ironfish/main/deposit.php
 crontab -l | grep -v 'deposit.php' | crontab -
(crontab -l ; echo '*/15 * * * * php ~/deposit.php >> ~/deposit.log 2>>~/deposit.log') | crontab -
}



colors

line
logo
line
echo -e "${RED}Устанавливаем АВТОДЕПОЗИТ${NORMAL}"
deposit
line
line
echo -e "${RED}Скрипт завершил свою работу!!!<< tail -F ~/deposit.log >> ${NORMAL}"
