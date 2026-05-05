# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------
$ENDPOINT = "https://sftpgo-poc.sbx.rosseltech.net:8080"
$uri = "$ENDPOINT/api/v2/token"
$ADMIN_USER     = "admin_rossel"
$ADMIN_PASSWORD = "Maint4126@lvdn"
# ------------------------------------------------------------
# Construction de l'en-tête Basic Auth
# ------------------------------------------------------------
$pair = "${ADMIN_USER}:${ADMIN_PASSWORD}"
$base64 = [Convert]::ToBase64String(
    [Text.Encoding]::ASCII.GetBytes($pair)
)
$headers = @{
    Authorization = "Basic $base64"
}
# ------------------------------------------------------------
# Appel API via Invoke-RestMethod
# ------------------------------------------------------------
$response = Invoke-RestMethod -Uri $uri -Headers $headers -Method GET
# ------------------------------------------------------------
# Extraction du token
# ------------------------------------------------------------
$TOKEN = $response.access_token
Write-Host "Token récupéré : $TOKEN
