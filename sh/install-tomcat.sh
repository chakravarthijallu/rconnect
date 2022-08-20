#!/bin/bash

function checkOpenJdk () {
        sudo dpkg -s openjdk-11-jdk 2>> /dev/null
	local CHECKJDK=$?
	if [ $CHECKJDK -ne 0 ]
	then
		return 4
	else
		return 0
	fi
}

function installJdk () {
	sudo apt update -y 2>> /dev/null
	sudo apt install -y openjdk-11-jdk 2>> /dev/null
	local INSTALLJDK=$?
	if [ $INSTALLJDK -ne 0 ]
	then
		return 5
	else
		return 0
	fi
}

function checkTomcatServer () {
	find "/home/ubuntu" -type d -name "*apache-tomcat*" | grep -i "apache-tomcat" 2>> /dev/null
	local CHECKTOMCATSERVER=$?
	if [ $CHECKTOMCATSERVER -ne 0 ]
	then
		return 1
	else
		return 0
	fi
}



function installTomcatServer () {
	wget -O /home/ubuntu/apache-tomcat-9.0.65.tar.gz https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz 2>> /dev/null
	local INSTALLTOMCATSERVER=$?
	if [ $INSTALLTOMCATSERVER -ne 0 ]
	then
		return 2
	else 
		return 0
	fi
}

function extractApacheTomcat () {
	tar -xzvf /home/ubuntu/apache-tomcat-9.0.65.tar.gz -C /home/ubuntu/ 2>> /dev/null
	rm -f /home/ubuntu/apache-tomcat-9.0.65.tar.gz
}

function checkAndDeleteWarFile () {
	find "/home/ubuntu/apache-tomcat-9.0.65/webapps" -name "*rconnect*" -exec rm -rf {} \;
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
checkOpenJdk
CHECKOPENJDKSTATUS=$?
if [ $CHECKOPENJDKSTATUS -ne 0 ]
then
	echo "Jdk Software is not installed"
	installJdk
	INSTALLJDKSTATUS=$?
	if [ $INSTALLJDKSTATUS -ne 0 ]
	then
		echo "Jdk Software is not installed properly."
		exit
	else
		echo "Jdk Software is installed successfully."
	fi
else
	echo "Jdk Software is installed"
fi

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
		extractApacheTomcat
else
	echo "Apache Tomcat Server is Already Available."
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
