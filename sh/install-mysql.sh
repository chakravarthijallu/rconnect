#!/bin/bash

function checkMysql() {
    sudo dpkg -s mysql-server-8.0 2>> /dev/null >> /dev/null
    local MYSQLSERVERINSTALL=$?
    if [ $MYSQLSERVERINSTALL -ne 0 ]
    then
       echo "MYSQL SERVER IS NOT INSTALLED PLEASE INSTALL IT"
        
    else
       echo "MYSQL SERVER IS INSTALLED PROPERLY "
    fi
}

function installMysql() {
    sudo apt install -y mysql-server-8.0 2>> /dev/null >> /dev/null
} 