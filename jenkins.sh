#!/bin/bash

#Desription: Automates installation of Jenkins
#Author: James K
#Date: March 16, 2022

#Checking if user is root

if [ ${USER} = root ]
then
echo "You cannot install Jenkins as root user, please log in as regular user"
sleep 2
exit 1
else
echo "You are a regular user, the installation will proceed...."
sleep 2
fi

#Installing Java
echo "Installing Java..."
sleep 2
sudo yum install java-1.8.0-openjdk-devel -y
if [ $? -ne 0 ]
then
echo "Failed to install Java"
exit 2
fi

#Enabling the Jenkins repository
echo "Enabling the jenkins repository..."
sleep 2
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo -y

if [ $? -ne 0 ]
then
sudo yum install wget -y
sleep 1
fi
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo -y
sudo sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo -y

if [ $? -ne 0 ]
then
echo "Failed to enable Jenkins repository"
exit 3
fi

#Installing the latest stable version of jenkins
echo "Installing the latest stable version of jenkins...."
sleep 2
sudo yum install jenkins -y
if [ $? -ne 0 ]
then
echo " Failed to install the latest version of jenkins.."
sleep 2
sudo systemctl start jenkins -y
sudo systemctl status jenkins -y
sudo systemctl enable jenkins -y
fi

#Adjusting firewall
echo Adjusting firewall..."
sleep 2
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp -y
sudo firewall-cmd --reload -y

echo "To set up the jenkins page on your browser, type the IP address below followed by the port 8080 as shown below:hostname -I |awk -F '{print$2}':8080
