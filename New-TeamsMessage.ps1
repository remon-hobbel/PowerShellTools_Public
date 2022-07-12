<#
    .DESCRIPTION
    Send a Teams MessageCard using Invoke-RestMethod.
    Emoji Format: &#x<EMOJI-HEX-CODE>;

    .EXAMPLE
    Invoke-Teamsmessage -Title '$VM Deployed' -Fact '$ErrorLog'
#>

function Invoke-TeamsMessage {

    param (
        #Title of the MessageCard 
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Title,

        #Fact 1
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Fact,

        #See line 38 for more information
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$Image            
    )              

    $url = '<Teams Webhook URI here>'

    #Teams MessageCard body
    $Body = [Ordered]@{
        '@context'      = 'https://schema.org/extensions'
        '@type'         = 'MessageCard'
        summary         = 'Summary here'
        sections        = @(
            @{
                
                activityTitle = "$Title"
                #uncomment line 38, and comment line 39 to use a custom image, provide url in the parameter.
                #activityImage   = "$Image"
                activityImage = 'https://cdn.icon-icons.com/icons2/2107/PNG/512/file_type_powershell_icon_130243.png'
                activityText  = "&#x2705;"
                facts         = @(
                    @{
                        name  = 'Fact 1'
                        value = "$Fact"
                    }
                    <# Add more facts
                    ,@{
                        name  = 'Fact 2'
                        value = "$Fact2"
                    } #>
                )
            }
        )
        potentialAction = @(
            @{
                '@type' = 'OpenUri'
                name    = '&#x1F517; Very cool button '
                targets = @(
                    @{
                        os  = 'default'
                        uri = "https://www.google.com"
                    }
                )
            } 
        )
    }
    #Parameters for Invoke-Restmethod
    $params = @{
        Uri         = $url
        Method      = 'POST'
        Body        = $Body | ConvertTo-Json -Depth 32
        ContentType = 'Application/JSON'
    }

    try {
        $response = Invoke-RestMethod @params    
    }
    catch {
        #Optional error handling, not complete.
        Write-Host $response
        Write-Host "$_.Exception.Message"
    }
}#End


