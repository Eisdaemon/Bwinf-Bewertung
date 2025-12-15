### BWINF Laptop Setup

#### Author: Joris Lamberty

All BWINF Laptops are outfitted either with Windows or Ubuntu and Windows. 

All Laptops have an SysOperator Account as Admin Account on each installation.  

Usage on  Windows requieres the use of the unattend.xml for auto config.
Windows does not allow execution of random powershell script. To execute the script you first have to allow it, by:

    Set-ExecutionPolicy -ExecutionPolicy Unrestricted

The Script changes it at the end of execution back  

You can download the Script by using:

    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Windows/pool/install_pool.ps1" -OutFile "C:\Users\SysOperator\install_pool.ps1"

    
The linux script can be downladed at:

    wget raw.githubusercontent.com/Eisdaemon/Bwinf-Bewertung/refs/heads/main/Linux/install.sh
    chmod +x install.sh


runtergeladen werden und ausführbar gemacht werden.

![alt text](https://maxleiter.com/blog/node-tooling/unix-poster.jpg)
