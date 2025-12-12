### Here are all the Commands in the bin folder explained

#### ip.sh
Execute as Sudo.
Applies the network rules preventing access to websites besides contest.informatik-olympiade.de for the account ioiuser.

#### ip_away.sh
Drops all network rules.

#### ioi.sh
A tool to control the daily reset of the ioiuser.
It can be used to create a new backup from the ioiuser home dir to use for backup or restore the original backup. The original backup should never be deleted! 
The backups are stored as ioiuser and ioiuser_og in the home dir of the sysoperator.
It can also be used to execute as reset manually and disable and enable the daily reset. 

For details on execution execute the script with -h as addition.

#### ioi_renew.sh
Executes the reset of the ioiuser. Its called by a systemd service each day at 5 AM

#### anderes.sh
A tool to control the reset of the anderes user.
It can be used to create a new backup from the anderes home dir to use for backup or restore the original backup. The original backup should never be deleted! 
The backups are stored as anderes and anderes_og in the home dir of the sysoperator.
It can also be used to execute as reset manually.

For details on execution execute the script with -h as addition.

#### anderes_renew.sh
Executes the reset of the anderes.

#### bewertungs_mode.sh

Disables and enables the other two user accounts to make sure the ioiuser is used.

#### Other files and Explanations
The installations was executed by "install.sh". Usually executed from the home dir where it then still lies.

renew_ioi.service and renew_ioi.timer are the files for the systemd service to reset ioiuser

bewertungs-plan.yaml is a file now stored at /etc/netplan and was used to put the details for the Bewertungs Wlan into the system.

