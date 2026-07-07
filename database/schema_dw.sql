CREATE TABLE dbo.Partido (
    IdPartido INT NOT NULL PRIMARY KEY,
    NombrePartido NVARCHAR(150) NOT NULL,
    LogoUrl NVARCHAR(500) NULL
);

CREATE TABLE dbo.Candidato (
    IdCandidato INT NOT NULL PRIMARY KEY,
    NombreCompleto NVARCHAR(200) NOT NULL,
    DNI NVARCHAR(15) NULL,
    Sexo NVARCHAR(20) NULL,
    CargoPostula NVARCHAR(200) NULL,
    IdPartido INT NULL,
    FechaNacimiento DATE NULL,
    FotoUrl NVARCHAR(500) NULL,
    CONSTRAINT FK_Candidato_Partido FOREIGN KEY (IdPartido) REFERENCES dbo.Partido(IdPartido)
);

CREATE TABLE dbo.Ubicacion (
    IdUbicacion INT NOT NULL PRIMARY KEY,
    Tipo NVARCHAR(50) NULL,
    Departamento NVARCHAR(100) NULL,
    Provincia NVARCHAR(100) NULL,
    Distrito NVARCHAR(100) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_Ubicacion_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.EducacionBasica (
    IdEducacionBasica INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    TieneEducacionBasica BIT NULL,
    TienePrimaria BIT NULL,
    TieneSecundaria BIT NULL,
    CONSTRAINT FK_EducacionBasica_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.EstudiosTecnicos (
    IdTecnico INT NOT NULL PRIMARY KEY,
    CentroEstudio NVARCHAR(200) NULL,
    Carrera NVARCHAR(200) NULL,
    Concluido BIT NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_EstudiosTecnicos_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.EstudiosNoUniversitarios (
    IdEstudioNoUni INT NOT NULL PRIMARY KEY,
    CentroEstudio NVARCHAR(200) NULL,
    Carrera NVARCHAR(200) NULL,
    Concluido BIT NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_EstudiosNoUniversitarios_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.EducacionUniversitaria (
    IdEducacion INT NOT NULL PRIMARY KEY,
    Universidad NVARCHAR(200) NULL,
    Grado NVARCHAR(200) NULL,
    Concluido BIT NULL,
    AñoObtencion DECIMAL(10, 1) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_EducacionUniversitaria_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.Posgrado (
    IdPosgrado INT NOT NULL PRIMARY KEY,
    CentroEstudio NVARCHAR(200) NULL,
    Especialidad NVARCHAR(200) NULL,
    Grado NVARCHAR(200) NULL,
    Concluido BIT NULL,
    AñoObtencion DECIMAL(10, 1) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_Posgrado_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.ExperienciaLaboral (
    IdExperiencia INT NOT NULL PRIMARY KEY,
    CentroTrabajo NVARCHAR(250) NULL,
    Cargo NVARCHAR(250) NULL,
    AnioInicio INT NULL,
    AnioFin DECIMAL(10, 1) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_ExperienciaLaboral_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.CargoPartidario (
    IdCargoPartidario INT NOT NULL PRIMARY KEY,
    Organizacion NVARCHAR(250) NULL,
    TipoCargo NVARCHAR(100) NULL,
    Cargo NVARCHAR(250) NULL,
    AnioInicio INT NULL,
    AnioFin DECIMAL(10, 1) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_CargoPartidario_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.RelacionSentencias (
    IdSentencia INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    MateriaDemanda NVARCHAR(250) NULL,
    FalloPena NVARCHAR(MAX) NULL,
    CONSTRAINT FK_RelacionSentencias_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.Ingresos (
    IdIngreso INT NOT NULL PRIMARY KEY,
    RemuneracionPublica DECIMAL(18, 2) NULL,
    RemuneracionPrivada DECIMAL(18, 2) NULL,
    Total DECIMAL(18, 2) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_Ingresos_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.Bien (
    IdBien INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    TipoBien NVARCHAR(100) NULL,
    Registro NVARCHAR(150) NULL,
    Descripcion NVARCHAR(MAX) NULL,
    ValorAutovaluo DECIMAL(18, 2) NULL,
    CONSTRAINT FK_Bien_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.VisitaCampaña (
    IdVisita INT NOT NULL PRIMARY KEY,
    TipoLugar NVARCHAR(100) NULL,
    NombreLugar NVARCHAR(200) NULL,
    IdCandidato INT NULL,
    CONSTRAINT FK_VisitaCampania_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.RedSocial (
    IdRedSocial INT NOT NULL PRIMARY KEY,
    NombreRed NVARCHAR(50) NULL
);

CREATE TABLE dbo.CandidatoRedSocial (
    IdCandidatoRed INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    IdRedSocial INT NULL,
    Tiene BIT NULL,
    MotivoNoTiene NVARCHAR(200) NULL,
    Usuario NVARCHAR(150) NULL,
    CantidadVideos INT NULL,
    Seguidores DECIMAL(18, 2) NULL,
    Likes BIGINT NULL,
    Videos INT NULL,
    CONSTRAINT FK_CandidatoRedSocial_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato),
    CONSTRAINT FK_CandidatoRedSocial_RedSocial FOREIGN KEY (IdRedSocial) REFERENCES dbo.RedSocial(IdRedSocial)
);

CREATE TABLE dbo.PartidoRedSocial (
    IdPartidoRed INT NOT NULL PRIMARY KEY,
    IdPartido INT NULL,
    IdRedSocial INT NULL,
    Tiene BIT NULL,
    MotivoNoTiene NVARCHAR(200) NULL,
    Usuario NVARCHAR(150) NULL,
    Seguidores DECIMAL(18, 2) NULL,
    Likes BIGINT NULL,
    CONSTRAINT FK_PartidoRedSocial_Partido FOREIGN KEY (IdPartido) REFERENCES dbo.Partido(IdPartido),
    CONSTRAINT FK_PartidoRedSocial_RedSocial FOREIGN KEY (IdRedSocial) REFERENCES dbo.RedSocial(IdRedSocial)
);

CREATE TABLE dbo.HistorialTikTok (
    IdHistorial INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    Usuario NVARCHAR(100) NULL,
    Seguidores INT NULL,
    FechaRegistro DATETIME2 NULL,
    Likes BIGINT NULL,
    Videos INT NULL,
    CONSTRAINT FK_HistorialTikTok_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.FuenteInformacion (
    IdFuente INT NOT NULL PRIMARY KEY,
    NombreFuente NVARCHAR(250) NULL,
    TipoFuente NVARCHAR(100) NULL,
    LinkFuente NVARCHAR(1000) NULL
);

CREATE TABLE dbo.ClasificacionLegalPenal (
    IdClasificacion INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    NivelPrincipal NVARCHAR(20) NULL,
    SubNivel NVARCHAR(20) NULL,
    SubSubNivel NVARCHAR(20) NULL,
    CodigoCompleto NVARCHAR(50) NULL,
    Justificacion NVARCHAR(MAX) NULL,
    FechaRegistro DATETIME2 NULL,
    CONSTRAINT FK_ClasificacionLegalPenal_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);

CREATE TABLE dbo.VariableSecundaria (
    IdVariable INT NOT NULL PRIMARY KEY,
    Codigo NVARCHAR(20) NULL
);

CREATE TABLE dbo.SubVariable (
    IdSubVariable INT NOT NULL PRIMARY KEY,
    IdVariable INT NULL,
    Codigo NVARCHAR(20) NULL,
    CONSTRAINT FK_SubVariable_VariableSecundaria FOREIGN KEY (IdVariable) REFERENCES dbo.VariableSecundaria(IdVariable)
);

CREATE TABLE dbo.ClasificacionVariable (
    IdClasificacionVariable INT NOT NULL PRIMARY KEY,
    IdClasificacion INT NULL,
    IdVariable INT NULL,
    IdSubVariable INT NULL,
    Justificacion NVARCHAR(MAX) NULL,
    CONSTRAINT FK_ClasificacionVariable_Clasificacion FOREIGN KEY (IdClasificacion) REFERENCES dbo.ClasificacionLegalPenal(IdClasificacion),
    CONSTRAINT FK_ClasificacionVariable_Variable FOREIGN KEY (IdVariable) REFERENCES dbo.VariableSecundaria(IdVariable),
    CONSTRAINT FK_ClasificacionVariable_SubVariable FOREIGN KEY (IdSubVariable) REFERENCES dbo.SubVariable(IdSubVariable)
);

CREATE TABLE dbo.NoticiasPendientes (
    IdNoticia INT NOT NULL PRIMARY KEY,
    IdCandidato INT NULL,
    Titular NVARCHAR(500) NULL,
    NombreMedio NVARCHAR(250) NULL,
    URL NVARCHAR(1000) NULL,
    FechaNoticia DATETIME2 NULL,
    NivelPrincipalSugerido NVARCHAR(20) NULL,
    SubNivelSugerido NVARCHAR(20) NULL,
    SubSubNivelSugerido NVARCHAR(20) NULL,
    VariablesHSugeridas NVARCHAR(200) NULL,
    JustificacionIA NVARCHAR(MAX) NULL,
    EstadoRevision NVARCHAR(100) NULL,
    CONSTRAINT FK_NoticiasPendientes_Candidato FOREIGN KEY (IdCandidato) REFERENCES dbo.Candidato(IdCandidato)
);
