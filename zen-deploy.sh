#!/bin/sh

# #################################################################
# Zen Deploy Script
# -----------------
# version:      3.0
# author:       Tomas Mulder <tomas@zenman.com>
# repo:         git@git.zenman.com:tcmulder/zen-deploy.git
# #################################################################

# -----------------------------------------------------------------
# Source required functions
# -----------------------------------------------------------------

# handle comments
source "$dir_script"/app/comments.sh;

# check for updates
source "$dir_script"/app/update.sh;

# main zen script
source "$dir_script"/app/zen.sh;
