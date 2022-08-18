#!/bin/bash

# Check the DebConf Installed or Not
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


# Install DebConf-utils 
function installDebconf () {
    sudo apt update -y
    sudo apt install -y debconf-utils 2>> /dev/null
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

# Check the Mysql Database Server is Installed or Not
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

# Install Mysql Database Server
function installMysql () {
     sudo apt update -y
     sudo apt install -y mysql-server-8.0 2>> /dev/null
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

function runSecureInstall () {
	sudo apt install -y expect
	./noninteractive.sh
	local SECUREINSTALLSTATUS=$?
	if [ $SECUREINSTALLSTATUS -ne 0 ]
	then
		return 5
	else
		return 0
	fi

}

function addBindAddress () {
	sudo sed -i "/^bind-address/ s/127\.0\.0\.1/0\.0\.0\.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
       	local BINDSTATUS=$?
	if [ $BINDSTATUS -ne 0 ]
	then
		return 6
	else
		return 0
	fi
}

function addUser () {
	sudo mysql -uroot -proot < add-user.sql 2>> /dev/null
	local USERSTATUS=$?
	if [ $USERSTATUS -ne 0 ]
	then
		return 7
	else
		return 0
	fi
}


function createDBSchema () {
	sudo mysql -urconnectuser -pwelcome1 < dbschema.sql 2>> /dev/null
	local DBSTATUS=$?
	if [ $DBSTATUS -ne 0 ]
	then
		return 8
	else
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
      MYSQLINSTALLSTATUS2=$?
      if [ $MYSQLINSTALLSTATUS2 -ne 0 ]
      then
         echo "MYSQL SERVER IS NOT INSTALLED PROPERLY"
         exit
      else
         echo "MYSQL SERVER INSTALLED SUCCESSFULLY"
      fi
   else
      echo "MYSQL IS ALREADY INSTALLED"
   fi
fi

runSecureInstall
SECUREINSTALLSTATUS=$?
if [ $SECUREINSTALLSTATUS -ne 0 ]
then
     echo "MYSQL SECURE INSTALLATION IS NOT CONFIGURED PROPERLY"
     exit
else
     echo "MYSQL SECURE INSTALLATION IS SUCCESSFULL"
fi

addBindAddress
BINDADDRESSSTATUS=$?
if [ $BINDADDRESSSTATUS -ne 0 ]
then
	echo "BIND ADDRESS IS NOT FAILED"
	exit
else
	echo "BIND ADDRESS IS SUCCESSFULL"
	sudo systemctl restart mysql
fi

addUser
ADDUSERSTATUS=$?
if [ $ADDUSERSTATUS -ne 0 ]
then
	echo "USER IS ALREADY THERE"
else
	echo "USER IS ADDED SUCCESSFULLY"
fi

createDBSchema
CREATEDBSCHEMASTATUS=$?
if [ $CREATEDBSCHEMASTATUS -ne 0 ]
then
	echo "DB SCHEMA IS ALREADY THERE"
else
	echo "DB SCHEMA IS ADDED SUCCESSFULLY"
fi
