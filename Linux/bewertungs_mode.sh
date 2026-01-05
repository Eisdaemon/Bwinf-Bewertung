#!/bin/bash

activate_mode() {
  usermod -L anderes
  usermod -L bewertung
  chage -E 0 anderes
  chage -E 0 bewertung
}

deactivate_mode() {
  usermod -U anderes
  usermod -U bewertung
  chage -E -1 anderes
  chage -E -1 bewertung
}


show_help() {
  echo "Usage: $0 -n | -o | -d | -a | -r | -h"
  echo
  echo "Exactly one of these options must be provided:"
  echo "  -d    Deactive other bewertungs mode"
  echo "  -a    Activate bewertungs mode"
  echo "  -h    show help message"
}

# initialize flags
opt_d=false
opt_a=false
opt_h=false

# Check if running as root
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root" >&2
    exit 1
fi

# parse options
while getopts "nodarh" opt; do
  case $opt in
    d) opt_d=true ;;
    a) opt_a=true ;;
    h) opt_h=true ;;
    \?) show_help; exit 1 ;;
  esac
done

# count how many were given
count=0
$opt_d && ((count++))
$opt_a && ((count++))
$opt_h && ((count++))

# check the condition: exactly one must be set
if [ "$count" -ne 1 ]; then
  echo "Error: You must specify exactly one of -d, -a, or -h."
  echo
  show_help
  exit 1
fi

# do your logic
if $opt_d; then
  deactivate_mode
elif $opt_a; then
  activate_mode
elif $opt_h; then
  show_help
  exit 0
fi
