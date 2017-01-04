#!/bin/bash

# #################################################################
# Zen Deploy Script
# -----------------
# version:      4.0
# author:       Tomas Mulder
# repo:         git@github.com:tcmulder/bash-deploy.git
# #################################################################

# -----------------------------------------------------------------
# Source required functions
# -----------------------------------------------------------------

# establish common functions
source "$dir_script"/app/common_functions.sh;

# check for updates
source "$dir_script"/app/update.sh;

# main zen script
source "$dir_script"/app/zen.sh;
