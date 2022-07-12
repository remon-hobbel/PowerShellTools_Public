function New-VBoxVM {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows10', 'Ubuntu')]
        [string]$OSType,

        [Parameter(Mandatory = $false)]
        [string]$VBox_Base_Path = 'C:\Program Files\Oracle\VirtualBox',

        [Parameter(Mandatory = $false)]
        [string]$Windows_iso_path = "Resources\Windows_ISO",
        
        [Parameter(Mandatory = $false)]
        [string]$Ubuntu_iso_path = "Resources\Ubuntu_ISO",

        [Parameter(Mandatory = $false)]
        [string]$SystemRoot = "$env:SystemDrive"
    )
    
    begin {
        #to-do

        #download newest Ubuntu VM
        #download newest Windows Server VM
        #config from github
        #ansible
        #chocolatey
        #auto configure vm
        #random credentials
        #send mail with credentials
        #Send-OSNotification

        #Creating Folder structure for New-VBoxVM
        Set-Location -path "$env:SystemDrive\"
        $BasePath = "$env:SystemDrive\PSVboxManagement"

        if ((Test-Path -path $BasePath) -eq $false) {
            New-Item -Itemtype directory -name $BasePath -Force
            Write-Host "Base Direcotry created"
    
        }
        if ((Test-Path -path "$($BasePath)\$($Windows_iso_path)") -eq $false) {
            New-Item -Itemtype directory -path "$($BasePath)\$($Windows_iso_path)" -Force
            Write-Host "Windows Resource dir updated"
        }
        if ((Test-Path -path "$($BasePath)\$($Ubuntu_iso_path)") -eq $false) {
            New-Item -Itemtype directory -path "$($BasePath)\$($Ubuntu_iso_path)" -Force
            Write-Host "Ubuntu resource dir updated"
    
        }      

    }
    
    process {
        Set-Location $VBOX_Base_Path

        #Parameters for VM
        $Date = Get-Date -Format 'dd/MM/yyyy_HHmm'
        $Basefolder = "C:\VM\$($OSType)"
        $Random = Get-Random
        $Vbox_VM_Name = "$($OSType)_$($Date)_$($Random)"
        
        Write-Host "Creating a $OSType VM....."  -ForegroundColor 'Green'
        & .\VboxManage.exe createvm --name $Vbox_VM_Name --ostype $OSType --basefolder $Basefolder --register
    }
    
    end {
        
    }
}