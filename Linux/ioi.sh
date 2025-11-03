#!/bin/bash

make_new_snapshot() {
    #Save og snapshot
    mv /home/sysoperator/ioiuser /home/sysoperator/ioiuser_og
    #Create new backup
    cp -a /home/ioiuser/ /home/sysoperator/
}

restore_old_snapshot() {
    rm -rf /home/sysoperator/ioiuser_og
    mv /home/sysoperator/ioiuser_og /home/sysoperator/ioiuser
}

deactivate_automatic_reset(){
    systemctl disable renew_ioi
}

activate_automatic_reset(){
    systemctl enable renew_ioi
}

reset_ioi_dir(){
    /home/sysoperator/bin/ioi_reset.sh
}

show_help() {
  echo "Usage: $0 -n | -o | -d | -a | -r | -h"
  echo
  echo "Exactly one of these options must be provided:"
  echo "  -n    Make a new snapshot of the ioi directory"
  echo "  -o    Restore the original snapshot of the directory"
  echo "  -d    Deactive automatic reset"
  echo "  -a    Activate automatic reset"
  echo "  -r    Reset the ioi directory"
  echo "  -h    show help message"
}

# initialize flags
opt_n=false
opt_o=false
opt_d=false
opt_a=false
opt_r=false
opt_h=false

# parse options
while getopts "nodarh" opt; do
  case $opt in
    n) opt_n=true ;;
    o) opt_o=true ;;
    d) opt_d=true ;;
    a) opt_a=true ;;
    r) opt_r=true ;;
    h) opt_h=true ;;
    \?) show_help; exit 1 ;;
  esac
done

# count how many were given
count=0
$opt_n && ((count++))
$opt_o && ((count++))
$opt_d && ((count++))
$opt_a && ((count++))
$opt_r && ((count++))
$opt_h && ((count++))

# check the condition: exactly one must be set
if [ "$count" -ne 1 ]; then
  echo "Error: You must specify exactly one of -n, -o, -d, -a, -r or -h."
  echo
  show_help
  exit 1
fi

# do your logic
if $opt_n; then
  make_new_snapshot
elif $opt_o; then
  restore_old_snapshot
elif $opt_d; then
  deactivate_automatic_reset
elif $opt_a; then
  activate_automatic_reset
elif $opt_r; then
  reset_ioi_dir
elif $opt_h; then
  show_help
  exit 0
fi
