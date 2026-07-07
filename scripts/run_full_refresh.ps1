param(
    [string]$ProjectRoot = (Resolve-Path "$PSScriptRoot\..").Path
)

$ErrorActionPreference = "Stop"

Set-Location $ProjectRoot

$azPath = Join-Path $env:ProgramFiles "Microsoft SDKs\Azure\CLI2\wbin"
if (Test-Path $azPath) {
    $env:Path = "$azPath;$env:Path"
}

$tfvarsPath = Join-Path $ProjectRoot "infra\dev.tfvars"
$tfvars = Get-Content $tfvarsPath -Raw

function Get-TfVar([string]$Name) {
    $match = [regex]::Match($tfvars, "$Name\s*=\s*`"([^`"]+)`"")
    if (-not $match.Success) {
        throw "No se encontro la variable $Name en $tfvarsPath"
    }
    return $match.Groups[1].Value
}

$currentIp = Invoke-RestMethod -Uri "https://api.ipify.org?format=text"
$storedIp = Get-TfVar "allowed_ip_address"

if ($currentIp -ne $storedIp) {
    Write-Host "Actualizando firewall SQL: $storedIp -> $currentIp"
    $updated = [regex]::Replace($tfvars, 'allowed_ip_address\s*=\s*"[^"]+"', "allowed_ip_address = `"$currentIp`"")
    Set-Content -Path $tfvarsPath -Value $updated -Encoding utf8
    terraform -chdir=infra apply -auto-approve -var-file="dev.tfvars"
}
else {
    Write-Host "Firewall SQL ya permite la IP actual: $currentIp"
}

$storageAccountName = (terraform -chdir=infra output -raw storage_account_name)
$containerName = (terraform -chdir=infra output -raw raw_container_name)
$sqlServer = (terraform -chdir=infra output -raw sql_server_fqdn)
$sqlDatabase = (terraform -chdir=infra output -raw sql_database_name)

Write-Host "Subiendo CSV a Blob Storage..."
az storage blob upload-batch `
    --account-name $storageAccountName `
    --destination $containerName `
    --destination-path data `
    --source data `
    --pattern *.csv `
    --auth-mode key `
    --overwrite true | Out-Host

$env:AZURE_SQL_SERVER = $sqlServer
$env:AZURE_SQL_DATABASE = $sqlDatabase
$env:AZURE_SQL_USER = Get-TfVar "sql_admin_login"
$env:AZURE_SQL_PASSWORD = Get-TfVar "sql_admin_password"
$env:ODBC_DRIVER = "ODBC Driver 17 for SQL Server"

Write-Host "Recargando Azure SQL..."
python etl\load_csv_to_azure_sql.py

Write-Host "Refresh completo finalizado."
