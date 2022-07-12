function New-AutomationJob {

    <#
    .DESCRIPTION
        This function will schedule a Runbook job to Ivanti Automation REST API with Invoke-RestMethod.
        The Runbook Scheduling Criteria JSON contains the parameters of the runbook. 
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Identity,

        [Parameter(Mandatory = $false)]
        [string]$NewCompany,

        [Parameter(Mandatory = $false)]
        [string]$NewDepartment,
        
        [Parameter(Mandatory = $false)]
        [string]$NewManager,

        [Parameter(Mandatory = $false)]
        [string]$NewTitle,

        [Parameter(Mandatory = $false)]
        [string]$StartDate
    )

    
    begin {
        # Automation & Secret Config
        $Automation_base_url = ''
        $Automation_api_endpoint = '/API/Schedule/Schedule'
        $Automation_secretvault = ''
        $Automation_secret_name = ''

        # Check if Secret can be retrieved from SecretVault. Requires a registered Vault for the user account running this module
        try {
            $Automation_secret_string = Get-Secret -name "$Automation_secret_name" -Vault "$Automation_secretvault" -AsPlainText  -ErrorAction Stop
        }
        catch {
            Write-Verbose 'Cannot retrieve API secret, sending email' 
            $SecretFailure = $true
            $ErrorBody = "$_.Exception"
        }
    }
    
    process {
        # Only process If no errors are found in Get-Secret
        if (-not $SecretFailure) {

            # Runbook Scheduling Criteria JSON generated in Ivanti Management Portal
            $Body = @"
        {
        "description": "ADconnect/ $Identity",
        "type": "Runbook",
        "when": {
            "type": "Immediate"
        },
        "what": [
            {
            "type": "Runbook",
            "canSchedule": true,
            "id": "f700721d-d44d-437b-854d-eab9f531f77e",
            "name": "New User Resignation"
            }
        ],
        "parameterValues": {
            "Identity": "$Identity",
            "NewCompany": "$NewCompany",
            "NewDepartment": "$NewDepartment",
            "NewManager": "$NewManager",
            "NewTitle": "$NewTitle",
            "StartDate": "$StartDate"
        },
"@

            # Authorization Header
            $Header = @{
                'Authorization' = "$Automation_secret_string"
            }

            # Creating HTTP Request
            $ApiCall = @{
                Body        = $Body
                Header      = $Header
                Uri         = '{0}{1}' -f $Automation_base_url, $Automation_api_endpoint
                Method      = 'POST'
                ContentType = 'Application/JSON'
            }

            # Send HTTP Request to Automation REST API. Send email on error
            try {
                Invoke-RestMethod @ApiCall
            }
            catch {
                Write-Verbose 'API Call Exception, sending email' 
                $ApiCallFailure = $true
                $ErrorBody = "$_.Exception"
            }
        }
    }
}