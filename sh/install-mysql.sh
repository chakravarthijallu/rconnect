#!/bin/bash

function checkMysql () {
     sudo dpkg -s mysql-server-8.0 2>> /dev/null >> /dev/null
     local CHECKMYSQLSTATUS=$?
     if [ $CHECKMYSQLSTATUS -ne 0 ]
     then
         echo "PLEASE INSTALL MYSQL SERVER"
         installMysql
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
checkMysql
