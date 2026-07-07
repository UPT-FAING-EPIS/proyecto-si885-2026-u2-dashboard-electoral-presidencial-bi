/*
Power BI enhanced views for the Elecciones 2026 dashboard.

Use after database/schema_dw.sql and the base data load. These views are meant
to simplify report visuals, reduce repeated DAX, and replace technical fields
such as IdCandidato on axes with analytical labels.
*/

CREATE OR ALTER VIEW dbo.vw_dashboard_candidatos AS
WITH bienes AS (
    SELECT
        IdCandidato,
        COUNT(*) AS CantidadBienes,
        SUM(COALESCE(ValorAutovaluo, 0)) AS PatrimonioDeclarado,
        SUM(CASE WHEN TipoBien = 'INMUEBLE' THEN 1 ELSE 0 END) AS CantidadInmuebles,
        SUM(CASE WHEN TipoBien = 'MUEBLE' THEN 1 ELSE 0 END) AS CantidadMuebles
    FROM dbo.Bien
    GROUP BY IdCandidato
),
educacion AS (
    SELECT
        c.IdCandidato,
        CASE WHEN EXISTS (
            SELECT 1
            FROM dbo.EducacionUniversitaria eu
            WHERE eu.IdCandidato = c.IdCandidato
              AND COALESCE(eu.Concluido, 0) = 1
        ) THEN 1 ELSE 0 END AS TienePregrado,
        CASE WHEN EXISTS (
            SELECT 1
            FROM dbo.Posgrado pg
            WHERE pg.IdCandidato = c.IdCandidato
              AND COALESCE(pg.Concluido, 0) = 1
        ) THEN 1 ELSE 0 END AS TienePosgrado,
        CASE WHEN EXISTS (
            SELECT 1
            FROM dbo.EstudiosTecnicos et
            WHERE et.IdCandidato = c.IdCandidato
              AND COALESCE(et.Concluido, 0) = 1
        ) THEN 1 ELSE 0 END AS TieneTecnico
    FROM dbo.Candidato c
),
sentencias AS (
    SELECT
        IdCandidato,
        COUNT(*) AS CantidadSentencias
    FROM dbo.RelacionSentencias
    GROUP BY IdCandidato
),
experiencia AS (
    SELECT
        IdCandidato,
        COUNT(*) AS CantidadExperiencias,
        MIN(AnioInicio) AS PrimerAnioExperiencia,
        MAX(TRY_CONVERT(INT, AnioFin)) AS UltimoAnioExperiencia
    FROM dbo.ExperienciaLaboral
    GROUP BY IdCandidato
),
visitas AS (
    SELECT
        IdCandidato,
        COUNT(*) AS CantidadVisitasCampania,
        COUNT(DISTINCT NombreLugar) AS LugaresVisitados
    FROM dbo.[VisitaCampaña]
    GROUP BY IdCandidato
)
SELECT
    c.IdCandidato,
    c.NombreCompleto,
    c.DNI,
    c.Sexo,
    c.CargoPostula,
    c.FechaNacimiento,
    DATEDIFF(YEAR, c.FechaNacimiento, CAST(GETDATE() AS DATE))
        - CASE
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, c.FechaNacimiento, CAST(GETDATE() AS DATE)), c.FechaNacimiento) > CAST(GETDATE() AS DATE)
            THEN 1 ELSE 0
          END AS Edad,
    p.NombrePartido,
    p.LogoUrl,
    u.Departamento,
    u.Provincia,
    u.Distrito,
    COALESCE(i.RemuneracionPublica, 0) AS RemuneracionPublica,
    COALESCE(i.RemuneracionPrivada, 0) AS RemuneracionPrivada,
    COALESCE(i.Total, 0) AS TotalIngresos,
    COALESCE(b.CantidadBienes, 0) AS CantidadBienes,
    COALESCE(b.PatrimonioDeclarado, 0) AS PatrimonioDeclarado,
    COALESCE(b.CantidadInmuebles, 0) AS CantidadInmuebles,
    COALESCE(b.CantidadMuebles, 0) AS CantidadMuebles,
    COALESCE(e.TienePregrado, 0) AS TienePregrado,
    COALESCE(e.TienePosgrado, 0) AS TienePosgrado,
    COALESCE(e.TieneTecnico, 0) AS TieneTecnico,
    COALESCE(s.CantidadSentencias, 0) AS CantidadSentencias,
    COALESCE(x.CantidadExperiencias, 0) AS CantidadExperiencias,
    x.PrimerAnioExperiencia,
    x.UltimoAnioExperiencia,
    COALESCE(v.CantidadVisitasCampania, 0) AS CantidadVisitasCampania,
    COALESCE(v.LugaresVisitados, 0) AS LugaresVisitados,
    clp.NivelPrincipal,
    TRY_CONVERT(INT, clp.NivelPrincipal) AS NivelRiesgoNumero,
    clp.SubNivel,
    clp.SubSubNivel,
    clp.CodigoCompleto,
    clp.Justificacion,
    CASE
        WHEN TRY_CONVERT(INT, clp.NivelPrincipal) >= 4 THEN 'Riesgo critico'
        WHEN TRY_CONVERT(INT, clp.NivelPrincipal) = 3 THEN 'Riesgo alto'
        WHEN TRY_CONVERT(INT, clp.NivelPrincipal) = 2 THEN 'Riesgo medio'
        WHEN TRY_CONVERT(INT, clp.NivelPrincipal) = 1 THEN 'Riesgo bajo'
        WHEN TRY_CONVERT(INT, clp.NivelPrincipal) = 0 THEN 'Sin alerta principal'
        ELSE 'Sin clasificacion'
    END AS CategoriaRiesgo
