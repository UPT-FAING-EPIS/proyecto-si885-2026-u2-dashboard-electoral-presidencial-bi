# Despliegue Azure del proyecto Elecciones 2026

Esta guia crea una version cloud del proyecto con:

- Azure Blob Storage para CSV.
- Azure SQL Database como almacen de datos.
- Azure Data Factory como componente cloud para futuras cargas administradas.
- Terraform para infraestructura.
- GitHub Actions para release y carga periodica.

## 1. Requisitos locales

Instalar:

- Azure CLI
- Terraform
- Python 3.11
- ODBC Driver 18 for SQL Server

Autenticarse:

```powershell
az login
az account show
```

## 2. Crear infraestructura

Copiar el archivo de ejemplo:

```powershell
Copy-Item infra\dev.tfvars.example infra\dev.tfvars
```

Editar `infra\dev.tfvars` y colocar tu IP publica en `allowed_ip_address`.

Ejecutar:

```powershell
cd infra
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Guardar los outputs:

```powershell
terraform output
```

## 3. Crear tablas y vistas

Conectarse a Azure SQL desde SQL Server Management Studio o Azure Data Studio y ejecutar:

1. `database/schema_dw.sql`
2. `database/views_powerbi.sql`

## 4. Cargar CSV

Crear `.env` desde el ejemplo:

```powershell
Copy-Item .env.example .env
```

Editar `.env` con el servidor SQL generado por Terraform.

Instalar dependencias:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r etl\requirements.txt
```

Ejecutar carga:

```powershell
python etl\load_csv_to_azure_sql.py
```

## 5. Conectar Power BI

En Power BI Desktop:

1. Abrir `dashboard/elcciones oficiales 1.pbix`.
2. Ir a Transformar datos.
3. Cambiar origen a Azure SQL Database.
4. Usar servidor `sql_server_fqdn` y base `Elecciones2026DW`.
5. Preferir las vistas:
   - `dbo.vw_resumen_candidatos`
   - `dbo.vw_riesgo_por_partido`
6. Publicar el dashboard en Power BI Service.
7. Configurar refresh automatico.

## 6. Secretos para GitHub Actions

Crear estos secretos en el repositorio:

```text
AZURE_CREDENTIALS
AZURE_SQL_SERVER
AZURE_SQL_DATABASE
SQL_ADMIN_LOGIN
SQL_ADMIN_PASSWORD
ALLOWED_IP_ADDRESS
```

`AZURE_CREDENTIALS` se genera con:

```powershell
az ad sp create-for-rbac --name "sp-candidatos2026-github" --role contributor --scopes /subscriptions/TU_SUBSCRIPTION_ID --sdk-auth
```

## 7. Automatizacion periodica

El workflow `.github/workflows/etl-schedule.yml` corre todos los dias a las 07:00 UTC.

Para Peru/Colombia equivale aproximadamente a las 02:00 AM.
