#!/bin/bash

source ./common.sh

check_rootuser

app_setup

python_setup

systemd_setup

print_time