#!/bin/bash

source ./common.sh
app_name=shipping

check_rootuser

echo "Enter Mysql Root password" 
read -s MYSQL_ROOT_PASSWD

app_setup
maven_setup
systemd_setup

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "Installing Mysql client"


mysql -h mysql.bittu27.site -u root -p$MYSQL_ROOT_PASSWD -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.bittu27.site -uroot -p$MYSQL_ROOT_PASSWD < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.bittu27.site -uroot -p$MYSQL_ROOT_PASSWD < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h mysql.bittu27.site -uroot -p$MYSQL_ROOT_PASSWD < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Loading data into shipping"
else
    echo -e "Data is already loaded $Y SO SKIPPING $N"
fi

systemctl restart shipping &>>$LOG_FILE
VALIDATE $? "Restart shipping"

print_time