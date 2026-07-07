CREATE OR ALTER VIEW dbo.vw_resumen_candidatos AS
SELECT
    c.IdCandidato,
    c.NombreCompleto,
    c.DNI,
    c.Sexo,
    c.CargoPostula,
    c.FechaNacimiento,
    p.NombrePartido,
    u.Departamento,
    u.Provincia,
    u.Distrito,
    i.Total AS TotalIngresos,
    COUNT(DISTINCT b.IdBien) AS CantidadBienes,
    MAX(clp.CodigoCompleto) AS MaximoCodigoRiesgo
FROM dbo.Candidato c
LEFT JOIN dbo.Partido p ON p.IdPartido = c.IdPartido
LEFT JOIN dbo.Ubicacion u ON u.IdCandidato = c.IdCandidato AND u.Tipo = 'Domicilio'
LEFT JOIN dbo.Ingresos i ON i.IdCandidato = c.IdCandidato
LEFT JOIN dbo.Bien b ON b.IdCandidato = c.IdCandidato
LEFT JOIN dbo.ClasificacionLegalPenal clp ON clp.IdCandidato = c.IdCandidato
GROUP BY
    c.IdCandidato,
    c.NombreCompleto,
    c.DNI,
    c.Sexo,
    c.CargoPostula,
    c.FechaNacimiento,
    p.NombrePartido,
    u.Departamento,
    u.Provincia,
    u.Distrito,
    i.Total;

GO

CREATE OR ALTER VIEW dbo.vw_riesgo_por_partido AS
SELECT
    p.NombrePartido,
    clp.NivelPrincipal,
    COUNT(DISTINCT c.IdCandidato) AS CantidadCandidatos
FROM dbo.Candidato c
INNER JOIN dbo.Partido p ON p.IdPartido = c.IdPartido
LEFT JOIN dbo.ClasificacionLegalPenal clp ON clp.IdCandidato = c.IdCandidato
GROUP BY p.NombrePartido, clp.NivelPrincipal;
