# Mejora del dashboard Power BI

Este documento resume cambios concretos para mejorar claridad, narrativa y lectura
analitica del dashboard de candidatos 2026.

## Diagnostico rapido

- La pagina general tiene demasiados elementos compitiendo por atencion.
- Varios graficos usan campos tecnicos, por ejemplo `IdCandidato`, cuando deberian
  usar nombre, partido, categoria de riesgo o ranking.
- Las tarjetas KPI mezclan porcentajes, montos y conteos sin una jerarquia visual
  clara.
- La ficha individual funciona bien como concepto, pero necesita una lectura de
  arriba hacia abajo: identidad, riesgo, patrimonio, trayectoria, campania digital.
- Los mapas y tablas son valiosos, pero deben ocupar menos espacio en la vista
  ejecutiva y mas espacio en paginas de exploracion.

## Estructura recomendada

### Pagina 1: Resumen ejecutivo

Objetivo: responder en 10 segundos que tan riesgoso es el escenario.

- Fila superior: total candidatos, % riesgo alto/critico, % con sentencias,
  ingreso promedio y patrimonio promedio.
- Centro: matriz o barras apiladas de riesgo por partido.
- Derecha: top 5 candidatos por riesgo, con nombre, partido, codigo y motivo corto.
- Inferior: distribucion de sexo, edad, educacion y visitas de campania.

### Pagina 2: Ranking y comparacion

Objetivo: comparar candidatos y encontrar outliers.

- Ranking de riesgo.
- Ranking de ingresos.
- Ranking de patrimonio.
- Scatter: ingresos vs patrimonio, color por categoria de riesgo, tamano por
  visitas o seguidores.
- Filtros: partido, cargo, sexo, categoria de riesgo.

### Pagina 3: Ficha de candidato

Objetivo: fiscalizacion individual.

- Encabezado: foto, nombre, partido, cargo, edad y categoria de riesgo.
- Bloque legal: codigo, nivel, justificacion, sentencias y variables H.
- Bloque economico: ingresos, patrimonio, bienes inmuebles/muebles.
- Bloque trayectoria: educacion, experiencia laboral, cargos partidarios.
- Bloque digital/campania: TikTok, visitas y mapa.

## Visuales a reemplazar

- Reemplazar ejes con `IdCandidato` por `NombreCompleto` o rankings.
- Usar barras horizontales para top 5; son mas legibles que areas/lineas para
  valores discretos.
- Evitar tablas grandes en la pagina ejecutiva; convertirlas en tooltip o ficha.
- Reducir mapas a una sola visual principal por pagina.

## Colores sugeridos

- Azul institucional: `#233A8B`
- Azul claro: `#6E7FD1`
- Rojo alerta: `#C43D4B`
- Amarillo medio: `#E0A82E`
- Verde bajo riesgo: `#2D8C72`
- Fondo: `#F5F6FA`
- Texto: `#1E2432`

Importar `dashboard/powerbi_theme_elecciones_2026.json` desde:

`Vista > Temas > Examinar temas`

## Campos nuevos recomendados

Ejecutar `database/views_powerbi_enhanced.sql` en Azure SQL y cargar estas vistas:

- `dbo.vw_dashboard_candidatos`
- `dbo.vw_dashboard_kpis`
- `dbo.vw_riesgo_partido_enhanced`
- `dbo.vw_ranking_candidatos`
- `dbo.vw_tiktok_ultimo_registro`

Estas vistas agregan edad, patrimonio declarado, conteos de bienes, educacion,
sentencias, visitas, categoria de riesgo y rankings.

## Medidas DAX sugeridas

Ver `docs/powerbi_measures.md`.
