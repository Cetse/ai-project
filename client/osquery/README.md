# Installation 

Linux: dpkg-based distros
-------------------------
````
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
$ sudo add-apt-repository "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/xenial xenial main"
$ sudo apt-get update
$ sudo apt-get install osquery
````

Windows
-------

There is a script available to install osquery on Windows. 
See `/client/script/WindowsInstaller.bat` and `/client/script/WindowsInstaller.ps1` (recommended)

Manual installation

CMD.exe installation: 
````
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
````

Powershell installation: 
````
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
````

Install Osquery:

`C:\> choco install osquery` ::innocent

# Configuration

osqueryd.conf
-------------

Location Ubuntu: `/etc/osquery/osquery.conf`
Location Windows: `C:\Programdata\osquery\osquery.conf`


