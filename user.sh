#!/bin/bash

source ./common.sh
app_name=user

check_rootuser

app_setup

nodejs_setup

systemd_setup

print_time
