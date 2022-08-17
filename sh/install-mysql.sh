#!/bin/bash

function checkDebconfigInstalled () {
    sudo dpkg -s debconf-utils 2>> /dev/null >> /dev/null
    local CHECKDEBCONFINSTALLED=$?
    if [ $CHECKDEBCONFINSTALLED -ne 0 ]
    then
        #echo "DEBCONF UNTIL IS NOT INSTALLED"
        #installDebconf
        return 1
    else
        #echo "DEBCONF UNTIL IS INSTALLED"
        #checkMysqlInstalled
        return 0
    fi
}



function installDebconf () {
    sudo apt install -y debconf-utils 2>> /dev/null >> /dev/null
    local DEBCONFIGINSTALLSTATUS=$?
    if [ $DEBCONFIGINSTALLSTATUS -ne 0 ]
    then
        #echo "DEBCONFIG UNTIL IS NOT INSTALLED PROPERLY"
        #exit
        return 2
    else
        echo "DEBCONFIG UNTIL IS INSTALLED PROPERLY"
        echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
        echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
        #installMysql
        return 0
    fi
}

function checkMysqlInstalled () {
     sudo dpkg -s mysql-server-8.0 2>> /dev/null >> /dev/null
     local CHECKMYSQLSTATUS=$?
     if [ $CHECKMYSQLSTATUS -ne 0 ]
     then
         #echo "PLEASE INSTALL MYSQL SERVER"
         #installMysql
         return 3
     else
         #echo "MYSQL IS ALREADY INSTALLED"
         return 0
     fi
}

function installMysql () {
     sudo apt install -y mysql-server-8.0 2>> /dev/null >> /dev/null
     local MYSQLINSTALLSTATUS=$?
     if [ $MYSQLINSTALLSTATUS -ne 0 ]
     then
         #echo "MYSQL DB IS NOT INSTALLED PROPERLY"
         #exit
         return 4
     else
         #echo "MYSQL SERVER INSTALLED SUCCESSFULLY"
         return 0
     fi
}


# Main 
checkDebconfigInstalled
CHECKDEBCONFSTATUS=$?
if [ $CHECKDEBCONFSTATUS -ne 0 ]
then
   echo "DEBCONF UNTIL IS NOT INSTALLED"
   installDebconf
   INSTALLDEBCONFSTATUS=$?
   if [ $INSTALLDEBCONFSTATUS -ne 0 ]
   then
      echo "DEBCONFIG UNTIL IS NOT INSTALLED PROPERLY"
      exit 
   else
      installMysql
      MYSQLINSTALLSTATUS=$?
      if [ $MYSQLINSTALLSTATUS -ne 0 ]
      then
         echo "MYSQL SERVER IS NOT INSTALLED"
         exit
      else
         echo "MYSQL SERVER INSTALLED SUCCESSFULLY"
      fi
   fi
else
   echo "DEBCONF UNTIL IS INSTALLED"
   checkMysqlInstalled
   CHECKMYSQLINSTALLSTATUS=$?
   if [ $CHECKMYSQLINSTALLSTATUS -ne 0 ]
   then
      echo "PLEASE INSTALL MYSQL SERVER"
      installMysql
   else
      echo "MYSQL IS ALREADY INSTALLED"
   fi
fi
