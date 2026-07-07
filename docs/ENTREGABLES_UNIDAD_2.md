# Entregables Unidad 2

Este documento consolida los artefactos generados para la unidad 2 del proyecto **Dashboard Electoral Presidencial BI**.

## Matriz de Cumplimiento

| Requisito | Estado | Artefactos |
| --- | --- | --- |
| Crear el almacen de datos | Cumplido | [`database/schema_dw.sql`](../database/schema_dw.sql), [`database/views_powerbi_enhanced.sql`](../database/views_powerbi_enhanced.sql) |
| Automatizar la carga de datos | Cumplido | [`etl/load_csv_to_azure_sql.py`](../etl/load_csv_to_azure_sql.py), [`etl/requirements.txt`](../etl/requirements.txt), [`.github/workflows/etl-schedule.yml`](../.github/workflows/etl-schedule.yml) |
| Modificar el reporte de unidad 1 para apuntar al almacen | Cumplido | [`dashboard/elcciones oficiales 1_AZURE.pbix`](../dashboard/elcciones%20oficiales%201_AZURE.pbix), [`dashboard/azure-sql-elecciones2026-enhanced.pbids`](../dashboard/azure-sql-elecciones2026-enhanced.pbids), [`docs/powerbi_connection.md`](./powerbi_connection.md) |
| Subir artefactos generados | Cumplido | [`dashboard`](../dashboard), [`database`](../database), [`etl`](../etl), [`docs`](../docs), [`infra`](../infra), [`data`](../data) |
| Automatizar infraestructura en Terraform | Cumplido | [`infra/main.tf`](../infra/main.tf), [`infra/variables.tf`](../infra/variables.tf), [`infra/outputs.tf`](../infra/outputs.tf), [`infra/providers.tf`](../infra/providers.tf) |
| Automatizar despliegue de infraestructura | Cumplido | [`.github/workflows/terraform-plan.yml`](../.github/workflows/terraform-plan.yml), [`.github/workflows/terraform-apply.yml`](../.github/workflows/terraform-apply.yml) |
| Automatizar release de artefactos | Cumplido | [`.github/workflows/release-artifacts.yml`](../.github/workflows/release-artifacts.yml) |
| Automatizar procesamiento periodico | Cumplido | [`.github/workflows/etl-schedule.yml`](../.github/workflows/etl-schedule.yml), [`docs/automation.md`](./automation.md) |
| FD01 - Informe de Factibilidad | Cumplido | [`FD01-EPIS-Informe de Factibilidad.docx`](../FD01-EPIS-Informe%20de%20Factibilidad.docx) |
| FD02 - Informe de Vision de Producto | Cumplido | [`FD02-EPIS-Informe Vision.docx`](../FD02-EPIS-Informe%20Vision.docx) |
| FD03 - Informe de Especificacion de Requerimientos | Cumplido | [`FD03-EPIS-Informe Especificación Requerimientos.docx`](../FD03-EPIS-Informe%20Especificación%20Requerimientos.docx) |
| FD04 - Informe de Arquitectura | Cumplido | [`FD04-EPIS-Informe Arquitectura de Software.docx`](../FD04-EPIS-Informe%20Arquitectura%20de%20Software.docx) |
| FD05 - Informe de Proyecto | Cumplido | [`FD05-EPIS-Informe ProyectoFinal.pdf`](../FD05-EPIS-Informe%20ProyectoFinal.pdf) |
| Diccionario de Datos | Cumplido | [`DICCIONARIO_DATOS.md`](../DICCIONARIO_DATOS.md) |
| Enlace de aplicacion funcionando | Pendiente de publicacion externa | Repositorio: <https://github.com/UPT-FAING-EPIS/PROYECTO_SI885_2026-II-U2_DASHBOARDELECTORAL>. Publicar el dashboard en Power BI Service y pegar el enlace compartido en la seccion siguiente. |

## Enlace de Aplicacion Funcionando

* **Repositorio GitHub:** <https://github.com/UPT-FAING-EPIS/PROYECTO_SI885_2026-II-U2_DASHBOARDELECTORAL>
* **Dashboard Power BI publicado:** pendiente de pegar enlace de Power BI Service.
* **Almacen de datos Azure SQL:** `sql-candidatos2026-dev-w3-z0lh9d.database.windows.net / Elecciones2026DW`

## Artefactos Tecnicos Publicados

| Tipo | Ubicacion |
| --- | --- |
| PBIX | [`dashboard/elcciones oficiales 1_AZURE.pbix`](../dashboard/elcciones%20oficiales%201_AZURE.pbix) |
| PBIDS | [`dashboard/azure-sql-elecciones2026-enhanced.pbids`](../dashboard/azure-sql-elecciones2026-enhanced.pbids) |
| JSON | [`dashboard/powerbi_theme_elecciones_2026.json`](../dashboard/powerbi_theme_elecciones_2026.json) |
| Python | [`etl/load_csv_to_azure_sql.py`](../etl/load_csv_to_azure_sql.py), [`scripts`](../scripts) |
| SQL | [`database/schema_dw.sql`](../database/schema_dw.sql), [`database/views_powerbi_enhanced.sql`](../database/views_powerbi_enhanced.sql), [`sql/elecciones oficiales 1.sql`](../sql/elecciones%20oficiales%201.sql) |
| DAX | [`docs/powerbi_measures.md`](./powerbi_measures.md) |
| Terraform | [`infra`](../infra) |
| Documentacion | [`docs`](../docs), [`README.md`](../README.md), [`DICCIONARIO_DATOS.md`](../DICCIONARIO_DATOS.md) |

## Pasos de Ejecucion

1. Crear o actualizar infraestructura con Terraform usando los workflows `terraform-plan` y `terraform-apply`.
2. Ejecutar `database/schema_dw.sql` para crear el almacen de datos.
3. Ejecutar `database/views_powerbi_enhanced.sql` para crear vistas analiticas.
4. Ejecutar el workflow `ETL Schedule` para cargar CSV a Azure SQL.
5. Abrir `dashboard/elcciones oficiales 1_AZURE.pbix` y refrescar desde Azure SQL.
6. Publicar el dashboard en Power BI Service y registrar el enlace publicado.
