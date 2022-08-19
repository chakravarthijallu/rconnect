#!/bin/bash

function checkTomcatServer () {
	find "/home/ubuntu" -type d -name "*apache-tomcat*" | grep -i "apache-tomcat"
	local CHECKTOMCATSERVER=$?
	if [ $CHECKTOMCATSERVER -ne 0 ]
	then
		return 1
	else
		return 0
	fi
}


function installTomcatServer () {
	wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
	local INSTALLTOMCATSERVER=$?
	if [ $INSTALLTOMCATSERVER -ne 0 ]
	then
		return 2
	else 
		return 0
	fi
}

function checkAndDeleteWarFile () {
	find "apache-tomcat-9.0.65/webapps" -name "*rconnect*" -exec rm -rf {} \;

}

function deployWarFile () {
	sudo cp /vagrant/build/dist/rconnect.war /home/ubuntu/apache-tomcat-9.0.65/webapps/
	./startup.sh
	local FILEDEPLOY=$?
	if [ $FILEDEPLOY -ne 0 ]
	then
		return 3
	else
		return 0
	fi
}

# main method
checkTomcatServer
CHECKTOMCATSERVERSTATUS=$?
if [ $CHECKTOMCATSERVERSTATUS -ne 0 ]
then
	echo "Tomcat Server is not Installed"
	installTomcatServer
	TOMCATINSTALLSTATUS=$?
	if [ $TOMCATINSTALLSTATUS -ne 0 ]
	then
		echo "Tomcat Server is not Installed Properly"
		exit
	else
		echo "Tomcat Server is Installed Successfully"
else
	echo "Tomcat server is Installed"
fi


checkAndDeleteWarFile
deployWarFile
DEPLOYWARSTATUS=$?
if [ $DEPLOYWARSTATUS -ne 0 ]
then
	echo "File is not deployed and not Started "
	exit
else
	echo "File is deployed Successfully"
fi
