IF OBJECT_ID('dbo.RedSocial', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RedSocial (
        IdRedSocial INT NOT NULL PRIMARY KEY,
        NombreRed NVARCHAR(50) NULL
    );
END;

IF OBJECT_ID('dbo.CandidatoRedSocial', 'U') IS NULL
BEGIN
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
END;

IF OBJECT_ID('dbo.PartidoRedSocial', 'U') IS NULL
BEGIN
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
END;

IF OBJECT_ID('dbo.HistorialTikTok', 'U') IS NULL
BEGIN
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
END;
