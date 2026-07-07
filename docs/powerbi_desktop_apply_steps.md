# Aplicacion en Power BI Desktop

Estado ya completado:

- Las vistas mejoradas fueron creadas en Azure SQL.
- El tema visual esta listo en `dashboard/powerbi_theme_elecciones_2026.json`.
- La conexion mejorada esta lista en `dashboard/azure-sql-elecciones2026-enhanced.pbids`.
- Las medidas DAX estan documentadas en `docs/powerbi_measures.md`.

## 1. Cargar vistas nuevas

1. Abrir `dashboard/elcciones oficiales 1_AZURE.pbix`.
2. Ir a `Inicio > Transformar datos > Nuevo origen > SQL Server`.
3. Servidor: `sql-candidatos2026-dev-w3-z0lh9d.database.windows.net`.
4. Base de datos: `Elecciones2026DW`.
5. Modo: `Importar`.
6. Seleccionar estas vistas:
   - `dbo.vw_dashboard_candidatos`
   - `dbo.vw_dashboard_kpis`
   - `dbo.vw_riesgo_partido_enhanced`
   - `dbo.vw_ranking_candidatos`
   - `dbo.vw_tiktok_ultimo_registro`
7. Click en `Cargar`.

Alternativa: abrir `dashboard/azure-sql-elecciones2026-enhanced.pbids` y seleccionar las mismas vistas.

## 2. Importar tema

1. Ir a `Vista > Temas > Examinar temas`.
2. Seleccionar `dashboard/powerbi_theme_elecciones_2026.json`.
3. Revisar que los colores principales sean azul institucional, rojo alerta,
   amarillo medio y verde bajo riesgo.

## 3. Crear medidas

Crear una tabla de medidas llamada `Medidas Dashboard` y pegar las medidas desde:

`docs/powerbi_measures.md`

Formato sugerido:

- Porcentajes: 1 decimal.
- Montos: moneda peruana, escala en miles o millones.
- Edad y riesgo promedio: 1 decimal.

## 4. Reorganizar paginas

### Pagina 1: Resumen ejecutivo

Fila superior:

- `Total Candidatos`
- `% Riesgo Alto`
- `% Con Sentencias`
- `Ingreso Promedio`
- `Patrimonio Promedio`

Centro:

- Barras apiladas: `NombrePartido` por `CategoriaRiesgo`, valor `Total Candidatos`.

Derecha:

- Tabla o barras horizontales con top 5 de `vw_ranking_candidatos`,
  ordenado por `RankingRiesgo`.

Inferior:

- Sexo, edad promedio, educacion y visitas de campania.

### Pagina 2: Ranking y comparacion

Visuales:

- Ranking de riesgo.
- Ranking de ingresos.
- Ranking de patrimonio.
- Scatter: `TotalIngresos` vs `PatrimonioDeclarado`, color `CategoriaRiesgo`,
  tamano `CantidadVisitasCampania`.

Filtros:

- `NombrePartido`
- `CargoPostula`
- `Sexo`
- `CategoriaRiesgo`

### Pagina 3: Ficha del candidato

Filtro principal:

- Segmentador de `NombreCompleto`.

Bloques:

- Identidad: nombre, partido, cargo, edad.
- Riesgo: categoria, codigo, justificacion, sentencias.
- Economia: ingresos, patrimonio, bienes inmuebles y muebles.
- Trayectoria: educacion, experiencia laboral y cargos partidarios.
- Campania: visitas y TikTok.

## 5. Reemplazos puntuales

- Cambiar ejes con `IdCandidato` por `NombreCompleto`.
- Para top 5 usar `vw_ranking_candidatos`.
- Para riesgo por partido usar `vw_riesgo_partido_enhanced`.
- Para KPIs globales usar medidas DAX o `vw_dashboard_kpis`.
- Evitar tablas extensas en la pagina ejecutiva; moverlas a ficha o tooltip.
