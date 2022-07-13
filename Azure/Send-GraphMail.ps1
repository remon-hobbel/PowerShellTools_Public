function Send-GraphMail {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ClientID,
        [Parameter(Mandatory = $true)]
        [string]$ClientSecret,
        [Parameter(Mandatory = $true)]
        [string]$TenantID,
        [Parameter(Mandatory = $true)]
        [string]$MailSender,
        [Parameter(Mandatory = $true)]
        [string]$Recipient,
        [Parameter(Mandatory = $true)]
        [string]$Subject,
        [Parameter(Mandatory = $true)]
        [string]$Body
    )
    
    #Connect to GRAPH API
    $tokenBody = @{
        Grant_Type    = "client_credentials"
        Scope         = "https://graph.microsoft.com/.default"
        Client_Id     = $clientId
        Client_Secret = $clientSecret
    }
    $tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $tokenBody
    $headers = @{
        "Authorization" = "Bearer $($tokenResponse.access_token)"
        "Content-type"  = "application/json"
    }

    #Send Mail    
    $URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"
    $BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "$Subject",
                          "body": {
                            "contentType": "HTML",
                            "content": "$Body                          
                            "
                          },
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "$Recipient"
                              }
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@

    Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend
}