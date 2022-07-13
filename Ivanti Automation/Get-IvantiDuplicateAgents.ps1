<#
.DESCRIPTION
Get all Ivanti Automation Agents, filter Duplicates by name and export to CSV. For housekeeping purposes.

.NOTES
Version:        Production 1.0
Author:         Rémon Hobbel
Creation Date:  26-08-2021
#>

$Api_key = ''
$Api_endpoint = '/API/Agents/Search'
$Base_url = ''

#Auth_key
$Headers = @{
    'Authorization' = "$Api_key"
}

$ApiCall = @{
    Header      = $Headers
    Uri         = '{0}{1}' -f $Base_url, $Api_endpoint
    Method      = 'GET'
    ContentType = 'Application/JSON'
}

#Send Request 
try {
    $Request = Invoke-RestMethod @ApiCall
}
catch {
    Write-Host (
        "Failed to get data, {0}" -f $_.Exception.Message
    )
    exit
}#>


$DataJSON = $Request | ConvertFrom-Json

#Get Unique Values
$UniqueAgents = $DataJSON.result.name | Select-object -Unique

#Get Duplicates, Compare Unique with Data, Select Duplicate entries
$DuplicateAgents = Compare-Object -ReferenceObject $UniqueAgents -DifferenceObject $DataJSON.result.name | Select-Object -ExpandProperty InputObject

if (-not $DuplicateAgents) {
    Write-Host 'No Duplicate Agents Found.'
}
#If Duplicate Agents are found, create CSV, send e-mail
else {

    $AgentsTable = foreach ($Agent in $DuplicateAgents) {

        foreach ($Match in $DataJSON.result | Where-Object { $_.name -match "$agent" }) {
                
            [PSCustomObject]@{
                'Agent'           = $Match.name
                'lastContact'     = $Match.lastContact
                'lastConsoleUser' = $Match.lastConsoleUser
            } 

        }
       
    } 
    #$Table | Export-Csv -Delimiter ';' -NoTypeInformation -Path 'C:\Temp\Agent.csv'
    #$Result | Out-File -FilePath 'C:\Temp\test.csv'
    $AgentsTable | Export-csv -Delimiter ';' -NoTypeInformation -Path 'C:\Temp\AgentsResult.csv'
    return $True
}