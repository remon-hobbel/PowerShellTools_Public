<#
https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/
#>

# Install Secret Management (Module used to retrieve credentials) https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.secretmanagement/?view=ps-modules
Install-Module -Name Microsoft.PowerShell.SecretManagement -Repository PSGallery -Scope CurrentUser

# Install Secret Store (Module used to store credentials) https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.secretstore/?view=ps-modules
Install-Module -Name Microsoft.PowerShell.SecretStore -Repository PSGallery -Scope CurrentUser

# Working with Secret Management and Secret Store modules. To start, create a vault with the Register-SecretVault cmdlet with a name, module name and other details if you do not want to use the default configuration. To create a default vault, run the following command:
Register-SecretVault -Name SecretVault -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault

# Configure Secret Store for Automation (Disable user interaction https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.secretstore/set-secretstoreconfiguration?view=ps-modules)
Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None -Interaction none

# Register Secret
Set-Secret -Name 'SECRET' -Secret 'SECRET_VALUE'

# When you retrieve the secret, PowerShell does not return a plaintext version of the saved value but returns the type System.Security.SecureString. To get the actual value, use the -AsPlainText property:
Get-Secret -Name 'SECRET' -AsPlainText