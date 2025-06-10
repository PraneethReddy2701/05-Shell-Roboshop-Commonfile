#!/bin/bash

source ./common.sh
app_name=user

check_rootuser

nodejs_setup

app_setup

systemd_setup

print_time
