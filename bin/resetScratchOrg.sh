#!/bin/bash

###############################################################
# 
# bin/resetScratchOrg {org_alias} {--default}
# 
###############################################################

scratch_def_file=config/project-scratch-def.json
scratch_org_name=scratch

# alter GIT configuration to use ".githooks" directory for this project.
git config core.hooksPath .githooks

org_alias=$1
set_to_default=$2

if [ -z "$1" ]
  then
    echo "No org_alias argument supplied"
    exit 1
fi
echo org_alias is $org_alias

temp_dir=temp
progress_marker_filename=_buildprogressmarker_$org_alias

# Does the temp directory exist?
if [ ! -d "$temp_dir" ]
  then
    mkdir "$temp_dir"
fi 

# Does the progressmarker file exist?
if [ ! -f "$temp_dir/$progress_marker_filename" ]
  then
    echo 0 > "$temp_dir/$progress_marker_filename"
fi 

progress_marker_value=$(<"$temp_dir/$progress_marker_filename")
# echo "progress_marker_value A == $progress_marker_value"

if [ -z "$progress_marker_value" ]
  then
    progress_marker_value=0
fi
# echo "progress_marker_value B == $progress_marker_value"

# Delete any previous scratch org with same alias
if [ 10 -gt "$progress_marker_value" ]
  then
    sf org delete scratch --no-prompt --target-org $org_alias
    echo 10 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=10
fi
# echo "progress_marker_value C == $progress_marker_value"

# Clean up and prune the local GIT repo to remove stale branches that have been removed form GitHub
git remote prune origin 2> /dev/null

# exit script when any command fails.  From here forward, if there is a failure, we want the script to fail
set -e 

# Create new scratch org
if [ 20 -gt "$progress_marker_value" ]
  then
    sf org create scratch --wait 30 --duration-days 2 --definition-file $scratch_def_file --alias $org_alias
    echo 20 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=20
fi
# echo "progress_marker_value D == $progress_marker_value"

# Set scratch org and scratch default user to EST timezone. Also purge sample data.
if [ 30 -gt "$progress_marker_value" ]
  then
    ./bin/performAdjustmentsOnScratchOrg.sh $org_alias $scratch_org_name
    echo 30 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=30
fi
# echo "progress_marker_value == $progress_marker_value"

# Install all dependencies
if [ 40 -gt "$progress_marker_value" ]
  then
    sf toolbox package dependencies install --wait 90 --targetusername $org_alias
    echo 40 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=40
fi
# echo "progress_marker_value == $progress_marker_value"

# Push source code to org.
if [ 50 -gt "$progress_marker_value" ]
  then
    sf project deploy start --ignore-conflicts --target-org $org_alias
    echo 50 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=50
fi
# echo "progress_marker_value == $progress_marker_value"

# Open the org
if [ 99 -gt "$progress_marker_value" ]
  then
    sf org open --path lightning/setup/SetupOneHome/home --target-org $org_alias
    echo ""
    echo "Scratch org $org_alias is ready"
    echo ""
    echo 99 > "$temp_dir/$progress_marker_filename"
    progress_marker_value=99
fi
# echo "progress_marker_value == $progress_marker_value"

if [ "$set_to_default" == "--default" ]
  then
    echo "Setting $org_alias as the default username"
    sf config set target-org=$org_alias
fi

# remove marker file
rm "$temp_dir/$progress_marker_filename"
