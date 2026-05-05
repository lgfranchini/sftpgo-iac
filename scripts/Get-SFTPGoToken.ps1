function Get-SFTPGoToken {
    <#
        .SYNOPSIS
            Récupère un token SFTPGo via l’API /api/v2/token.

        .PARAMETER Endpoint
            URL de base du serveur SFTPGo (ex: https://sftpgo-poc.sbx.rosseltech.net:8080)

        .PARAMETER AdminUser
            Nom d’utilisateur administrateur SFTPGo.

        .PARAMETER AdminPassword
            Mot de passe de l’administrateur SFTPGo.

        .EXAMPLE
            $token = Get-SFTPGoToken -Endpoint "https://sftpgo-poc.sbx.rosseltech.net:8080" `
                                     -AdminUser "admin_rossel" `
                                     -AdminPassword "Maintxxxxx"
    #>

    param(
        [Parameter(Mandatory = $true)]
        [string]$Endpoint,

        [Parameter(Mandatory = $true)]
        [string]$AdminUser,

        [Parameter(Mandatory = $true)]
        [string]$AdminPassword
    )

    # ------------------------------------------------------------
    # Construction de l'URL de l'endpoint
    # ------------------------------------------------------------
    $uri = "$Endpoint/api/v2/token"

    # ------------------------------------------------------------
    # Construction de l'en-tête Basic Auth
    # ------------------------------------------------------------
    $pair = "$AdminUser:$AdminPassword"

    $base64 = [Convert]::ToBase64String(
        [Text.Encoding]::ASCII.GetBytes($pair)
    )

    $headers = @{
        Authorization = "Basic $base64"
    }

    # ------------------------------------------------------------
    # Appel API via Invoke-RestMethod
    # ------------------------------------------------------------
    try {
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method GET

        # --------------------------------------------------------
        # Extraction et retour du token
        # --------------------------------------------------------
        $TOKEN = $response.access_token
        Write-Host "Token récupéré : $TOKEN"
        return $TOKEN
    }
    catch {
        Write-Host "Erreur lors de la récupération du token." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        if ($_.ErrorDetails.Message) {
            Write-Host "Détails API : $($_.ErrorDetails.Message)" -ForegroundColor DarkYellow
        }
        return $null
    }
}
