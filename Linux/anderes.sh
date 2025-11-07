#!/bin/bash

make_new_snapshot() {
    #Save og snapshot
    rm -rf /home/sysoperator/anderes
    #Create new backup
    cp -a /home/anderes/ /home/sysoperator/
}

restore_old_snapshot() {
    rm -rf /home/sysoperator/anderes
    cp -a /home/sysoperator/anderes_og /home/sysoperator/anderes
}

reset_ioi_dir(){
    /home/sysoperator/bin/anderes_renew.sh
}

show_help() {
  echo "Usage: $0 -n | -o | -r | -h"
  echo
  echo "Exactly one of these options must be provided:"
  echo "  -n    Make a new snapshot of the ioi directory"
  echo "  -o    Restore the original snapshot of the directory"
  echo "  -r    Reset the ioi directory"
  echo "  -h    show help message"
}

# initialize flags
opt_n=false
opt_o=false
opt_r=false
opt_h=false

# Check if running as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root" >&2
    exit 1
fi

# parse options
while getopts "nodarh" opt; do
  case $opt in
    n) opt_n=true ;;
    o) opt_o=true ;;
    r) opt_r=true ;;
    h) opt_h=true ;;
    \?) show_help; exit 1 ;;
  esac
done

# count how many were given
count=0
$opt_n && ((count++))
$opt_o && ((count++))
$opt_r && ((count++))
$opt_h && ((count++))

# check the condition: exactly one must be set
if [ "$count" -ne 1 ]; then
  echo "Error: You must specify exactly one of -n, -o, -r or -h."
  echo
  show_help
  exit 1
fi

# do your logic
if $opt_n; then
  make_new_snapshot
elif $opt_o; then
  restore_old_snapshot
elif $opt_r; then
  reset_ioi_dir
elif $opt_h; then
  show_help
  exit 0
fi
