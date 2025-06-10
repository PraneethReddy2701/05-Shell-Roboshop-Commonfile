#!/bin/bash

source ./common.sh
app_name=redis

check_rootuser


dnf module disable redis -y  &>>$LOG_FILE
VALIDATE $? "Disabling the redis default version"

dnf module enable redis:7 -y  &>>$LOG_FILE
VALIDATE $? "Enabling the redis:7 version"

dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf  &>>$LOG_FILE
VALIDATE $? "Changing redis.conf to accept remote connections"

systemctl enable redis   &>>$LOG_FILE
VALIDATE $? "Enabling redis"

systemctl start redis   &>>$LOG_FILE
VALIDATE $? "Starting redis"

print_time