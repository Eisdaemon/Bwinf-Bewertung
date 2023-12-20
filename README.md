# BWINF Laptop Setup

## Author: Joris Lamberty

### Credit too Chris Titus Windows Debloat tool and andrew-s-taylor debloat script which is used here slightly modified, aswell to the add user scipt provided here https://www.baeldung.com/linux/automate-user-account-creation

All BWINF Laptops are setup with a Windows installation and an Linux Installation. It was Ubuntu for the longest time, but i switched to KDE Neon, due to the use of flatpak. It is still Ubunutu/Debian based, and should work nonetheless  

All Laptops have an SysOperator Account as Admin Account on each installation.  

Pool Laptops are setup with more Programming Software which is useful. They are also available as "Bewertungs Laptops". Therefore they are getting an additional Admin Account "bewertung"  
If used for any usage with people outside BWINF, like for IOI Training, they get an additional "bwinfuser" Account.  
While Most of the Time a VM with all Software is used, there is the possibility to use the Laptops as well, by using the ip.sh script provided. It cuts all Internet Access, but to a selected Website and the Localhost.  
This Script is only available on Linux. It is downloaded, but the executed while installing all software  

Laptop for colleges are setup with Software like Element, Thunderbird, Different Browsers, CloudPbx and alike.  
They also get an Admin account with their name and Server passwords. They have to be Admin Account due to the usage of Wireguard.  
They also get a shortcut to the Server on the Desktop. Last but not least some of the people get Access to Filemaker. Filemaker Licenses and Installation Files are Stores on the Server und geste\\Filemaker  

The Chris Titus Tool is only used here for the Standard Settings, not installation.  

The Windows Script should be executed while being in the home dir as working dir.  

It can be that windows does not allow the Script execution. You can change it by typing the following command: 

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted

The Script changes it at the end of execution back  

You can download the Script by using:
    
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/main/Windows/install.ps1" -OutFile "C:\Users\SysOperator\install.ps1"

Bugs: Removing the password expiry doesn't work right now and has to be done manually

![alt text](https://maxleiter.com/blog/node-tooling/unix-poster.jpg)
