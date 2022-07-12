function Test-Vault {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        try {
            (Get-SecretInfo).Name -contains 'SECRET_NAME'
        }
        catch {
            Write-Verbose 'Cannot retrieve API secret, sending email' 
            $SecretFailure = $true
            $ErrorBody = "$_.Exception"
        }
    }

process {
    if (-not $SecretFailure) {

        Write-Host 'OK'
    }
}

}