#!/bin/bash

source ./common.sh
app_name=payment

check_rootuser

app_setup

python_setup

systemd_setup

print_time