function New-SFTPGoUser {
    <#
        .SYNOPSIS
            Crée un utilisateur SFTPGo via l’API REST.
 
        .PARAMETER Endpoint
            URL de base du serveur SFTPGo (ex: https://monserveur:8080)
 
        .PARAMETER Token
            Token Bearer obtenu via /api/v2/token
 
        .PARAMETER Username
            Nom d’utilisateur SFTPGo
 
        .PARAMETER Password
            Mot de passe SFTPGo
 
        .PARAMETER HomeDir
            Chemin du répertoire home de l’utilisateur
 
        .EXAMPLE
            New-SFTPGoUser -Endpoint $ENDPOINT -Token $TOKEN `
                -Username "test1" -Password "Password1" `
                -HomeDir "/srv/sftpgo/data/test1"
    #>
 
    param(
        [Parameter(Mandatory=$true)]
        [string]$Endpoint,
 
        [Parameter(Mandatory=$true)]
        [string]$Token,
 
        [Parameter(Mandatory=$true)]
        [string]$Username,
 
        [Parameter(Mandatory=$true)]
        [string]$Password,
 
        [Parameter(Mandatory=$true)]
        [string]$HomeDir
    )
 
    # ------------------------------------------------------------
    # Construction du payload JSON
    # ------------------------------------------------------------
    $body = @{
        status   = 1
        username = $Username
        password = $Password
        home_dir = $HomeDir
        permissions = @{
            "/" = @("*")
        }
        filesystem = @{
            provider = 0
        }
    }
 
    $jsonBody = $body | ConvertTo-Json -Depth 5
 
    # ------------------------------------------------------------
    # Headers HTTP
    # ------------------------------------------------------------
    $headers = @{
        Authorization = "Bearer $Token"
        "Content-Type" = "application/json"
    }
 
    # ------------------------------------------------------------
    # Appel API
    # ------------------------------------------------------------
    $uri = "$Endpoint/api/v2/users"
 
    try {
        $response = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $jsonBody
        Write-Host "Utilisateur '$Username' créé avec succès."
        return $response
    }
    catch {
        Write-Host "Erreur lors de la création de l'utilisateur '$Username'." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        if ($_.ErrorDetails.Message) {
            Write-Host "Détails API : $($_.ErrorDetails.Message)" -ForegroundColor DarkYellow
        }
    }
}
