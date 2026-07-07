SELECT COUNT(*) AS total_candidatos
FROM dbo.Candidato;

SELECT TOP 10 *
FROM dbo.vw_resumen_candidatos
ORDER BY IdCandidato;

SELECT *
FROM dbo.vw_riesgo_por_partido
ORDER BY NombrePartido, NivelPrincipal;
