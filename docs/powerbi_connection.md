# Conexion de Power BI a Azure SQL

## Datos de conexion

Servidor:

```text
sql-candidatos2026-dev-w3-z0lh9d.database.windows.net
```

Base de datos:

```text
Elecciones2026DW
```

Usuario:

```text
sqladminuser
```

La contrasena esta en:

```text
infra/dev.tfvars
```

## Opcion rapida

Abrir este archivo con Power BI Desktop:

```text
dashboard/azure-sql-elecciones2026.pbids
```

Luego seleccionar las vistas:

```text
dbo.vw_resumen_candidatos
dbo.vw_riesgo_por_partido
```

## Opcion desde el PBIX existente

1. Abrir `dashboard/elcciones oficiales 1.pbix`.
2. Ir a `Inicio > Transformar datos`.
3. En Power Query, cambiar el origen actual por `Azure SQL Database`.
4. Usar el servidor y la base indicados arriba.
5. Cargar estas vistas:
   - `dbo.vw_resumen_candidatos`
   - `dbo.vw_riesgo_por_partido`
6. Aplicar cambios.
7. Revisar que los visuales usen los campos nuevos.
8. Guardar una copia como `dashboard/elecciones_azure_sql.pbix`.

## Consultas de prueba

```sql
SELECT COUNT(*) AS total_candidatos
FROM dbo.Candidato;

SELECT TOP 10 *
FROM dbo.vw_resumen_candidatos;

SELECT *
FROM dbo.vw_riesgo_por_partido;
```
