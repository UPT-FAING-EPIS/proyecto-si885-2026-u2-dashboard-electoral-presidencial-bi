SET NOCOUNT ON;

SELECT name
FROM sys.views
WHERE name IN (
    'vw_dashboard_candidatos',
    'vw_dashboard_kpis',
    'vw_riesgo_partido_enhanced',
    'vw_ranking_candidatos',
    'vw_tiktok_ultimo_registro'
)
ORDER BY name;

SELECT COUNT(*) AS TotalCandidatos
FROM dbo.vw_dashboard_candidatos;

SELECT *
FROM dbo.vw_dashboard_kpis;

SELECT TOP 10
    NombreCompleto,
    NombrePartido,
    CategoriaRiesgo,
    NivelRiesgoNumero,
    TotalIngresos,
    PatrimonioDeclarado,
    CantidadSentencias,
    CantidadVisitasCampania
FROM dbo.vw_ranking_candidatos
ORDER BY RankingRiesgo;
