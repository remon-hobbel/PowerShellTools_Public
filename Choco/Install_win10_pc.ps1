
#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install Packages
$packages = @(

    '7zip.install'
    'steam'
    'spotify'
    'slack'
    'github'
    'firefox'
    'bitwarden'
    'windirstat'
    'putty'
    'winscp'
    'greenshot'
    'vscode'
    'virtualbox'
    'origin'
    'office365business'
    'choco install microsoft-windows-terminal'

)

foreach ($package in $packages) {

    choco install $package -y
}

#Install PSWindowsUpdate
Install-Module -Name PSWindowsUpdate -Force

#Install Updates
Install-WindowsUpdate -AcceptAll -AutoReboot
