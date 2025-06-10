#!/bin/bash

source ./common.sh

check_rootuser

app_setup

golang_setup

systemd_setup

print_time