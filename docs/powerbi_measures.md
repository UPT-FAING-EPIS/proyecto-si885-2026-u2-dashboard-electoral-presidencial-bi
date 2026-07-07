# Medidas DAX sugeridas

Estas medidas estan pensadas para usarse con `dbo.vw_dashboard_candidatos`.

```DAX
Total Candidatos =
DISTINCTCOUNT(vw_dashboard_candidatos[IdCandidato])
```

```DAX
Candidatos Riesgo Alto =
CALCULATE(
    [Total Candidatos],
    vw_dashboard_candidatos[NivelRiesgoNumero] >= 3
)
```

```DAX
% Riesgo Alto =
DIVIDE([Candidatos Riesgo Alto], [Total Candidatos])
```

```DAX
Candidatos con Sentencias =
CALCULATE(
    [Total Candidatos],
    vw_dashboard_candidatos[CantidadSentencias] > 0
)
```

```DAX
% Con Sentencias =
DIVIDE([Candidatos con Sentencias], [Total Candidatos])
```

```DAX
Ingreso Promedio =
AVERAGE(vw_dashboard_candidatos[TotalIngresos])
```

```DAX
Patrimonio Promedio =
AVERAGE(vw_dashboard_candidatos[PatrimonioDeclarado])
```

```DAX
Edad Promedio =
AVERAGE(vw_dashboard_candidatos[Edad])
```

```DAX
% Mujeres =
DIVIDE(
    CALCULATE([Total Candidatos], vw_dashboard_candidatos[Sexo] = "Femenino"),
    [Total Candidatos]
)
```

```DAX
% Con Pregrado =
DIVIDE(
    CALCULATE([Total Candidatos], vw_dashboard_candidatos[TienePregrado] = 1),
    [Total Candidatos]
)
```

```DAX
% Con Posgrado =
DIVIDE(
    CALCULATE([Total Candidatos], vw_dashboard_candidatos[TienePosgrado] = 1),
    [Total Candidatos]
)
```

```DAX
Total Visitas Campania =
SUM(vw_dashboard_candidatos[CantidadVisitasCampania])
```

```DAX
Riesgo Promedio =
AVERAGE(vw_dashboard_candidatos[NivelRiesgoNumero])
```

## Formato recomendado

- `% Riesgo Alto`, `% Con Sentencias`, `% Mujeres`, `% Con Pregrado`, `% Con Posgrado`:
  porcentaje con 1 decimal.
- `Ingreso Promedio`, `Patrimonio Promedio`: moneda, escala en miles o millones.
- `Edad Promedio`, `Riesgo Promedio`: decimal con 1 o 2 posiciones.
