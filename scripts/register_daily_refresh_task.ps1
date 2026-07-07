param(
    [string]$ProjectRoot = (Resolve-Path "$PSScriptRoot\..").Path,
    [string]$TaskName = "ProyectoCandidatos2026-DailyRefresh",
    [string]$At = "02:00"
)

$ErrorActionPreference = "Stop"

$refreshScript = Join-Path $ProjectRoot "scripts\run_full_refresh.ps1"
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$refreshScript`" -ProjectRoot `"$ProjectRoot`""

$trigger = New-ScheduledTaskTrigger -Daily -At $At
$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "Carga periodica de CSV a Azure Blob Storage y Azure SQL para Proyecto Candidatos 2026" `
    -Force

Write-Host "Tarea programada registrada: $TaskName a las $At"
