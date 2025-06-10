#!/bin/bash

source ./common.sh
app_name=catalogue

check_rootuser

app_setup

nodejs_setup

systemd_setup

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$LOG_FILE
VALIDATE $? "Copying MongoDB repo file"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB Client"

STATUS=$(mongosh --host mongodb.bittu27.site --eval 'db.getMongo().getDBNames().indexOf("catalogue")') 
if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.bittu27.site </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already Loaded... $Y SO SKIPPING $N"
fi

print_time