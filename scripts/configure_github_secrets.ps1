param(
    [string]$Repository = "UPT-FAING-EPIS/PROYECTO_SI885_2026-II-U2_DASHBOARDELECTORAL",
    [string]$ProjectRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

$ghPath = Join-Path $env:ProgramFiles "GitHub CLI"
if (Test-Path $ghPath) {
    $env:Path = "$ghPath;$env:Path"
}

Set-Location $ProjectRoot

$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "GitHub CLI no esta autenticado. Ejecuta: gh auth login --web --scopes repo,workflow"
}

$tfvarsPath = Join-Path $ProjectRoot "infra\dev.tfvars"
$azureCredentialsPath = Join-Path $ProjectRoot ".azure-github-credentials.json"

if (-not (Test-Path $tfvarsPath)) {
    throw "No existe $tfvarsPath"
}

if (-not (Test-Path $azureCredentialsPath)) {
    throw "No existe $azureCredentialsPath. Crea la credencial con az ad sp create-for-rbac."
}

$tfvars = Get-Content $tfvarsPath -Raw

function Get-TfVar([string]$Name) {
    $match = [regex]::Match($tfvars, "$Name\s*=\s*`"([^`"]+)`"")
    if (-not $match.Success) {
        throw "No se encontro la variable $Name en $tfvarsPath"
    }
    return $match.Groups[1].Value
}

Get-Content $azureCredentialsPath -Raw | gh secret set AZURE_CREDENTIALS --repo $Repository
Get-TfVar "sql_admin_login" | gh secret set SQL_ADMIN_LOGIN --repo $Repository
Get-TfVar "sql_admin_password" | gh secret set SQL_ADMIN_PASSWORD --repo $Repository
Get-TfVar "allowed_ip_address" | gh secret set ALLOWED_IP_ADDRESS --repo $Repository

Write-Host "Secretos configurados en $Repository"
gh secret list --repo $Repository
