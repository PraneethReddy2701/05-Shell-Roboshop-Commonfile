#!/bin/bash

source ./common.sh
app_name=frontend

check_rootuser

dnf module disable nginx -y &>>$LOG_FILE
VALIDATE $? "Disabling default nginx version"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "Enabling the nginx 1.24 version"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOG_FILE
VALIDATE $? "Removing the default frontend content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip  &>>$LOG_FILE
VALIDATE $? "Downloading the frontend content" 

cd /usr/share/nginx/html
unzip /tmp/frontend.zip  &>>$LOG_FILE
VALIDATE $? "Unzipping frontend content"

rm -rf /etc/nginx/nginx.conf  &>>$LOG_FILE
VALIDATE $? "Removing default nginx content"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf  &>>$LOG_FILE
VALIDATE $? "Copying the nginx conf file"

systemctl restart nginx  &>>$LOG_FILE
VALIDATE $? "Restarting the nginx"

print_time