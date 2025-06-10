#!/bin/bash

source ./common.sh
app_name=mysql

check_rootuser

echo "Please enter the Mysql root password"  | tee -a $LOG_FILE
read -s MYSQL_ROOT_PASSWORD

dnf install mysql-server -y  &>>$LOG_FILE
VALIDATE $? "Installing Mysql"

systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "Enabling Mysql"

systemctl start mysqld   &>>$LOG_FILE
VALIDATE $? "Starting Mysql"

mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD  &>>$LOG_FILE
VALIDATE $? "Setting Mysql root password"

print_time