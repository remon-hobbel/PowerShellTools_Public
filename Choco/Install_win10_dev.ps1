#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install Packages
$packages = @(

    '7zip.install'
    'postman'
    'atom'
    'python3'
    'github'
    'firefox'
    'chrome'
    'windirstat'
    'putty'
    'winscp'
    'vscode'

)

foreach ($package in $packages) {

    choco install $package -y
}
