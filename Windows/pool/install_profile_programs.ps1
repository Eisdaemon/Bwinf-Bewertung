    #Because why would it be easily possible to install packages system wide...
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant girlsuser:RX
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Anaconda.Anaconda3"
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:girlsuser "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Spyder.Spyder"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:girlsuser "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove girlsuser

    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant anderes:RX
    runas /user:anderes "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:anderes "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove anderes


    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /grant bewertung:RX
    runas /user:bewertung "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe install Microsoft.VisualStudioCode"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-vscode.cpptools"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension Oracle.oracle-java"
    runas /user:bewertung "C:\Users\girlsuser\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd --install-extension ms-python.python"
    icacls "C:\Users\SysOperator\AppData\Local\Microsoft\WindowsApps\winget.exe" /remove bewertung
