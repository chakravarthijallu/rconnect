#!/bin/bash

function checkDebconfigInstalled () {
    sudo dpkg -s debconf-utils 2>> /dev/null >> /dev/null
    local CHECKDEBCONFINSTALLED=$?
    if [ $CHECKDEBCONFINSTALLED -ne 0 ]
    then
        echo "DEBCONF UNTIL IS NOT INSTALLED"
        installAndDebconf
    else
        echo "DEBCONF UNTIL IS INSTALLED"
        checkMysqlInstalled
    fi
}



function installAndDebconf () {
    sudo apt install -y debconf-utils 2>> /dev/null >> /dev/null
    local DEBCONFIGINSTALLSTATUS=$?
    if [ $DEBCONFIGINSTALLSTATUS -ne 0 ]
    then
        echo "DEBCONFIG UNTIL IS NOT INSTALLED PROPERLY"
        exit
    else
        echo "DEBCONFIG UNTIL IS INSTALLED PROPERLY"
        echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
        echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
        installMysql
    fi
}

function checkMysqlInstalled () {
     sudo dpkg -s mysql-server-8.0 2>> /dev/null >> /dev/null
     local CHECKMYSQLSTATUS=$?
     if [ $CHECKMYSQLSTATUS -ne 0 ]
     then
         echo "PLEASE INSTALL MYSQL SERVER"
         installAndConfigureDebconf
     else
         echo "MYSQL IS ALREADY INSTALLED"
     fi
}

function installMysql () {
     sudo apt install -y mysql-server-8.0 2>> /dev/null >> /dev/null
     local MYSQLINSTALLSTATUS=$?
     if [ $MYSQLINSTALLSTATUS -ne 0 ]
     then
         echo "MYSQL DB IS NOT INSTALLED PROPERLY"
         exit
     else
         echo "MYSQL SERVER INSTALLED SUCCESSFULLY"
     fi
}


# Main 
checkDebconfigInstalled
