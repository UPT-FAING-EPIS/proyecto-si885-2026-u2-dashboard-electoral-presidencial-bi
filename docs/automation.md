# Automatizacion de carga

## Carga manual completa

Ejecutar desde PowerShell:

```powershell
cd C:\Users\DIEGO\Desktop\Proyecto-Candidatos-2026
.\scripts\run_full_refresh.ps1
```

Este proceso:

1. Detecta tu IP publica actual.
2. Actualiza la regla de firewall de Azure SQL si la IP cambio.
3. Sube los CSV de `data/` a `raw-csv/data`.
4. Recarga Azure SQL con `etl/load_csv_to_azure_sql.py`.

## Programar carga diaria en Windows

Ejecutar una vez:

```powershell
cd C:\Users\DIEGO\Desktop\Proyecto-Candidatos-2026
.\scripts\register_daily_refresh_task.ps1 -At "02:00"
```

La tarea queda registrada como:

```text
ProyectoCandidatos2026-DailyRefresh
```

Para probarla manualmente:

```powershell
Start-ScheduledTask -TaskName "ProyectoCandidatos2026-DailyRefresh"
```

## Automatizacion en GitHub Actions

Si subes el proyecto a GitHub, el workflow `.github/workflows/etl-schedule.yml` puede ejecutar la carga todos los dias.

Secretos necesarios:

```text
AZURE_CREDENTIALS
SQL_ADMIN_LOGIN
SQL_ADMIN_PASSWORD
```

`AZURE_CREDENTIALS` se crea con:

```powershell
az ad sp create-for-rbac --name "sp-candidatos2026-github" --role contributor --scopes /subscriptions/aafcef11-213e-4c3a-bb8f-ee0bc32e435d --sdk-auth
```

En este equipo ya se genero un archivo local ignorado por Git:

```text
.azure-github-credentials.json
```

Para configurar los secretos automaticamente:

```powershell
gh auth login --web --scopes repo,workflow
.\scripts\configure_github_secrets.ps1
```

No publiques `infra/dev.tfvars`, `.env` ni `terraform.tfstate`.