FROM dbo.Candidato c
LEFT JOIN dbo.Partido p ON p.IdPartido = c.IdPartido
LEFT JOIN dbo.Ubicacion u ON u.IdCandidato = c.IdCandidato AND u.Tipo = 'Domicilio'
LEFT JOIN dbo.Ingresos i ON i.IdCandidato = c.IdCandidato
LEFT JOIN bienes b ON b.IdCandidato = c.IdCandidato
LEFT JOIN educacion e ON e.IdCandidato = c.IdCandidato
LEFT JOIN sentencias s ON s.IdCandidato = c.IdCandidato
LEFT JOIN experiencia x ON x.IdCandidato = c.IdCandidato
LEFT JOIN visitas v ON v.IdCandidato = c.IdCandidato
LEFT JOIN dbo.ClasificacionLegalPenal clp ON clp.IdCandidato = c.IdCandidato;

GO

CREATE OR ALTER VIEW dbo.vw_dashboard_kpis AS
SELECT
    COUNT(*) AS TotalCandidatos,
    AVG(CAST(Edad AS DECIMAL(10, 2))) AS EdadPromedio,
    AVG(CAST(TotalIngresos AS DECIMAL(18, 2))) AS IngresoPromedio,
    AVG(CAST(PatrimonioDeclarado AS DECIMAL(18, 2))) AS PatrimonioPromedio,
    SUM(CASE WHEN Sexo = 'Femenino' THEN 1 ELSE 0 END) AS CandidatasMujeres,
    SUM(CASE WHEN Sexo = 'Masculino' THEN 1 ELSE 0 END) AS CandidatosHombres,
    SUM(CASE WHEN TienePregrado = 1 THEN 1 ELSE 0 END) AS CandidatosConPregrado,
    SUM(CASE WHEN TienePosgrado = 1 THEN 1 ELSE 0 END) AS CandidatosConPosgrado,
    SUM(CASE WHEN CantidadSentencias > 0 THEN 1 ELSE 0 END) AS CandidatosConSentencias,
    SUM(CASE WHEN NivelRiesgoNumero >= 3 THEN 1 ELSE 0 END) AS CandidatosRiesgoAlto,
    SUM(CantidadVisitasCampania) AS TotalVisitasCampania
FROM dbo.vw_dashboard_candidatos;

GO

CREATE OR ALTER VIEW dbo.vw_riesgo_partido_enhanced AS
SELECT
    NombrePartido,
    CategoriaRiesgo,
    NivelRiesgoNumero,
    COUNT(*) AS CantidadCandidatos,
    AVG(CAST(TotalIngresos AS DECIMAL(18, 2))) AS IngresoPromedio,
    AVG(CAST(PatrimonioDeclarado AS DECIMAL(18, 2))) AS PatrimonioPromedio,
    SUM(CantidadSentencias) AS TotalSentencias
FROM dbo.vw_dashboard_candidatos
GROUP BY
    NombrePartido,
    CategoriaRiesgo,
    NivelRiesgoNumero;

