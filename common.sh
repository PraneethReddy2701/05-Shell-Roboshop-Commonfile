#!/bin/bash

START_TIME=$(date +%s)
USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script started running at : $(date)"

check_rootuser()
{
    if [ $USER_ID -ne 0 ]
    then
        echo -e "ERROR : $R Please run the script with root access $N" | tee -a $LOG_FILE
        exit 1
    else
        echo "Running the script with root user"  | tee -a $LOG_FILE
    fi
}

VALIDATE()
{
    if [ $1 -eq 0 ]
    then
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

app_setup()
{
    id roboshop
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "Creating the roboshop system user"
    else
        echo -e "System user roboshop is already created.. $Y SO SKIPPING $N" 
    fi

    mkdir -p /app &>>$LOG_FILE
    VALIDATE $? "Creating the app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
    VALIDATE $? "Downloading the $app_name code"

    rm -rf /app/*
    cd /app
    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Unzipping the $app_name code"
}

nodejs_setup()
{
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disabling the nodejs default version"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "Enabling the nodejs:20 version"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "Installing Nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "Download dependencies"
}

maven_setup()
{
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "Installing Maven and Java"

    mvn clean package &>>$LOG_FILE
    VALIDATE $? "Downloading dependencies"

    mv target/shipping-1.0.jar shipping.jar  &>>$LOG_FILE
    VALIDATE $? "Copying and renaming Shipping jar file"
}

python_setup()
{
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "Installing python3"

    pip3 install -r requirements.txt &>>$LOG_FILE
    VALIDATE $? "Downloading the dependencies"

    # cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    # VALIDATE $? "Copying the $app_name service file"
}

golang_setup()
{
    dnf install golang -y &>>$LOG_FILE
    VALIDATE $? "Installing golang"

    go mod init dispatch &>>$LOG_FILE
    go get  &>>$LOG_FILE
    go build &>>$LOG_FILE
    VALIDATE $? "Downloading dependencies"
}

systemd_setup()
{
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    VALIDATE $? "Copying the $app_name service file"

    systemctl daemon-reload &>>$LOG_FILE
    VALIDATE $? "Daemon-reload"

    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "Enabling $app_name"

    systemctl start $app_name &>>$LOG_FILE
    VALIDATE $? "Starting $app_name"
}

print_time()
{
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))

    echo -e "Script executed successfully. Time taken : $Y $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
}