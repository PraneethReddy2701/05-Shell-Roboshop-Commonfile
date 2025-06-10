#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_rootuser

echo "Enter rabbitmq password" | tee -a $LOG_FILE
read -s RABBITMQ_PASSWORD

systemd_setup

rabbitmqctl add_user roboshop $RABBITMQ_PASSWORD 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" 

print_time