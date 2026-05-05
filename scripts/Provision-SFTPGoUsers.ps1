param(
    [string]$Endpoint = "https://sftpgo-poc.sbx.rosseltech.net:8080",
    [string]$AdminUser = "admin_rossel",
    [string]$AdminPassword = "Maint4126@lvdn",
    [string]$UsersConfigPath = "../config/users.json"
)

# 1. Import des fonctions
. "$PSScriptRoot/Get-SFTPGoToken.ps1"
. "$PSScriptRoot/New-SFTPGoUser.ps1"

# 2. Récupération du token
$TOKEN = Get-SFTPGoToken -Endpoint $Endpoint -AdminUser $AdminUser -AdminPassword $AdminPassword

# 3. Lecture du fichier de config
$users = Get-Content -Path $UsersConfigPath | ConvertFrom-Json

foreach ($user in $users) {
    New-SFTPGoUser `
        -Endpoint $Endpoint `
        -Token $TOKEN `
        -Username $user.username `
        -Password $user.password `
        -HomeDir $user.home_dir
}
