# Diccionario de Datos

## Proyecto

**Sistema:** Dashboard Electoral Presidencial BI - Elecciones Generales Peru 2026  
**Almacen de datos:** Azure SQL Database `Elecciones2026DW`  
**Fuente principal:** archivos CSV de la carpeta [`data`](./data)  
**Modelo:** relacional normalizado con vistas analiticas para Power BI.

## Tablas del Almacen de Datos

| Tabla | Proposito | Campos principales |
| --- | --- | --- |
| `Partido` | Organizaciones politicas participantes. | `IdPartido`, `NombrePartido`, `LogoUrl` |
| `Candidato` | Datos generales del candidato. | `IdCandidato`, `NombreCompleto`, `DNI`, `Sexo`, `CargoPostula`, `IdPartido`, `FechaNacimiento`, `FotoUrl` |
| `Ubicacion` | Domicilio o ubicacion asociada al candidato. | `IdUbicacion`, `Tipo`, `Departamento`, `Provincia`, `Distrito`, `IdCandidato` |
| `EducacionBasica` | Registro de educacion primaria/secundaria. | `IdEducacionBasica`, `IdCandidato`, `TieneEducacionBasica`, `TienePrimaria`, `TieneSecundaria` |
| `EstudiosTecnicos` | Estudios tecnicos declarados. | `IdTecnico`, `CentroEstudio`, `Carrera`, `Concluido`, `IdCandidato` |
| `EstudiosNoUniversitarios` | Estudios no universitarios declarados. | `IdEstudioNoUni`, `CentroEstudio`, `Carrera`, `Concluido`, `IdCandidato` |
| `EducacionUniversitaria` | Estudios universitarios y grados. | `IdEducacion`, `Universidad`, `Grado`, `Concluido`, `AñoObtencion`, `IdCandidato` |
| `Posgrado` | Estudios de posgrado. | `IdPosgrado`, `CentroEstudio`, `Especialidad`, `Grado`, `Concluido`, `AñoObtencion`, `IdCandidato` |
| `ExperienciaLaboral` | Trayectoria laboral declarada. | `IdExperiencia`, `CentroTrabajo`, `Cargo`, `AnioInicio`, `AnioFin`, `IdCandidato` |
| `CargoPartidario` | Cargos dentro de organizaciones politicas. | `IdCargoPartidario`, `Organizacion`, `TipoCargo`, `Cargo`, `AnioInicio`, `AnioFin`, `IdCandidato` |
| `RelacionSentencias` | Sentencias o antecedentes judiciales declarados. | `IdSentencia`, `IdCandidato`, `MateriaDemanda`, `FalloPena` |
| `Ingresos` | Ingresos publicos, privados y total declarado. | `IdIngreso`, `RemuneracionPublica`, `RemuneracionPrivada`, `Total`, `IdCandidato` |
| `Bien` | Bienes muebles e inmuebles declarados. | `IdBien`, `IdCandidato`, `TipoBien`, `Registro`, `Descripcion`, `ValorAutovaluo` |
| `VisitaCampaña` | Lugares visitados durante actividades de campaña. | `IdVisita`, `TipoLugar`, `NombreLugar`, `IdCandidato` |
| `FuenteInformacion` | Fuentes usadas para validar informacion. | `IdFuente`, `NombreFuente`, `TipoFuente`, `LinkFuente` |
| `ClasificacionLegalPenal` | Nivel de riesgo legal asignado al candidato. | `IdClasificacion`, `IdCandidato`, `NivelPrincipal`, `SubNivel`, `SubSubNivel`, `CodigoCompleto`, `Justificacion`, `FechaRegistro` |
| `VariableSecundaria` | Variables secundarias de clasificacion. | `IdVariable`, `Codigo` |
| `SubVariable` | Subvariables asociadas a la clasificacion. | `IdSubVariable`, `IdVariable`, `Codigo` |
| `ClasificacionVariable` | Relacion entre clasificacion legal y variables de riesgo. | `IdClasificacionVariable`, `IdClasificacion`, `IdVariable`, `IdSubVariable`, `Justificacion` |
| `NoticiasPendientes` | Noticias candidatas a revision o validacion posterior. | `IdNoticia`, `IdCandidato`, `Titular`, `NombreMedio`, `URL`, `FechaNoticia`, `NivelPrincipalSugerido`, `EstadoRevision` |

## Vistas Analiticas para Power BI

| Vista | Uso |
| --- | --- |
| `dbo.vw_dashboard_candidatos` | Vista central del dashboard; consolida candidato, partido, ubicacion, educacion, ingresos, bienes, sentencias, visitas y riesgo. |
| `dbo.vw_dashboard_kpis` | Indicadores generales: total de candidatos, edad promedio, ingresos, patrimonio, educacion y riesgo. |
| `dbo.vw_riesgo_partido_enhanced` | Comparacion de riesgo legal por partido politico. |
| `dbo.vw_ranking_candidatos` | Rankings por riesgo, ingresos, patrimonio y actividad de campaña. |
| `dbo.vw_tiktok_ultimo_registro` | Ultimo registro disponible de metricas TikTok por candidato. |
| `dbo.vw_campania_lugar_candidatos` | Analisis territorial de visitas de campaña. |

## Reglas de Interpretacion

* Los campos vacios representan informacion no declarada o no disponible en la fuente.
* Los campos `Concluido` se interpretan como booleanos: `1` para concluido y `0` para no concluido.
* `NivelPrincipal` clasifica el riesgo legal en escala N0-N5.
* `Total` en `Ingresos` representa la suma declarada de remuneracion publica y privada cuando existe informacion disponible.
* `ValorAutovaluo` representa el valor declarado del bien, no necesariamente el valor comercial actualizado.

## Scripts Relacionados

* Esquema fisico del almacen: [`database/schema_dw.sql`](./database/schema_dw.sql)
* Vistas para Power BI: [`database/views_powerbi_enhanced.sql`](./database/views_powerbi_enhanced.sql)
* Carga ETL: [`etl/load_csv_to_azure_sql.py`](./etl/load_csv_to_azure_sql.py)
* Verificacion de vistas: [`database/verify_powerbi_enhanced_views.sql`](./database/verify_powerbi_enhanced_views.sql)