GO

CREATE OR ALTER VIEW dbo.vw_ranking_candidatos AS
SELECT
    IdCandidato,
    NombreCompleto,
    NombrePartido,
    CargoPostula,
    CategoriaRiesgo,
    NivelRiesgoNumero,
    TotalIngresos,
    PatrimonioDeclarado,
    CantidadSentencias,
    CantidadVisitasCampania,
    LugaresVisitados,
    ROW_NUMBER() OVER (ORDER BY NivelRiesgoNumero DESC, CantidadSentencias DESC, TotalIngresos DESC) AS RankingRiesgo,
    ROW_NUMBER() OVER (ORDER BY TotalIngresos DESC) AS RankingIngresos,
    ROW_NUMBER() OVER (ORDER BY PatrimonioDeclarado DESC) AS RankingPatrimonio,
    ROW_NUMBER() OVER (ORDER BY CantidadVisitasCampania DESC, LugaresVisitados DESC) AS RankingCampania
FROM dbo.vw_dashboard_candidatos;

GO

CREATE OR ALTER VIEW dbo.vw_tiktok_ultimo_registro AS
WITH ranked AS (
    SELECT
        h.*,
        ROW_NUMBER() OVER (
            PARTITION BY h.IdCandidato
            ORDER BY h.FechaRegistro DESC, h.IdHistorial DESC
        ) AS rn
    FROM dbo.HistorialTikTok h
)
SELECT
    r.IdCandidato,
    c.NombreCompleto,
    p.NombrePartido,
    r.Usuario,
    r.Seguidores,
    r.Likes,
    r.Videos,
    r.FechaRegistro
FROM ranked r
LEFT JOIN dbo.Candidato c ON c.IdCandidato = r.IdCandidato
LEFT JOIN dbo.Partido p ON p.IdPartido = c.IdPartido
WHERE r.rn = 1;

GO

CREATE OR ALTER VIEW dbo.vw_campania_lugar_candidatos AS
WITH lugares AS (
    SELECT DISTINCT
        UPPER(LTRIM(RTRIM(NombreLugar))) AS NombreLugar
    FROM dbo.[VisitaCampaña]
    WHERE NULLIF(LTRIM(RTRIM(NombreLugar)), '') IS NOT NULL

    UNION

    SELECT DISTINCT
        UPPER(LTRIM(RTRIM(Departamento))) AS NombreLugar
    FROM dbo.Ubicacion
    WHERE NULLIF(LTRIM(RTRIM(Departamento)), '') IS NOT NULL

    UNION

    SELECT DISTINCT
        UPPER(LTRIM(RTRIM(Provincia))) AS NombreLugar
    FROM dbo.Ubicacion
    WHERE NULLIF(LTRIM(RTRIM(Provincia)), '') IS NOT NULL

    UNION

    SELECT DISTINCT
        UPPER(LTRIM(RTRIM(Distrito))) AS NombreLugar
    FROM dbo.Ubicacion
    WHERE NULLIF(LTRIM(RTRIM(Distrito)), '') IS NOT NULL
),
visitas AS (
    SELECT
        UPPER(LTRIM(RTRIM(NombreLugar))) AS NombreLugar,
        IdCandidato,
        MAX(TipoLugar) AS TipoLugar,
        COUNT(*) AS CantidadVisitasCampania
    FROM dbo.[VisitaCampaña]
    WHERE NULLIF(LTRIM(RTRIM(NombreLugar)), '') IS NOT NULL
    GROUP BY
        UPPER(LTRIM(RTRIM(NombreLugar))),
        IdCandidato
)
SELECT
    l.NombreLugar,
    COALESCE(v.TipoLugar, 'Sin campania registrada') AS TipoLugar,
    c.IdCandidato,
    c.NombreCompleto,
    p.NombrePartido,
    COALESCE(v.CantidadVisitasCampania, 0) AS CantidadVisitasCampania,
    CASE WHEN v.IdCandidato IS NULL THEN 0 ELSE 1 END AS TieneCampaniaRegistrada
FROM lugares l
LEFT JOIN visitas v ON v.NombreLugar = l.NombreLugar
LEFT JOIN dbo.Candidato c ON c.IdCandidato = v.IdCandidato
LEFT JOIN dbo.Partido p ON p.IdPartido = c.IdPartido;

GO
