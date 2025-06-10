#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_rootuser

echo "Enter rabbitmq password" | tee -a $LOG_FILE
read -s RABBITMQ_PASSWORD

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Copying rabbitmq repo file"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing rabbitmq"

systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling rabbitmq"

systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Starting rabbitmq"

rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" 

print_time