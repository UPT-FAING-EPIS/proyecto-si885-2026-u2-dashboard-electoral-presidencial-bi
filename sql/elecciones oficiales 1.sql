CREATE DATABASE Elecciones2026DB17;
GO
USE Elecciones2026DB17;
GO

--1. INFORMACIÓN BÁSICA Y PARTIDOS

CREATE TABLE Partido (
    IdPartido INT PRIMARY KEY IDENTITY,
    NombrePartido VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE Candidato (
    IdCandidato INT PRIMARY KEY IDENTITY,
    NombreCompleto VARCHAR(200) NOT NULL,
    DNI VARCHAR(15) UNIQUE,
    Sexo VARCHAR(20),
    CargoPostula VARCHAR(200),
    IdPartido INT,
    FOREIGN KEY (IdPartido) REFERENCES Partido(IdPartido)
);

CREATE TABLE Ubicacion (
    IdUbicacion INT PRIMARY KEY IDENTITY,
    Tipo VARCHAR(50), -- Nacimiento, Domicilio
    Departamento VARCHAR(100),
    Provincia VARCHAR(100),
    Distrito VARCHAR(100),
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

--2. TRAYECTORIA ACADÉMICA Y LABORAL

CREATE TABLE EducacionBasica (
    IdEducacionBasica INT PRIMARY KEY IDENTITY,
    IdCandidato INT,
    TieneEducacionBasica BIT,
    TienePrimaria BIT,
    TieneSecundaria BIT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE EstudiosTecnicos (
    IdTecnico INT PRIMARY KEY IDENTITY,
    CentroEstudio VARCHAR(200),
    Carrera VARCHAR(200),
    Concluido BIT,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE EstudiosNoUniversitarios (
    IdEstudioNoUni INT PRIMARY KEY IDENTITY,
    CentroEstudio VARCHAR(200),
    Carrera VARCHAR(200),
    Concluido BIT,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE EducacionUniversitaria (
    IdEducacion INT PRIMARY KEY IDENTITY,
    Universidad VARCHAR(200),
    Grado VARCHAR(200),
    Concluido BIT,
    AñoObtencion INT NULL,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE Posgrado (
    IdPosgrado INT PRIMARY KEY IDENTITY,
    CentroEstudio VARCHAR(200),
    Especialidad VARCHAR(200),
    Grado VARCHAR(200),
    Concluido BIT,
    AñoObtencion INT NULL,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE ExperienciaLaboral (
    IdExperiencia INT PRIMARY KEY IDENTITY,
    CentroTrabajo VARCHAR(200),
    Cargo VARCHAR(200),
    AnioInicio SMALLINT,
    AnioFin SMALLINT NULL,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE CargoPartidario (
    IdCargoPartidario INT PRIMARY KEY IDENTITY,
    Organizacion VARCHAR(200),
    TipoCargo VARCHAR(50),
    Cargo VARCHAR(200),
    AnioInicio SMALLINT,
    AnioFin SMALLINT NULL,
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

--3. ECONOMÍA, SENTENCIAS Y CAMPAÑA

CREATE TABLE RelacionSentencias (
    IdSentencia INT PRIMARY KEY IDENTITY,
    IdCandidato INT NOT NULL,
    MateriaDemanda VARCHAR(200),
    FalloPena TEXT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE Ingresos (
    IdIngreso INT PRIMARY KEY IDENTITY,
    RemuneracionPublica DECIMAL(18,2),
    RemuneracionPrivada DECIMAL(18,2),
    Total DECIMAL(18,2),
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE Bien (
    IdBien INT PRIMARY KEY IDENTITY,
    IdCandidato INT NOT NULL,
    TipoBien VARCHAR(50),
    Registro VARCHAR(150),
    Descripcion VARCHAR(200) NULL,
    ValorAutovaluo DECIMAL(18,2),
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE VisitaCampaña (
    IdVisita INT PRIMARY KEY IDENTITY,
    TipoLugar VARCHAR(50), -- Distrito, Provincia, Region
    NombreLugar VARCHAR(150),
    IdCandidato INT,
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

--4. REDES SOCIALES

CREATE TABLE RedSocial (
    IdRedSocial INT PRIMARY KEY IDENTITY,
    NombreRed VARCHAR(50) UNIQUE
);

CREATE TABLE CandidatoRedSocial (
    IdCandidatoRed INT PRIMARY KEY IDENTITY,
    IdCandidato INT,
    IdRedSocial INT,
    Tiene BIT,
    MotivoNoTiene VARCHAR(200),
    Usuario VARCHAR(150),
    CantidadVideos INT,
    Seguidores DECIMAL(10,2),
    Likes DECIMAL(10,2),
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato),
    FOREIGN KEY (IdRedSocial) REFERENCES RedSocial(IdRedSocial)
);

CREATE TABLE PartidoRedSocial (
    IdPartidoRed INT PRIMARY KEY IDENTITY,
    IdPartido INT,
    IdRedSocial INT,
    Tiene BIT,
    MotivoNoTiene VARCHAR(200),
    Usuario VARCHAR(150),
    Seguidores DECIMAL(10,2),
    Likes DECIMAL(10,2),
    FOREIGN KEY (IdPartido) REFERENCES Partido(IdPartido),
    FOREIGN KEY (IdRedSocial) REFERENCES RedSocial(IdRedSocial)
);

-- 5. CLASIFICACIÓN AVANZADA Y DICCIONARIO H

CREATE TABLE FuenteInformacion (
    IdFuente INT PRIMARY KEY IDENTITY,
    NombreFuente VARCHAR(200) NOT NULL,
    TipoFuente VARCHAR(50) NOT NULL,
    LinkFuente VARCHAR(500) NULL,
    UNIQUE (NombreFuente, LinkFuente)
);

CREATE TABLE ClasificacionLegalPenal (
    IdClasificacion INT PRIMARY KEY IDENTITY,
    IdCandidato INT NOT NULL,
    NivelPrincipal INT NOT NULL,     -- 0 al 5
    SubNivel VARCHAR(10) NULL,        -- A, B, J...
    SubSubNivel VARCHAR(10) NULL,     -- COR, PAT, DOC, VIO, etc.
    CodigoCompleto VARCHAR(25),       -- Ej: N4-A (COR)
    Justificacion TEXT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdCandidato) REFERENCES Candidato(IdCandidato)
);

CREATE TABLE VariableSecundaria (
    IdVariable INT PRIMARY KEY IDENTITY,
    Codigo VARCHAR(10) UNIQUE -- H1, H2, H3...
);

CREATE TABLE SubVariable (
    IdSubVariable INT PRIMARY KEY IDENTITY,
    IdVariable INT NOT NULL,
    Codigo VARCHAR(10), -- A, B, C...
    FOREIGN KEY (IdVariable) REFERENCES VariableSecundaria(IdVariable),
    CONSTRAINT UQ_SubVariable UNIQUE (IdVariable, Codigo)
);

CREATE TABLE ClasificacionVariable (
    IdClasificacionVariable INT PRIMARY KEY IDENTITY,
    IdClasificacion INT NOT NULL,
    IdVariable INT NOT NULL,
    IdSubVariable INT NULL, -- NULL para H2 (sin subdivisiones)
    Justificacion TEXT NULL,
    FOREIGN KEY (IdClasificacion) REFERENCES ClasificacionLegalPenal(IdClasificacion),
    FOREIGN KEY (IdVariable) REFERENCES VariableSecundaria(IdVariable),
    FOREIGN KEY (IdSubVariable) REFERENCES SubVariable(IdSubVariable)
);
GO

--6. CARGA DE DICCIONARIO H (VARIABLES)

INSERT INTO VariableSecundaria (Codigo) 
VALUES ('H1'),('H2'),('H3'),('H4'),('H5'),('H6'),('H7'),('H8'),('H9');

-- Subvariables para H7 (Archivados)
DECLARE @h7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
INSERT INTO SubVariable (IdVariable, Codigo) VALUES 
(@h7, 'A'), (@h7, 'B'), (@h7, 'C'), (@h7, 'D'), (@h7, 'E');

-- Subvariables para H8 (Litigios)
DECLARE @h8 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H8');
INSERT INTO SubVariable (IdVariable, Codigo) VALUES (@h8, 'A'), (@h8, 'B');

-- Subvariables para H9 (Medidas Judiciales)
DECLARE @h9 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H9');
INSERT INTO SubVariable (IdVariable, Codigo) VALUES (@h9, 'A'), (@h9, 'B'), (@h9, 'C');
GO


/* =====================================================
   REGISTRO INTEGRAL: PABLO ALFONSO LÓPEZ CHAU NAVA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'AHORA NACION - AN')
    INSERT INTO Partido (NombrePartido) VALUES ('AHORA NACION - AN');

DECLARE @IdP INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='AHORA NACION - AN');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('PABLO ALFONSO LOPEZ CHAU NAVA', '25331980', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP);

DECLARE @IdC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato)
VALUES
('Nacimiento','LIMA','LIMA','LIMA', @IdC),
('Domicilio','LIMA','LIMA','MIRAFLORES', @IdC);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad Nacional del Callao','ECONOMISTA', 1, NULL, @IdC),
('Universidad Nacional del Callao','BACHILLER EN CIENCIAS ECONOMICAS', 1, 1976, @IdC);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO','DOCTOR EN ECONOMÍA','DOCTORADO', 1, 2005, @IdC),
('UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO','MAGISTER EN ECONOMÍA','MAESTRIA', 1, 2002, @IdC);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('Universidad Nacional de Ingeniería','RECTOR', 2021, 2025, @IdC),
('Universidad Nacional de Ingeniería','DIRECTOR DE LA ESCUELA DE INGENIERÍA ECONÓMICA', 2017, 2019, @IdC),
('Universidad Nacional de Ingeniería','PROFESOR PRINCIPAL', 1990, 2025, @IdC);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('AHORA NACION - AN','PARTIDARIO','FUNDADOR', 2023, NULL, @IdC),
('ALIANZA ELECTORAL AHORA NACION','PARTIDARIO','PRESIDENTE', 2025, 2025, @IdC);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (350000.00, 0.00, 350000.00, @IdC);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
(@IdC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Propiedad 1', 0.00),
(@IdC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Propiedad 2', 0.00);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC, @IdRS, 1, NULL, 'alfonso.lopezchau', 121, 61.3, 872.7);
INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene, Usuario, Seguidores, Likes)
VALUES (@IdP, @IdRS, 1,NULL, 'ahoranacion_oficial', 27.1, 266);

-- 9. VISITAS DE CAMPAÑA (Resumen de principales)
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO','EL AGUSTINO',@IdC),
('DISTRITO','LURIGANCHO-CHOSICA',@IdC),
('DISTRITO','RÍMAC',@IdC),
('PROVINCIA','CONDORCANQUI',@IdC),
('PROVINCIA','MAYNAS',@IdC),
('PROVINCIA','SANTA',@IdC),
('PROVINCIA','MOQUEGUA',@IdC),
('PROVINCIA','TRUJILLO',@IdC),
('PROVINCIA','CHICLAYO',@IdC),
('PROVINCIA','PIURA',@IdC),
('PROVINCIA','TUMBES',@IdC),
('PROVINCIA','SAN ROMÁN',@IdC),
('PROVINCIA','PUNO',@IdC),
('PROVINCIA','ALTO AMAZONAS',@IdC),
('PROVINCIA','CUSCO',@IdC),
('PROVINCIA','SAN IGNACIO',@IdC),
('PROVINCIA','JAÉN',@IdC),
('PROVINCIA','TACNA',@IdC),
('PROVINCIA','URUBAMBA',@IdC),
('PROVINCIA','CALLAO',@IdC),
('REGION','AMAZONAS',@IdC),
('REGION','LORETO',@IdC),
('REGION','ÁNCASH',@IdC),
('REGION','MOQUEGUA',@IdC),
('REGION','LA LIBERTAD',@IdC),
('REGION','LAMBAYEQUE',@IdC),
('REGION','PIURA',@IdC),
('REGION','TUMBES',@IdC),
('REGION','PUNO',@IdC),
('REGION','CUSCO',@IdC),
('REGION','CAJAMARCA',@IdC),
('REGION','TACNA',@IdC);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H (UNIFICADO)

-- A. Insertamos la clasificación UNA SOLA VEZ (N4-A COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC, 4, 'A', 'COR', 'N4-A (COR)', 
    'Acusación fiscal por colusión y negociación incompatible (Caso UNI). Pedido de 5 años de prisión. Registra omisión de detención por amnistía de 1970.'
);
DECLARE @IdClas INT = SCOPE_IDENTITY();

-- B. Vinculamos las VARIABLES H a esa misma clasificación
-- Variable H2 (Omisión)
DECLARE @vH2 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');
-- Variable H7-D (Amnistía)
DECLARE @vH7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7D INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='D');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas, @vH2, NULL, 'No declaró detención de los años 70 en su hoja de vida electoral.'),
(@IdClas, @vH7, @sH7D, 'Proceso de 1970 bajo condición de amnistía por persecución política.');

-- C. Registramos las FUENTES y las vinculamos a la clasificación
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Canal N','Mediática','https://canaln.pe/actualidad/fiscalia-anticorrupcion-cita-alfonso-lopez-chau-caso-uni-n490118'),
('Infobae - Caso UNI','Mediática','https://www.infobae.com/peru/2025/07/17/alfonso-lopez-chau-en-la-mira-de-la-fiscalia/'),
('Infobae - Detención 70s','Mediática','https://www.infobae.com/peru/2026/01/11/alfonso-lopez-chau-responde-a-cuestionamientos-por-su-detencion-en-los-anos-70/');

-- Nota: Si tu tabla ClasificacionFuente existiera para evitar repeticiones:
-- INSERT INTO ClasificacionFuente (IdClasificacion, IdFuente) 
-- SELECT @IdClas, IdFuente FROM FuenteInformacion WHERE LinkFuente IN (...);

GO

/* =====================================================
   REGISTRO INTEGRAL: RONALD DARWIN ATENCIO SOTOMAYOR
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'ALIANZA ELECTORAL VENCEREMOS')
    INSERT INTO Partido (NombrePartido) VALUES ('ALIANZA ELECTORAL VENCEREMOS');

DECLARE @IdP_RA INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='ALIANZA ELECTORAL VENCEREMOS');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('RONALD DARWIN ATENCIO SOTOMAYOR', '41373494', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_RA);

DECLARE @IdC_RA INT = SCOPE_IDENTITY();

-- 3. UBICACIÓN
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato)
VALUES
('Nacimiento','HUANUCO','HUANUCO','HUANUCO', @IdC_RA),
('Domicilio','LIMA','LIMA','SAN MARTIN DE PORRES', @IdC_RA);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RA, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad de San Martín de Porres','ABOGADO', 1, 2006, @IdC_RA),
('Universidad de San Martín de Porres','BACHILLER EN DERECHO Y CIENCIA POLITICA', 1, 2006, @IdC_RA);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Pontificia Universidad Católica del Perú','MAGISTER EN DERECHO PENAL','MAESTRIA', 0, 2024, @IdC_RA);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('CONGRESO DE LA REPUBLICA','ASESOR 1', 2022, 2025, @IdC_RA),
('UNIVERSIDAD PRIVADA DEL NORTE SAC','DOCENTE', 2016, 2016, @IdC_RA),
('Centro Jurídico ATHENA','GERENTE - DOCENTE', 2011, 2022, @IdC_RA);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('ALIANZA ELECTORAL VENCEREMOS','PARTIDARIO','CO PRESIDENTE', 2025, NULL, @IdC_RA),
('ALIANZA ELECTORAL VENCEREMOS','PARTIDARIO','REPRESENTANTE LEGAL', 2025, NULL, @IdC_RA);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (290119.82, 0.00, 290119.82, @IdC_RA);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
(@IdC_RA, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 1', 10770.00),
(@IdC_RA, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 2', 11880.72),
(@IdC_RA, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 3', 300.00),
(@IdC_RA, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 4', 67493.39),
(@IdC_RA, 'MUEBLE', 'REGISTRO VEHICULAR', 'Vehículo 1', 22900.00),
(@IdC_RA, 'MUEBLE', 'REGISTRO VEHICULAR', 'Vehículo 2', 181390.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RA, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, NULL, 'ronaldatenc', 115, 10.5, 144.6);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RA, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'Varios (no oficial)', NULL, NULL, NULL);

-- 9. VISITAS DE CAMPAÑA (Muestra)
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
('DISTRITO', 'SAN MARTÍN DE PORRES', @IdC_RA),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_RA),
('DISTRITO', 'PACHACÁMAC', @IdC_RA),
('DISTRITO', 'VILLA EL SALVADOR', @IdC_RA),
('PROVINCIA', 'CANCHIS', @IdC_RA),
('PROVINCIA', 'SANTA', @IdC_RA),
('PROVINCIA', 'HUARAZ', @IdC_RA),
('PROVINCIA', 'HUARAL', @IdC_RA),
('PROVINCIA', 'NAZCA', @IdC_RA),
('PROVINCIA', 'PALPA', @IdC_RA),
('PROVINCIA', 'JUNÍN', @IdC_RA),
('PROVINCIA', 'ZARUMILLA', @IdC_RA),
('PROVINCIA', 'PIURA', @IdC_RA),
('PROVINCIA', 'HUÁNUCO', @IdC_RA),
('PROVINCIA', 'SAN ROMÁN', @IdC_RA),
('PROVINCIA', 'ANDAHUAYLAS', @IdC_RA),
('PROVINCIA', 'CUSCO', @IdC_RA),
('REGION', 'CUSCO', @IdC_RA),
('REGION', 'ÁNCASH', @IdC_RA),
('REGION', 'LIMA', @IdC_RA),
('REGION', 'ICA', @IdC_RA),
('REGION', 'JUNÍN', @IdC_RA),
('REGION', 'TUMBES', @IdC_RA),
('REGION', 'PIURA', @IdC_RA),
('REGION', 'HUÁNUCO', @IdC_RA),
('REGION', 'PUNO', @IdC_RA),
('REGION', 'APURÍMAC', @IdC_RA);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N1-A)
-- Como es cuestionamiento mediático, no lleva SubSubNivel de delito penal formal (NULL)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RA, 1, 'A', NULL, 'N1-A', 
    'Cuestionamiento mediático por presunta venta ilegal de tesis mediante Centro Jurídico Athena. Empleadas confirman actividad ilegal durante su gestión como gerente.'
);
DECLARE @IdClas_RA INT = SCOPE_IDENTITY();

-- B. Variable H5 (Vinculación indirecta)
DECLARE @vH5 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H5');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_RA, @vH5, NULL, 'Vinculación con empresa Athena relacionada a presunta falsedad genérica y fraude contractual.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Infobae - Caso Tesis','Mediática','https://www.infobae.com/peru/2026/01/12/candidato-presidencial-ronald-atencio-vinculado-a-red-de-venta-ilegal-de-tesis/'),
('Infobae - Descargo Atencio','Mediática','https://www.infobae.com/peru/2026/01/13/ronald-atencio-se-desliga-de-centro-juridico-athena/');

GO

/* =====================================================
   REGISTRO INTEGRAL: CÉSAR ACUÑA PERALTA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'ALIANZA PARA EL PROGRESO')
    INSERT INTO Partido (NombrePartido) VALUES ('ALIANZA PARA EL PROGRESO');

DECLARE @IdP_CAP INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='ALIANZA PARA EL PROGRESO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('CESAR ACUÑA PERALTA', '17903382', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_CAP);

DECLARE @IdC_CAP INT = SCOPE_IDENTITY();

-- 3. UBICACIÓN
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato)
VALUES
('Nacimiento','CAJAMARCA','CHOTA','TACABAMBA', @IdC_CAP),
('Domicilio','LA LIBERTAD','TRUJILLO','VICTOR LARCO HERRERA', @IdC_CAP);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_CAP, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad Nacional de Trujillo','BACHILLER EN INGENIERIA QUIMICA', 1, NULL, @IdC_CAP),
('Universidad Nacional de Trujillo','INGENIERO QUIMICO', 1, 1995, @IdC_CAP);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad de Lima','MAGISTER EN ADMINISTRACION DE LA EDUCACION','MAESTRIA', 1, 1997, @IdC_CAP),
('Universidad de los Andes','MAGISTER EN DIRECCIÓN UNIVERSITARIA','MAESTRIA', 1, 1998, @IdC_CAP),
('Universidad Complutense de Madrid','DOCTOR POR LA UNIVERSIDAD COMPLUTENSE DE MADRID','DOCTORADO', 1, 2013, @IdC_CAP);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('UNIVERSIDAD CESAR VALLEJO','ASESOR', 2019, 2025, @IdC_CAP),
('GOBIERNO REGIONAL DE LA LIBERTAD','GOBERNADOR REGIONAL', 2023, 2025, @IdC_CAP),
('UNIVERSIDAD CESAR VALLEJO','PRESIDENTE DEL DIRECTORIO', 1999, 2019, @IdC_CAP),
('GOBIERNO REGIONAL DE LA LIBERTAD','GOBERNADOR REGIONAL', 2015, 2015, @IdC_CAP),
('MUNICIPALIDAD PROVINCIAL DE TRUJILLO','ALCALDE', 2007, 2014, @IdC_CAP);

-- 6. CARGOS PARTIDARIOS / ELECCIÓN
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('ALIANZA PARA EL PROGRESO','PARTIDARIO','DIRECCIÓN EJECUTIVA NACIONAL', 2023, NULL, @IdC_CAP),
('ALIANZA PARA EL PROGRESO','PARTIDARIO','PRESIDENTE', 2023, NULL, @IdC_CAP),
('ALIANZA PARA EL PROGRESO','ELECCION_POPULAR','GOBERNADOR REGIONAL', 2015, 2018, @IdC_CAP),
('ALIANZA PARA EL PROGRESO','ELECCION_POPULAR','GOBERNADOR REGIONAL', 2022, 2026, @IdC_CAP);

-- 7. SENTENCIAS (FAMILIA)
INSERT INTO RelacionSentencias (IdCandidato, MateriaDemanda, FalloPena)
VALUES (@IdC_CAP, 'FAMILIA / ALIMENTARIA', 'RES Nº 11 - Confirma sentencia que declara fundada en parte la demanda de alimentos.');

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (153401.00, 9683365.00, 9836766.00, @IdC_CAP);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
-- INMUEBLES
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 1', 732381.51),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 2', 719300.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 3', 1798250.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 4', 1303900.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 5', 3416675.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 6', 27513225.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 7', 3861000.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 8', 4315800.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 9', 175000.00),
(@IdC_CAP, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', 'Predio 10', 65000.00),
(@IdC_CAP, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', 'Predio 11', 302106.00),
(@IdC_CAP, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', 'Predio 12', 302106.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 13', 25000.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 14', 45642.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 15', 45870.00),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 16', 4077.30),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 17', 4679.30),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 18', 783694.88),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 19', 2692591.65),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 20', 453840.50),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 21', 1879612.50),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 22', 164599.77),
(@IdC_CAP, 'INMUEBLE', 'REGISTRO DE PREDIOS', 'Predio 23', 44016.76),
(@IdC_CAP, 'INMUEBLE', 'URBANO', 'Predio 24', 3054560.64),
(@IdC_CAP, 'INMUEBLE', 'URBANO', 'Predio 25', 4554118.98),

-- MUEBLES
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 1', 24000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 2', 2200.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 3', 16761.90),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 4', 17196.31),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 5', 32288.82),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 6', 41430.51),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 7', 16340.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 8', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 9', 43158.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 10', 89036.39),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 11', 89036.39),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 12', 109601.47),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 13', 89128.46),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 14', 89128.46),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 15', 109540.40),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 16', 89128.46),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 17', 89128.46),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 18', 109723.82),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 19', 109601.54),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 20', 109601.47),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 21', 109570.97),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 22', 89266.03),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 23', 109723.82),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 24', 109540.40),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 25', 88973.81),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 26', 109601.54),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 27', 88973.81),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 28', 109570.97),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 29', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 30', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 31', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 32', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 33', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 34', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 35', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 36', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 37', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 38', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 39', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 40', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 41', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 42', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 43', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 44', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 45', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 46', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 47', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 48', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 49', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 50', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 51', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 52', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 53', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 54', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 55', 120482.75),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 56', 22000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 57', 359650.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 58', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 59', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 60', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 61', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 62', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 63', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 64', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 65', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 66', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 67', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 68', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 69', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 70', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 71', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 72', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 73', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 74', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 75', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 76', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 77', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 78', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 79', 9000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 80', 60421.20),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 81', 258948.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 82', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 83', 100702.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 84', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 85', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 86', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 87', 100702.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 88', 100702.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 89', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 90', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 91', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 92', 60421.12),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 93', 25000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 94', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 95', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 96', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 97', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 98', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 99', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 100', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 101', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 102', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 103', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 104', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 105', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 106', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 107', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 108', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 109', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 110', 30000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 111', 160000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 112', 96000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 113', 143860.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 114', 420071.20),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 115', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 116', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 117', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 118', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 119', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 120', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 121', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 122', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 123', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 124', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 125', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 126', 10000.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 127', 211142.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 128', 996300.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 129', 526857.50),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 130', 199851.50),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 131', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 132', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 133', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 134', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 135', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 136', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 137', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 138', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 139', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 140', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 141', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 142', 145946.60),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 143', 1088255.00),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 144', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 145', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 146', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 147', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 148', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 149', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 150', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 151', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 152', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 153', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 154', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 155', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 156', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 157', 140533.80),
(@IdC_CAP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 'Vehículo 158', 89266.03);

-- 9. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_CAP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'cesaracunap', 430, 452.5, 6300);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_CAP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'peru_app', 1.35, 12.7);

-- 10. VISITAS
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO','VILLA MARÍA DEL TRIUNFO', @IdC_CAP), 
('DISTRITO','ATE', @IdC_CAP), 
('DISTRITO', 'COMAS', @IdC_CAP),
('DISTRITO', 'LOS OLIVOS', @IdC_CAP),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_CAP),
('DISTRITO', 'CHORRILLOS', @IdC_CAP),
('PROVINCIA', 'TRUJILLO', @IdC_CAP),
('PROVINCIA', 'BARRANCA', @IdC_CAP),
('PROVINCIA', 'CALLAO', @IdC_CAP),
('PROVINCIA', 'SANTA', @IdC_CAP),
('PROVINCIA', 'JAÉN', @IdC_CAP),
('PROVINCIA', 'HUALLAGA', @IdC_CAP),
('PROVINCIA', 'MOYOBAMBA', @IdC_CAP),
('PROVINCIA', 'SAN MARTÍN', @IdC_CAP),
('PROVINCIA', 'AREQUIPA', @IdC_CAP),
('PROVINCIA', 'ALTO AMAZONAS', @IdC_CAP),
('PROVINCIA', 'TACNA', @IdC_CAP),
('PROVINCIA', 'MAYNAS', @IdC_CAP),
('PROVINCIA', 'CHOTA', @IdC_CAP),
('PROVINCIA', 'LORETO', @IdC_CAP),
('PROVINCIA', 'PIURA', @IdC_CAP),
('PROVINCIA', 'HUANCABAMBA', @IdC_CAP),
('PROVINCIA', 'CHICLAYO', @IdC_CAP),
('REGION', 'LIMA', @IdC_CAP),
('REGION', 'ÁNCASH', @IdC_CAP),
('REGION', 'CAJAMARCA', @IdC_CAP),
('REGION', 'SAN MARTÍN', @IdC_CAP),
('REGION', 'AREQUIPA', @IdC_CAP),
('REGION', 'LORETO', @IdC_CAP),
('REGION', 'TACNA', @IdC_CAP),
('REGION', 'CAJAMARCA', @IdC_CAP),
('REGION', 'PIURA', @IdC_CAP),
('REGION','LAMBAYEQUE', @IdC_CAP);

-- A. Clasificación Principal (N3-COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_CAP, 3, 'COR', 'N3-COR', 
    'Investigación fiscal por presunta colusión, negociación incompatible y enriquecimiento ilícito (Caso Rolex y Joyas). Múltiples investigaciones en gestión de La Libertad.'
);
DECLARE @IdClas_CAP INT = SCOPE_IDENTITY();

-- B. Variables Secundarias (H1 y H3)
DECLARE @vH1 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H1');
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_CAP, @vH1, NULL, 'Reporte de millonarios préstamos personales al partido APP (S/19.7 millones).'),
(@IdClas_CAP, @vH3, NULL, 'Investigación del JEE por presunta vulneración del principio de neutralidad electoral.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Diario Correo','Mediática','https://diariocorreo.pe/edicion/la-libertad/fiscalia-tiene-en-la-mira-a-la-gestion-de-cesar-acuna/'),
('LP Derecho - Publicidad','Jurídica','https://lpderecho.pe/fiscalia-inicia-investigacion-preliminar-contra-cesar-acuna/'),
('Expreso - Rolex','Mediática','https://www.expreso.com.pe/judicial/cesar-acuna-bajo-lupa-fiscal-por-lujosas-joyas-y-reloj-rolex/'),
('La República - ONPE','Mediática','https://larepublica.pe/politica/2025/12/08/cesar-acuna-justifica-prestamo-de-20-millones-a-app/');

GO


/* =====================================================
   REGISTRO INTEGRAL: JOSÉ DANIEL WILLIAMS ZAPATA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'AVANZA PAIS - PARTIDO DE INTEGRACION SOCIAL')
    INSERT INTO Partido (NombrePartido) VALUES ('AVANZA PAIS - PARTIDO DE INTEGRACION SOCIAL');

DECLARE @IdP_JW INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='AVANZA PAIS - PARTIDO DE INTEGRACION SOCIAL');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('JOSE DANIEL WILLIAMS ZAPATA', '43287528', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_JW);

DECLARE @IdC_JW INT = SCOPE_IDENTITY();

-- 3. UBICACIÓN
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato)
VALUES
('Nacimiento','LIMA','LIMA','LIMA', @IdC_JW),
('Domicilio','LIMA','LIMA','SAN BORJA', @IdC_JW);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_JW, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Escuela Militar de Chorrillos','BACHILLER EN CIENCIAS MILITARES', 1, 2009, @IdC_JW),
('Escuela Militar de Chorrillos','LICENCIADO EN CIENCIAS MILITARES', 1, 2009, @IdC_JW);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('CAEN','MAGISTER EN DESARROLLO Y DEFENSA NACIONAL','MAESTRIA', 1, 2011, @IdC_JW),
('INSTITUTO DE GOBIERNO USMP','DOCTORADO GOBIERNO Y POLÍTICA PÚBLICA','DOCTORADO', 0, NULL, @IdC_JW);

-- 5. EXPERIENCIA LABORAL Y CARGOS
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('CONGRESO DE LA REPUBLICA','CONGRESISTA', 2021, 2025, @IdC_JW);

INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('AVANZA PAIS','ELECCION_POPULAR','CONGRESISTA', 2021, 2025, @IdC_JW);

-- 6. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (351600.00, 0.00, 351600.00, @IdC_JW);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
(@IdC_JW, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 27968.17),
(@IdC_JW, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 75000.00),
(@IdC_JW, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 9000.00),
(@IdC_JW, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 7000.00),
(@IdC_JW, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 30000.00),
(@IdC_JW, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 8750.00);
-- 7. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_JW, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'josewilliamszapata', 125, 6.13, 58.8);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_JW, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'No tiene según página web');

-- 8. VISITAS (Resumen)
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'JESÚS MARÍA', @IdC_JW),
('DISTRITO', 'PUEBLO LIBRE', @IdC_JW),
('DISTRITO', 'INDEPENDENCIA', @IdC_JW),
('DISTRITO', 'LA VICTORIA', @IdC_JW),
('PROVINCIA', 'PISCO', @IdC_JW),
('PROVINCIA', 'ICA', @IdC_JW),
('PROVINCIA', 'CALLAO', @IdC_JW),
('PROVINCIA', 'TRUJILLO', @IdC_JW),
('PROVINCIA', 'LAMBAYEQUE', @IdC_JW),
('PROVINCIA', 'PIURA', @IdC_JW),
('PROVINCIA', 'TALARA', @IdC_JW),
('PROVINCIA', 'TACNA', @IdC_JW),
('PROVINCIA', 'TUMBES', @IdC_JW),
('REGION', 'MADRE DE DIOS', @IdC_JW),
('REGION', 'ICA', @IdC_JW),
('REGION', 'LA LIBERTAD', @IdC_JW),
('REGION', 'LAMBAYEQUE', @IdC_JW),
('REGION', 'PIURA', @IdC_JW),
('REGION', 'TACNA', @IdC_JW),
('REGION', 'TUMBES', @IdC_JW),
('REGION', 'LIMA', @IdC_JW);


-- 9. CLASIFICACIÓN LEGAL Y VARIABLES H
-- A. Clasificación Principal (N0-B)
-- No se asigna SubSubNivel ya que no hay delito confirmado
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_JW, 0, 'B', NULL, 'N0-B', 
    'JEE archivó pedido de exclusión. Se confirmó que no registra sentencias condenatorias; el reporte inicial de homicidio calificado fue un error administrativo de registro.'
);
DECLARE @IdClas_JW INT = SCOPE_IDENTITY();

-- B. Variable Secundaria H7-B (Archivado sin responsabilidad)
DECLARE @vH7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7B INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='B');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_JW, @vH7, @sH7B, 'Proceso por caso Chavín de Huántar archivado. No se estableció responsabilidad penal.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES ('Radio Exitosa','Mediática','https://www.exitosanoticias.pe/politica/jose-williams-jee-archiva-pedido-exclusion-confirma-tiene-sentencias-n169120');

GO

/* =====================================================
   REGISTRO INTEGRAL: ALVARO GONZALO PAZ DE LA BARRA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'FE EN EL PERU')
    INSERT INTO Partido (NombrePartido) VALUES ('FE EN EL PERU');

DECLARE @IdP_APB INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='FE EN EL PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ALVARO GONZALO PAZ DE LA BARRA FREIGEIRO', '41904418', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_APB);

DECLARE @IdC_APB INT = SCOPE_IDENTITY();

-- 3. UBICACIÓN
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato)
VALUES
('Nacimiento','LIMA','LIMA','MIRAFLORES', @IdC_APB),
('Domicilio','LIMA','LIMA','LA MOLINA', @IdC_APB);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_APB, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad de San Martín de Porres','BACHILLER EN DERECHO', 1, 2007, @IdC_APB),
('Universidad de San Martín de Porres','ABOGADO', 1, 2008, @IdC_APB);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('EUCIM BUSINESS SCHOOL','MAGISTER EN GESTIÓN PÚBLICA','MAESTRIA', 1, 2023, @IdC_APB),
('UNMSM','DERECHO CONSTITUCIONAL Y DD.HH.','MAESTRIA', 0, NULL, @IdC_APB);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('Municipalidad Distrital Rimac', 'GERENTE MUNICIPAL', 2023, 2023, @IdC_APB),
('Municipalidad Distrital La Molina', 'ALCALDE', 2019, 2022, @IdC_APB),
('Asociacion de Municpalidades del Perú - AMPE', 'PRESIDENTE', 2019, 2022, @IdC_APB),
('PBF Abogados SAC', 'GERENTE GENERAL', 2015, 2018, @IdC_APB),
('PAZ DE LA BARRA ABOGADOS SAC', 'SOCIO FUNDADOR', 2012, 2018, @IdC_APB);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('FE EN EL PERU','PARTIDARIO','FUNDADOR', 2021, NULL, @IdC_APB);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 341465.00, 341465.00, @IdC_APB);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.00),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 40762.63),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 18592.32),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 86514.78),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 92667.51),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 17484.28),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 18421.32),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 135037.56),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 23433.98),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 109716.07),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.01),
(@IdC_APB, 'INMUEBLE', NULL, NULL, 300430.42),
(@IdC_APB, 'INMUEBLE', NULL, NULL, 118522.08),

-- MUEBLES
(@IdC_APB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 60000.00),
(@IdC_APB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 80000.00),
(@IdC_APB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 76000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_APB, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'alvaropazdlabarraoficial', 66, 10.1, 72);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_APB, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'Varios (no oficial)');

-- 9. VISITAS
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITO
('DISTRITO', 'CARABAYLLO', @IdC_APB),

-- PROVINCIAS
('PROVINCIA', 'TRUJILLO', @IdC_APB),
('PROVINCIA', 'PACASMAYO', @IdC_APB),
('PROVINCIA', 'ASCOPE', @IdC_APB),
('PROVINCIA', 'SANTA', @IdC_APB),
('PROVINCIA', 'LA CONVENCIÓN', @IdC_APB),

-- REGIONES
('REGION', 'LA LIBERTAD', @IdC_APB),
('REGION', 'ÁNCASH', @IdC_APB),
('REGION', 'CUSCO', @IdC_APB),
('REGION', 'LIMA', @IdC_APB);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N0-B)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_APB, 0, 'B', NULL, 'N0-B', 
    'Sin información penal o administrativa relevante. Perfil enfocado en gestión municipal y litigio constitucional estratégico.'
);
DECLARE @IdClas_APB INT = SCOPE_IDENTITY();

-- B. Variable H8-A (Litigio Constitucional)
DECLARE @vH8 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H8');
DECLARE @sH8A INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH8 AND Codigo='A');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_APB, @vH8, @sH8A, 'Acción de amparo contra PCM y MINSA por importación de vacunas COVID-19 (Exp. 00680-2021-0-3204).');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('MistiPress','Mediática','https://arequipamistipress.com/2021/03/10/por-que-razones-juez-admitio-accion-de-amparo-para-importar-vacunas/'),
('LP Derecho','Jurídica','https://lpderecho.pe/interponen-amparo-privados-gobiernos-locales-regionales-puedan-comprar-vacuna-contra-covid/');

GO

/* =====================================================
   REGISTRO INTEGRAL: KEIKO SOFÍA FUJIMORI HIGUCHI
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'FUERZA POPULAR')
    INSERT INTO Partido (NombrePartido) VALUES ('FUERZA POPULAR');

DECLARE @IdP_K INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='FUERZA POPULAR');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('KEIKO SOFIA FUJIMORI HIGUCHI', '10001088', 'Femenino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_K);

DECLARE @IdC_K INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','JESUS MARIA', @IdC_K),
('Domicilio','LIMA','LIMA','SAN BORJA', @IdC_K);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_K, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('BOSTON UNIVERSITY','LICENCIADA EN ADMINISTRACIÓN DE EMPRESAS', 1, 2025, @IdC_K);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('COLUMBIA UNIVERSITY','MÁSTER EN ADMINISTRACIÓN DE EMPRESAS','MAESTRIA', 1, 2024, @IdC_K);

-- 5. EXPERIENCIA Y CARGOS
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('Partido Político Fuerza Popular','PRESIDENTA', 2013, 2025, @IdC_K);

INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('FUERZA POPULAR','PARTIDARIO','FUNDADOR', 2009, NULL, @IdC_K),
('FUERZA POPULAR','PARTIDARIO','PRESIDENTA', 2024, NULL, @IdC_K),
('ALIANZA POR EL FUTURO','ELECCION_POPULAR','CONGRESISTA', 2006, 2011, @IdC_K);

-- 6. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 271853.45, 271853.45, @IdC_K);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES (@IdC_K, 'MUEBLE', 'PROPIEDAD VEHICULAR', NULL, 115998.00);

-- 7. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_K, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'keikofujimorih', 19, 1100, 10300);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_K, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'fuerzapopular_', 28.2, 271.9);

-- 8. VISITAS (Muestra de principales)
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_K),
('DISTRITO', 'ATE', @IdC_K),
('PROVINCIA', 'CHINCHA', @IdC_K),
('PROVINCIA', 'HUAURA', @IdC_K),
('PROVINCIA', 'CHICLAYO', @IdC_K),
('PROVINCIA', 'CASMA', @IdC_K),
('PROVINCIA', 'HUARMEY', @IdC_K),
('PROVINCIA', 'SANTA', @IdC_K),
('PROVINCIA', 'ZARUMILLA', @IdC_K),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_K),
('PROVINCIA', 'CALLAO', @IdC_K),
('REGION', 'ICA', @IdC_K),
('REGION', 'LIMA', @IdC_K),
('REGION', 'LAMBAYEQUE', @IdC_K),
('REGION', 'ÁNCASH', @IdC_K),
('REGION', 'TUMBES', @IdC_K),
('REGION', 'LORETO', @IdC_K);

--9. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N3-COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_K, 3, 'COR', 'N3-COR', 
    'Investigación fiscal por presunta recaudación ilícita y financiamiento de campaña 2021. Múltiples investigaciones fiscales abiertas por delitos de corrupción.'
);
DECLARE @IdClas_K INT = SCOPE_IDENTITY();

-- B. Variable Secundaria H7-A (Caso archivado por TC)
DECLARE @vH7_K INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7A_K INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7_K AND Codigo='A');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_K, @vH7_K, @sH7A_K, 'Archivo definitivo del Caso Cócteles en cumplimiento de la sentencia del Tribunal Constitucional (Exp. 00299-2017).');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('La República','Mediática','https://larepublica.pe/politica/2025/12/21/cuatro-candidatos-cuentan-con-la-mayor-cantidad-de-investigaciones-fiscales/'),
('LP Derecho - Investigación 2021','Jurídica','https://lpderecho.pe/fiscalia-investiga-keiko-fujimori-presunta-recaudacion-ilicita-campana-electoral-2021/'),
('LP Derecho - Archivo Cócteles','Jurídica','https://lpderecho.pe/juzgado-ordena-el-archivo-definitivo-del-caso-cocteles/');

GO


/* =====================================================
   REGISTRO INTEGRAL: FIORELLA GIANNINA MOLINELLI ARISTONDO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'FUERZA Y LIBERTAD') 
    INSERT INTO Partido (NombrePartido) VALUES ('FUERZA Y LIBERTAD');

DECLARE @IdP_FM INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='FUERZA Y LIBERTAD');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('FIORELLA GIANNINA MOLINELLI ARISTONDO', '25681995', 'Femenino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_FM);

DECLARE @IdC_FM INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','SAN ISIDRO', @IdC_FM),
('Domicilio','LIMA','LIMA','LA MOLINA', @IdC_FM);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_FM, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Pontificia Universidad Católica del Perú','BACHILLER EN CIENCIAS SOCIALES CON MENCION EN ECONOMIA', 1, NULL, @IdC_FM),
('Pontificia Universidad Católica del Perú','LICENCIADO EN ECONOMÍA', 1, 2008, @IdC_FM);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad de San Martín de Porres','DOCTORA EN GOBIERNO Y POLITICA PUBLICA','DOCTORADO', 1, 2012, @IdC_FM),
('UNIVERSIDAD ALCALA DE HENARES','DIRECCIÓN Y GESTIÓN DE SERVICIOS DE SALUD','MAESTRIA', 1, 2022, @IdC_FM),
('UNIVERSIDAD TORCUATO DI TELLA','ECONOMIA Y POLÍTICAS PÚBLICAS','MAESTRIA', 1, 1998, @IdC_FM);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('UNIVERSIDAD CONTINENTAL','DOCENTE', 2024, 2025, @IdC_FM),
('MINISTERIO DE DEFENSA','DOCENCIA CAEN', 2024, 2024, @IdC_FM),
('SEGURO SOCIAL DE SALUD','PRESIDENTE EJECUTIVO', 2018, 2021, @IdC_FM),
('UNIVERSIDAD SEÑOR DE SIPAN S.A.C.','DECANA (E) DE LA FACULTAD DE CIENCIAS EMPRESARIALES / ASESORA DEL CONSEJO DIRECTIVO',2021,2022,@IdC_FM),
('MINISTERIO DE DESARROLLO E INCLUSION SOCIAL','MINISTRA', 2017, 2018, @IdC_FM);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('FUERZA Y LIBERTAD','PARTIDARIO','PRESIDENTE', 2025, NULL, @IdC_FM),
('PARTIDO POLITICO FUERZA MODERNA','PARTIDARIO','FUNDADOR', 2023, NULL, @IdC_FM);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (8320.00, 115545.13, 123865.13, @IdC_FM);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_FM, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 5127.96),
(@IdC_FM, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 134640.32);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_FM, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'fiorellamolinelli', 234, 42.3, 267.4);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_FM, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'fuerzaylibertadperu', 1.201, 12.6);

-- 9. VISITAS DE CAMPAÑA 
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'PACHACÁMAC', @IdC_FM),
('DISTRITO', 'VILLA MARÍA DEL TRIUNFO', @IdC_FM),
('PROVINCIA', 'ESPINAR', @IdC_FM),
('PROVINCIA', 'CUSCO', @IdC_FM),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_FM),
('PROVINCIA', 'PIURA', @IdC_FM),
('PROVINCIA', 'MAYNAS', @IdC_FM),
('PROVINCIA', 'JUNÍN', @IdC_FM),
('PROVINCIA', 'JAUJA', @IdC_FM),
('PROVINCIA', 'HUANCAYO', @IdC_FM),
('PROVINCIA', 'PISCO', @IdC_FM),
('PROVINCIA', 'ICA', @IdC_FM),
('PROVINCIA', 'ANTA', @IdC_FM),
('PROVINCIA', 'AREQUIPA', @IdC_FM),
('REGION', 'CUSCO', @IdC_FM),
('REGION', 'UCAYALI', @IdC_FM),
('REGION', 'PIURA', @IdC_FM),
('REGION', 'LORETO', @IdC_FM),
('REGION', 'JUNÍN', @IdC_FM),
('REGION', 'ICA', @IdC_FM),
('REGION', 'AREQUIPA', @IdC_FM),
('REGION', 'LIMA', @IdC_FM);

/* =====================================================
   10. CLASIFICACIÓN LEGAL Y VARIABLES H
===================================================== */

-- A. Clasificación Principal (N3-COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_FM, 3, 'COR', 'N3-COR', 
    'Investigación fiscal abierta por presunta organización criminal y colusión agravada en contrataciones de EsSalud durante emergencia COVID-19 (Caso Club de las Farmacéuticas).'
);
DECLARE @IdClas_FM INT = SCOPE_IDENTITY();

-- B. Variable H9-A (Impedimento de salida)
DECLARE @vH9 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H9');
DECLARE @sH9A INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH9 AND Codigo='A');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_FM, @vH9, @sH9A, 'Medida judicial de impedimento de salida del país vigente por 12 meses dictada en el marco de la investigación por colusión agravada.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Ministerio Público - Gob.pe','Oficial','https://www.gob.pe/institucion/mpfn/noticias/582313-ministerio-publico-logro-impedimento-de-salida-del-pais-por-12-meses/'),
('Canal N - Reportaje','Mediática','https://www.youtube.com/watch?v=_ZFBknMqo-Q');

GO


/* =====================================================
   REGISTRO INTEGRAL: ROBERTO HELBERT SANCHEZ PALOMINO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'JUNTOS POR EL PERU') 
    INSERT INTO Partido (NombrePartido) VALUES ('JUNTOS POR EL PERU');

DECLARE @IdP_RSP INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='JUNTOS POR EL PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ROBERTO HELBERT SANCHEZ PALOMINO', '16002918', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, DIPUTADO', @IdP_RSP);

DECLARE @IdC_RSP INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','HUARAL','HUARAL', @IdC_RSP),
('Domicilio','LIMA','LIMA','SAN BORJA', @IdC_RSP);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RSP, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('UNMSM','BACHILLER EN PSICOLOGIA', 1, 1998, @IdC_RSP),
('UNMSM','PSICOLOGO', 1, 2000, @IdC_RSP);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('PUCP','MAESTRIA DE POLITICAS SOCIALES','MAESTRIA', 1, NULL, @IdC_RSP);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('CONGRESO DE LA REPÚBLICA', 'CONGRESISTA', 2021, 2025, @IdC_RSP),
('MINISTERIO DE COMERCIO EXTERIOR Y TURISMO - MINCETUR', 'MINISTRO', 2021, 2022, @IdC_RSP),
('MUNICIPALIDAD PROVINCIAL DE HUARAL', 'GERENTE DE DESARROLLO SOCIAL', 2020, 2020, @IdC_RSP),
('MUNICIPALIDAD DISTRITAL DE SAN BORJA', 'GERENTE DE LA CAPITAL HUMANO', 2019, 2020, @IdC_RSP),
('MUNICIPALIDAD PROVINCIAL DE HUAURA - HUACHO', 'GERENTE DE ADMINISTRACIÓN Y FINANZAS', 2017, 2017, @IdC_RSP);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('JUNTOS POR EL PERU','PARTIDARIO','REPRESENTANTE LEGAL', 2024, NULL, @IdC_RSP),
('JUNTOS POR EL PERU','PARTIDARIO','APODERADO',2024,NULL,@IdC_RSP),
('JUNTOS POR EL PERU','ELECCION_POPULAR','CONGRESISTA', 2021, 2025, @IdC_RSP);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (224945.83, 0.00, 224945.83, @IdC_RSP);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES (@IdC_RSP, 'INMUEBLE', 'PREDIO RURAL', 'Propiedad Huaral', 35000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RSP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'roberto.snchez.pa', 267, 27.3, 318.7);
INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RSP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'juntosporelperu',3.469,47.3);

-- 9. VISITAS (Resumen)
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'CERCADO DE LIMA', @IdC_RSP),
('DISTRITO', 'LURIGANCHO-CHOSICA', @IdC_RSP),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_RSP),
('PROVINCIA', 'CHUCUITO', @IdC_RSP),
('PROVINCIA', 'CUSCO', @IdC_RSP),
('PROVINCIA', 'COTABAMBAS', @IdC_RSP),
('PROVINCIA', 'PUNO', @IdC_RSP),
('PROVINCIA', 'CAYLLOMA', @IdC_RSP),
('PROVINCIA', 'CARAVELÍ', @IdC_RSP),
('PROVINCIA', 'ESPINAR', @IdC_RSP),
('PROVINCIA', 'ACOMAYO', @IdC_RSP),
('PROVINCIA', 'CHOTA', @IdC_RSP),
('PROVINCIA', 'SAN ROMÁN', @IdC_RSP),
('PROVINCIA', 'HUANCAVELICA', @IdC_RSP),
('PROVINCIA', 'JUNÍN', @IdC_RSP),
('PROVINCIA', 'CHANCHAMAYO', @IdC_RSP),
('PROVINCIA', 'HUAMANGA', @IdC_RSP),
('PROVINCIA', 'HUARMEY', @IdC_RSP),
('PROVINCIA', 'VIRÚ', @IdC_RSP),
('PROVINCIA', 'TUMBES', @IdC_RSP),
('PROVINCIA', 'PIURA', @IdC_RSP),
('PROVINCIA', 'CHUMBIVILCAS', @IdC_RSP),
('REGION', 'PUNO', @IdC_RSP),
('REGION', 'CUSCO', @IdC_RSP),
('REGION', 'APURÍMAC', @IdC_RSP),
('REGION', 'AREQUIPA', @IdC_RSP),
('REGION', 'CAJAMARCA', @IdC_RSP),
('REGION', 'HUANCAVELICA', @IdC_RSP),
('REGION', 'JUNÍN', @IdC_RSP),
('REGION', 'AYACUCHO', @IdC_RSP),
('REGION', 'ÁNCASH', @IdC_RSP),
('REGION', 'LA LIBERTAD', @IdC_RSP),
('REGION', 'TUMBES', @IdC_RSP),
('REGION', 'PIURA', @IdC_RSP),
('REGION', 'LIMA', @IdC_RSP);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N3-ADM)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RSP, 3, 'ADM', 'N3-ADM', 
    'Investigación fiscal por presuntos delitos contra la administración pública (negociación incompatible y tráfico de influencias). Acusaciones de mochasueldos.'
);
DECLARE @IdClas_RSP INT = SCOPE_IDENTITY();

-- B. Variables Secundarias (H3 y H7-C)
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');
DECLARE @vH7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7C INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='C');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_RSP, @vH3, NULL, 'Informe de fiscalización del JEE concluye presunta vulneración al principio de neutralidad electoral.'),
(@IdClas_RSP, @vH7, @sH7C, 'Corte Suprema excluyó al candidato del juicio por el caso del 7 de diciembre (Golpe de Estado), archivando dicho proceso específico.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('El Comercio','Mediática','https://elcomercio.pe/politica/elecciones/informe-de-fiscalizacion-concluye-que-roberto-sanchez-habria-infringido-el-principio-de-neutralidad/'),
('Infobae','Mediática','https://www.infobae.com/peru/2024/08/12/roberto-sanchez-investigado-por-corrupcion-acusado-de-mochasueldos/'),
('Expreso - Judicial','Jurídica','https://www.expreso.com.pe/judicial/corte-suprema-excluye-a-roberto-sanchez-del-juicio-por-golpe-de-estado/');

GO


/* =====================================================
   REGISTRO INTEGRAL: RAFAEL JORGE BELAUNDE LLOSA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'LIBERTAD POPULAR') 
    INSERT INTO Partido (NombrePartido) VALUES ('LIBERTAD POPULAR');

DECLARE @IdP_RBL INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='LIBERTAD POPULAR');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('RAFAEL JORGE BELAUNDE LLOSA', '10219647', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_RBL);

DECLARE @IdC_RBL INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','MIRAFLORES', @IdC_RBL),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_RBL);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RBL, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad de Lima','BACHILLER EN ECONOMIA', 1, NULL, @IdC_RBL);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('INMOBILIARIA FERYMAR SAC','GERENTE GENERAL', 2020, 2025, @IdC_RBL),
('MINISTERIO DE ENERGIA Y MINAS','MINISTRO', 2020, 2020, @IdC_RBL),
('REMEDIADORA AMBIENTAL SAC','GERENTE GENERAL', 2015, 2020, @IdC_RBL);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('LIBERTAD POPULAR','PARTIDARIO','FUNDADOR', 2022, NULL, @IdC_RBL),
('LIBERTAD POPULAR','PARTIDARIO','PRESIDENTE', 2022, NULL, @IdC_RBL);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 2134800.00, 2134800.00, @IdC_RBL);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_RBL, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 205800.00),
(@IdC_RBL, 'INMUEBLE', 'PREDIOS RURALES', NULL, 266940.99),
(@IdC_RBL, 'INMUEBLE','PREDIOS RURALES',NULL,21410.00),
(@IdC_RBL, 'MUEBLE', 'PROPIEDAD VEHICULAR', NULL, 269600.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RBL, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'rafael.belaundeperu', 197, 56.3, 187.5);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RBL, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'libertadpopularpe', 2.452, 26.6);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_RBL),
('DISTRITO', 'INDEPENDENCIA', @IdC_RBL),
('PROVINCIA', 'HUÁNUCO', @IdC_RBL),
('PROVINCIA', 'CHINCHA', @IdC_RBL),
('PROVINCIA', 'SAN MARTÍN', @IdC_RBL),
('PROVINCIA', 'LEONCIO PRADO', @IdC_RBL),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_RBL),
('PROVINCIA', 'CAJAMARCA', @IdC_RBL),
('PROVINCIA', 'CHOTA', @IdC_RBL),
('PROVINCIA', 'CONTUMAZÁ', @IdC_RBL),
('PROVINCIA', 'CANCHIS', @IdC_RBL),
('PROVINCIA', 'CUSCO', @IdC_RBL),
('PROVINCIA', 'ESPINAR', @IdC_RBL),
('PROVINCIA', 'CALCA', @IdC_RBL),
('PROVINCIA', 'SAN ROMÁN', @IdC_RBL),
('PROVINCIA', 'TUMBES', @IdC_RBL),
('REGION', 'HUÁNUCO', @IdC_RBL),
('REGION', 'ICA', @IdC_RBL),
('REGION', 'SAN MARTÍN', @IdC_RBL),
('REGION', 'UCAYALI', @IdC_RBL),
('REGION', 'CAJAMARCA', @IdC_RBL),
('REGION', 'CUSCO', @IdC_RBL),
('REGION', 'PUNO', @IdC_RBL),
('REGION', 'LIMA', @IdC_RBL),
('REGION', 'TUMBES', @IdC_RBL);

--10. CLASIFICACIÓN LEGAL Y FUENTES

-- A. Clasificación Principal (N0-B)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RBL, 0, 'B', 'N0-B', 
    'Sin contenido legal relevante. Registra críticas mediáticas por desconocimiento de indicadores económicos y costo de vida, sin implicancias en el ámbito penal o administrativo.'
);

-- B. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES ('Radio Exitosa','Mediática','https://www.exitosanoticias.pe/politica/candidato-presidencia-disculpa-desconocer-precio-pasaje-metropolitano-kilo-azucar-sueldo-minimo-n146156');

GO

/* =====================================================
   REGISTRO INTEGRAL: PITTER ENRIQUE VALDERRAMA PEÑA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO APRISTA PERUANO') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO APRISTA PERUANO');

DECLARE @IdP_EVP INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO APRISTA PERUANO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('PITTER ENRIQUE VALDERRAMA PEÑA', '43632186', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_EVP);

DECLARE @IdC_EVP INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_EVP),
('Domicilio','LIMA','LIMA','LIMA', @IdC_EVP);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_EVP, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad de San Martín de Porres','BACHILLER EN DERECHO', 1, 2022, @IdC_EVP);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad de la Rioja','MAESTRIA','MAESTRIA', 0, NULL, @IdC_EVP);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('GLOBAL SECURITY LAW S.A.C','ANALISTA LEGAL', 2023, 2025, @IdC_EVP),
('CONTRATISTAS GENERALES SAALINO S.A.C.','SUB GERENTE',2015,2019,@IdC_EVP),
('PS INNOVA SAC','SUB GERENTE', 2018, 2023, @IdC_EVP);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO APRISTA PERUANO','PARTIDARIO','MIEMBRO DE LA COMISIÓN POLÍTICA', 2025, NULL, @IdC_EVP),
('PARTIDO APRISTA PERUANO','PARTIDARIO','FUNDADOR', 2022, NULL, @IdC_EVP);


-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 33600.00, 33600.00, @IdC_EVP);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_EVP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'kike.valderrama.pe', 248, 4.573, 36.9);
INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_EVP, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'No tiene según página web');
-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'BREÑA', @IdC_EVP),
('PROVINCIA', 'PUNO', @IdC_EVP),
('PROVINCIA', 'HUAMANGA', @IdC_EVP),
('PROVINCIA', 'CUSCO', @IdC_EVP),
('PROVINCIA', 'LA CONVENCIÓN', @IdC_EVP),
('PROVINCIA', 'TRUJILLO', @IdC_EVP),
('PROVINCIA', 'SANTA', @IdC_EVP),
('PROVINCIA', 'TUMBES', @IdC_EVP),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_EVP),
('PROVINCIA', 'CALLAO', @IdC_EVP),
('PROVINCIA', 'CHICLAYO', @IdC_EVP),
('PROVINCIA', 'ASCOPE', @IdC_EVP),
('PROVINCIA', 'SANTIAGO DE CHUCO', @IdC_EVP),
('PROVINCIA', 'VIRÚ', @IdC_EVP),
('PROVINCIA', 'AREQUIPA', @IdC_EVP),
('PROVINCIA', 'SECHURA', @IdC_EVP),
('PROVINCIA', 'MORROPÓN', @IdC_EVP),
('REGION', 'PUNO', @IdC_EVP),
('REGION', 'AYACUCHO', @IdC_EVP),
('REGION', 'CUSCO', @IdC_EVP),
('REGION', 'LA LIBERTAD', @IdC_EVP),
('REGION', 'ÁNCASH', @IdC_EVP),
('REGION', 'TUMBES', @IdC_EVP),
('REGION', 'UCAYALI', @IdC_EVP),
('REGION', 'LAMBAYEQUE', @IdC_EVP),
('REGION', 'AREQUIPA', @IdC_EVP),
('REGION', 'PIURA', @IdC_EVP),
('REGION', 'LIMA', @IdC_EVP);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N1-A2)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_EVP, 1, 'A', 2, 'N1-A2', 
    'Registra un señalamiento en parte policial (2012) por presunto hurto, basado en sospechas de un tercero. No existen antecedentes penales, ni judiciales, ni investigación fiscal derivada de este hecho.'
);
DECLARE @IdClas_EVP INT = SCOPE_IDENTITY();

-- B. Variable H7-B (Registro policial sin investigación)
DECLARE @vH7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7B INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='B');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES (@IdClas_EVP, @vH7, @sH7B, 'Parte policial del 2012 en Comisaría de San Borja; el caso nunca fue judicializado ni derivó en denuncia fiscal.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES ('Diario La República','Mediática','https://larepublica.pe/politica/2025/12/01/enrique-valderrama-candidato-del-apra-fue-acusado-en-el-hurto-de-una-laptop-y-un-televisor-en-el-2012/');

GO

/* =====================================================
   REGISTRO INTEGRAL: RICARDO PABLO BELMONT CASSINELLI
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO CIVICO OBRAS') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO CIVICO OBRAS');

DECLARE @IdP_RBC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO CIVICO OBRAS');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('RICARDO PABLO BELMONT CASSINELLI', '09177250', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_RBC);

DECLARE @IdC_RBC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_RBC),
('Domicilio','LIMA','LIMA','CHORRILLOS', @IdC_RBC);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RBC, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UNIVERSIDAD DE LIMA','BACHILLER ADMINISTRACION DE EMPRESAS', 1, 1977, @IdC_RBC);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('RED BICOLOR DE COMUNICACIONES S.A.A','EMPRESARIO', 1986, 2025, @IdC_RBC);

-- 6. CARGOS PARTIDARIOS / ELECCIÓN
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO CIVICO OBRAS','PARTIDARIO','FUNDADOR', 2022, NULL, @IdC_RBC),
('PARTIDO CIVICO OBRAS','ELECCION_POPULAR','ALCALDE PROVINCIAL', 1990, 1995, @IdC_RBC),
('PARTIDO CIVICO OBRAS','PARTIDARIO','PRESIDENTE',2022,NULL,@IdC_RBC),
('ALIANZA FRENTE DE CENTRO','ELECCION_POPULAR','CONGRESISTA', 2009, 2011, @IdC_RBC);

-- 7. INGRESOS
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 301514.00, 301514.00, @IdC_RBC);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RBC, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'ricardobelmontc', 322, 118.5, 1300);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RBC, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'partidocivicoobras',6.369,83.8);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'CERCADO DE LIMA', @IdC_RBC),
('PROVINCIA', 'SAN ROMÁN', @IdC_RBC),
('PROVINCIA', 'PUNO', @IdC_RBC),
('REGION', 'CAJAMARCA', @IdC_RBC),
('REGION', 'PUNO', @IdC_RBC);

--10. CLASIFICACIÓN LEGAL Y SENTENCIAS 

-- A. Clasificación Principal (N5-DO)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RBC, 5, 'DO', NULL, 'N5-DO', 
    'Registra condena penal firme por Difamación Agravada (Delito doloso). Pena de 1 año de libertad suspendida y reparación civil de S/ 20,000.'
);
DECLARE @IdClas_RBC INT = SCOPE_IDENTITY();

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Diario Expreso','Jurídica','https://www.expreso.com.pe/judicial/ricardo-belmont-condenado-por-difamar-a-phillip-butters/'),
('Peru21','Mediática','https://peru21.pe/politica/belmont-paso-174-dias-fuera-pais-ultimos-dos-anos-gestion-429883-noticia/');

GO


/* =====================================================
   REGISTRO INTEGRAL: NAPOLEÓN BECERRA GARCÍA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DE LOS TRABAJADORES Y EMPRENDEDORES PTE - PERU') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DE LOS TRABAJADORES Y EMPRENDEDORES PTE - PERU');

DECLARE @IdP_NB INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DE LOS TRABAJADORES Y EMPRENDEDORES PTE - PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('NAPOLEON BECERRA GARCIA', '08058852', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_NB);

DECLARE @IdC_NB INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','CAJAMARCA','CAJAMARCA','CAJAMARCA', @IdC_NB),
('Domicilio','LIMA','LIMA','SAN JUAN DE LURIGANCHO', @IdC_NB);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_NB, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad Inca Garcilaso de la Vega','LICENCIADO EN ADMINISTRACION', 1, 2009, @IdC_NB),
('Universidad Inca Garcilaso de la Vega','BACHILLER EN CIENCIAS ADMINISTRATIVAS', 1, NULL, @IdC_NB);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('MUNICIPALIDAD DE LIMA METROPOLITANA','EMPLEADO', 1984, 2025, @IdC_NB);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PTE - PERU','PARTIDARIO','FUNDADOR', 2023, NULL, @IdC_NB),
('PTE - PERU','PARTIDARIO','PRESIDENTE', 2023, NULL, @IdC_NB);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (72000.00, 0.00, 72000.00, @IdC_NB);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES (@IdC_NB, 'MUEBLE', 'PROPIEDAD VEHICULAR', NULL, 20000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_NB, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'napoleon_a3', 132, 0.426, 3.277);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_NB, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'No tiene según página web');

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO', 'LA VICTORIA', @IdC_NB),
('DISTRITO', 'CERCADO DE LIMA', @IdC_NB),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_NB),
('PROVINCIA', 'CAJAMARCA', @IdC_NB),
('PROVINCIA', 'JAÉN', @IdC_NB),
('PROVINCIA', 'PUNO', @IdC_NB),
('PROVINCIA', 'MAYNAS', @IdC_NB),
('PROVINCIA', 'SANTA', @IdC_NB),
('REGION', 'CAJAMARCA', @IdC_NB),
('REGION', 'PUNO', @IdC_NB),
('REGION', 'LORETO', @IdC_NB),
('REGION', 'ÁNCASH', @IdC_NB);

--10. CLASIFICACIÓN LEGAL

-- A. Clasificación Principal (N0-A)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_NB, 0, 'A', 'N0-A', 
    'Sin información legal ni menciones mediáticas sobre procesos judiciales. Perfil caracterizado por trayectoria técnica en administración pública municipal.'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: JORGE NIETO MONTESINOS
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DEL BUEN GOBIERNO') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DEL BUEN GOBIERNO');

DECLARE @IdP_JN INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DEL BUEN GOBIERNO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('JORGE NIETO MONTESINOS', '06506278', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_JN);

DECLARE @IdC_JN INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','AREQUIPA','AREQUIPA','AREQUIPA', @IdC_JN),
('Domicilio','LIMA','LIMA','PUNTA HERMOSA', @IdC_JN);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_JN, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('PUCP','BACHILLER EN SOCIOLOGIA', 1, NULL, @IdC_JN);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('FACULTAD LATINOAMERICANA DE CIENCIAS SOCIALES','SOCIOLOGIA','MAESTRIA', 1, 1984, @IdC_JN),
('CENTRO DE ESTUDIOS SOCIOLÓGICOS DE EL COLEGIO DE MÉXICO','SOCIOLOGÍA','DOCTORADO', 1, 1991, @IdC_JN);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('MINISTERIO DE DEFENSA','MINISTRO', 2016, 2018, @IdC_JN),
('MINISTERIO DE CULTURA','MINISTRO', 2016, 2016, @IdC_JN),
('INSTITUTO INTERNACIONAL PARA LA CULTURA DEMOCRÁTICA SAC','PRESIDENTE',2011,2014,@IdC_JN);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('PARTIDO DEL BUEN GOBIERNO','PARTIDARIO','PRESIDENTE', 2023, 2025, @IdC_JN);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 180000.00, 180000.00, @IdC_JN);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_JN, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 364688.73),
(@IdC_JN, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 44628.74),
(@IdC_JN, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 78355.20),
(@IdC_JN, 'INMUEBLE', 'INMUEBLE', NULL, 0.00),
(@IdC_JN, 'INMUEBLE', 'INMUEBLE', NULL, 0.00),
(@IdC_JN, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 50000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_JN, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'jorgenietomon', 49, 8.151, 51.5);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_JN, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'buengobiernope',8.466,84 );

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('PROVINCIA','SAN ROMÁN', @IdC_JN), 
('REGION','PUNO', @IdC_JN);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N3-PAT)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubSubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_JN, 3, 'PAT', 'N3-PAT', 
    'Investigación preparatoria formalizada por presunto Lavado de Activos en el marco del caso Lava Jato (Campaña NO a la revocatoria).'
);
DECLARE @IdClas_JN INT = SCOPE_IDENTITY();

-- B. Variable Secundaria H2 (Hoja de Vida)
DECLARE @vH2 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, Justificacion)
VALUES (@IdClas_JN, @vH2, 'Antecedente de procedimiento administrativo ante el JEE por presunta omisión de información en declaración jurada de hoja de vida.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Canal N','Jurídica','https://canaln.pe/actualidad/caso-susana-villaran-fiscalia-formalizo-investigacion-preparatoria-marisa-glave-y-jorge-nieto-lavado-activos-n464191'),
('RPP Noticias','Mediática','https://rpp.pe/politica/elecciones/elecciones-2021-jee-iniciara-proceso-para-excluir-candidatura-congresal-de-jorge-nieto-noticia-1318085');

GO


/* =====================================================
   REGISTRO INTEGRAL: CHARLIE CARRASCO SALAZAR
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DEMOCRATA UNIDO PERU') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DEMOCRATA UNIDO PERU');

DECLARE @IdP_CCS INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DEMOCRATA UNIDO PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('CHARLIE CARRASCO SALAZAR', '40799023', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_CCS);

DECLARE @IdC_CCS INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','APURIMAC','ANDAHUAYLAS','HUANCARAMA', @IdC_CCS),
('Domicilio','LIMA','LIMA','RIMAC', @IdC_CCS);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_CCS, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad Tecnológica de los Andes','BACHILLER EN DERECHO', 1, 2007, @IdC_CCS),
('Universidad Tecnológica de los Andes','ABOGADO', 1, 2009, @IdC_CCS);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('UNFV','DERECHO CONSTITUCIONAL','MAESTRIA', 1, 2011, @IdC_CCS),
('UNFV','DERECHO','DOCTORADO', 1, 2012, @IdC_CCS),
('USMP','GESTIÓN PÚBLICA','MAESTRIA', 1, 2023, @IdC_CCS);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('Universidad Nacional Jose Faustino Sanchez Carrion','CATEDRÁTICO', 2021, 2025, @IdC_CCS);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO DEMOCRATA UNIDO PERU','PARTIDARIO','FUNDADOR', 2021, NULL, @IdC_CCS),
('PARTIDO DEMOCRATA UNIDO PERU','PARTIDARIO','PRESIDENTE', 2021, NULL, @IdC_CCS);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (57878.00, 16240.00, 74118.00, @IdC_CCS);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 53421.36),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 63926.28),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 5370.36),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 65736.15),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 4815.95),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 77051.56),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 4856.79),
(@IdC_CCS, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 73366.49),
(@IdC_CCS, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 75000.00),
(@IdC_CCS, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 7000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_CCS, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'charliecarrascooficial', 653, 32.1, 468.9);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_CCS, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'pdunidoperuoficial', 1.706, 13.5);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITOS
('DISTRITO', 'CERCADO DE LIMA', @IdC_CCS),
('DISTRITO', 'SANTIAGO DE SURCO', @IdC_CCS),
('DISTRITO', 'COMAS', @IdC_CCS),

-- PROVINCIAS
('PROVINCIA', 'SAN MARTÍN', @IdC_CCS),
('PROVINCIA', 'TRUJILLO', @IdC_CCS),
('PROVINCIA', 'CAJAMARCA', @IdC_CCS),
('PROVINCIA', 'SATIPO', @IdC_CCS),
('PROVINCIA', 'PUNO', @IdC_CCS),
('PROVINCIA', 'BAGUA', @IdC_CCS),
('PROVINCIA', 'JAÉN', @IdC_CCS),
('PROVINCIA', 'CALLAO', @IdC_CCS),
('PROVINCIA', 'SAN ROMÁN', @IdC_CCS),
('PROVINCIA', 'CHINCHA', @IdC_CCS),
('PROVINCIA', 'ICA', @IdC_CCS),
('PROVINCIA', 'ABANCAY', @IdC_CCS),
('PROVINCIA', 'COTABAMBAS', @IdC_CCS),
('PROVINCIA', 'CHINCHEROS', @IdC_CCS),
('PROVINCIA', 'ACOBAMBA', @IdC_CCS),
('PROVINCIA', 'TAYACAJA', @IdC_CCS),

-- REGIONES
('REGION', 'SAN MARTÍN', @IdC_CCS),
('REGION', 'LA LIBERTAD', @IdC_CCS),
('REGION', 'CAJAMARCA', @IdC_CCS),
('REGION', 'JUNÍN', @IdC_CCS),
('REGION', 'PUNO', @IdC_CCS),
('REGION', 'AMAZONAS', @IdC_CCS),
('REGION', 'ICA', @IdC_CCS),
('REGION', 'APURÍMAC', @IdC_CCS),
('REGION', 'HUANCAVELICA', @IdC_CCS);

--10. CLASIFICACIÓN LEGAL

-- A. Clasificación Principal (N0-A)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_CCS, 0, 'A', 'N0-A', 
    'Candidato sin investigaciones fiscales, procesos judiciales ni sanciones administrativas registradas. Perfil académico enfocado en Derecho y Gestión Pública.'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: ÁLEX GONZALES CASTILLO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DEMOCRATA VERDE') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DEMOCRATA VERDE');

DECLARE @IdP_AGC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DEMOCRATA VERDE');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ALEX GONZALES CASTILLO', '09307547', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_AGC);

DECLARE @IdC_AGC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_AGC),
('Domicilio','LIMA','LIMA','LA VICTORIA', @IdC_AGC);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_AGC, 1, 1, 1);

INSERT INTO EstudiosNoUniversitarios (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('MINJUS - DIRECCION DE CONCILIACION', 'CONCILIACION EXTRAJUDICIAL', 1, @IdC_AGC);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UNIVERSIDAD INCA GARCILASO DE LA VEGA','ADMINISTRACION', 0, NULL, @IdC_AGC);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('INSTITUTO DE ECOLOGIA POLITICA "ALTERNATIVA VERDE"', 'PRESIDENTE', 2011, 2014, @IdC_AGC),
('INSTITUTO DE ESTUDIOS JURIDICOS DERECTUM', 'PRESIDENTE', 2011, 2018, @IdC_AGC),
('MUNICIPALIDAD DISTRITAL DE SAN JUAN DE LURIGANCHO', 'ALCALDE DISTRITAL', 2019, 2022, @IdC_AGC),
('INSTITUTO DE ESTUDIOS JURIDICOS DERECTUM', 'PRESIDENTE', 2023, 2024, @IdC_AGC),
('PARTIDO DEMOCRATA VERDE', 'FUNDADOR Y PRESIDENTE DEL COMITE EJECUTIVO NACIONAL', 2021, 2025, @IdC_AGC);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO DEMOCRATA VERDE','PARTIDARIO','FUNDADOR', 2021, NULL, @IdC_AGC),
('PARTIDO DEMOCRATA VERDE','PARTIDARIO','PRESIDENTE',2025,NULL,@IdC_AGC),
('PODEMOS PERU','ELECCION_POPULAR','ALCALDE DISTRITAL', 2019, 2022, @IdC_AGC);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 36000.00, 36000.00, @IdC_AGC);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 25287.39),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 76024.39),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 34400.00),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.00),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.00),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 0.00),
(@IdC_AGC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 75581.66),

-- MUEBLES
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00),
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00),
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00),
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00),
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00),
(@IdC_AGC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 0.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_AGC, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'alex_gonzales_verde', 494, 177.4, 166.5);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_AGC, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'partidoverdeperu', 23.3, 380.6);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITO
('DISTRITO', 'SAN JUAN DE MIRAFLORES', @IdC_AGC),

-- PROVINCIAS
('PROVINCIA', 'PASCO', @IdC_AGC),
('PROVINCIA', 'SAN MARTÍN', @IdC_AGC),
('PROVINCIA', 'MAYNAS', @IdC_AGC),
('PROVINCIA', 'AREQUIPA', @IdC_AGC),
('PROVINCIA', 'CUSCO', @IdC_AGC),
('PROVINCIA', 'HUÁNUCO', @IdC_AGC),
('PROVINCIA', 'TRUJILLO', @IdC_AGC),
('PROVINCIA', 'SANTA', @IdC_AGC),
('PROVINCIA', 'CAÑETE', @IdC_AGC),
('PROVINCIA', 'HUARAL', @IdC_AGC),
('PROVINCIA', 'LA CONVENCIÓN', @IdC_AGC),
('PROVINCIA', 'CAJAMARCA', @IdC_AGC),
('PROVINCIA', 'ICA', @IdC_AGC),
('PROVINCIA', 'BARRANCA', @IdC_AGC),
('PROVINCIA', 'MARISCAL CÁCERES', @IdC_AGC),

-- REGIONES
('REGION', 'PASCO', @IdC_AGC),
('REGION', 'SAN MARTÍN', @IdC_AGC),
('REGION', 'LORETO', @IdC_AGC),
('REGION', 'AREQUIPA', @IdC_AGC),
('REGION', 'CUSCO', @IdC_AGC),
('REGION', 'JUNÍN', @IdC_AGC),
('REGION', 'LA LIBERTAD', @IdC_AGC),
('REGION', 'ÁNCASH', @IdC_AGC),
('REGION', 'LIMA', @IdC_AGC),
('REGION', 'ICA', @IdC_AGC),
('REGION', 'CAJAMARCA', @IdC_AGC);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N1-D)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_AGC, 1, 'D', 'N1-D', 
    'Registra múltiples cuestionamientos mediáticos y pedidos de suspensión ante el JNE por presuntas irregularidades en gestión de fondos (S/ 3.4 millones) y contratación de personal.'
);
DECLARE @IdClas_AGC INT = SCOPE_IDENTITY();

-- B. Variable Secundaria H3 (Neutralidad)
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, Justificacion)
VALUES (@IdClas_AGC, @vH3, 'Denuncias por presunto uso de recursos de la Municipalidad de SJL para fines proselitistas y actividades del Partido Demócrata Verde.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Agencia Andina','Institucional','https://andina.pe/agencia/noticia-concejo-sjl-decidira-sobre-pedido-suspension-contra-alex-gonzales-746555.aspx'),
('Peru21','Mediática','https://peru21.pe/lima/jne-admite-solicitud-suspension-alcalde-san-juan-lurigancho-nndc-467677-noticia/'),
('Diario Expreso','Mediática','https://www.expreso.com.pe/actualidad/regidores-denuncian-a-alcalde-de-sjl-por-actos-de-corrupcion/551729/');

GO


/* =====================================================
   REGISTRO INTEGRAL: ARMANDO JOAQUIN MASSE FERNANDEZ
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DEMOCRATICO FEDERAL') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DEMOCRATICO FEDERAL');

DECLARE @IdP_AMF INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DEMOCRATICO FEDERAL');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ARMANDO JOAQUIN MASSE FERNANDEZ', '08255194', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_AMF);

DECLARE @IdC_AMF INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_AMF),
('Domicilio','LIMA','LIMA','SANTIAGO DE SURCO', @IdC_AMF);

-- 4. EDUCACIÓN (Perfil Médico-Abogado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_AMF, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('UNMSM','MÉDICO CIRUJANO', 1, 1988, @IdC_AMF),
('UIGV','BACHILLER EN DERECHO Y CIENCIAS POLITICAS', 1, 2006, @IdC_AMF),
('UIGV','ABOGADO', 1, 2007, @IdC_AMF);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('PUCP','ADMINISTRACION ESTRATEGICA DE EMPRESAS','MAESTRIA', 1, NULL, @IdC_AMF),
('PUCP','PROPIEDAD INTELECTUAL Y COMPETENCIA','MAESTRIA', 1, NULL, @IdC_AMF),
('U. EUROPEA DE MADRID','DERECHO DIGITAL TECNOLÓGICO','MAESTRIA', 1, NULL, @IdC_AMF);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('CENTRO MÉDICO DE GUARDIA','MEDICO', 2016, 2025, @IdC_AMF),
('APDAYC','PRESIDENTE/SECRETARIO GENERAL', 1999, 2025, @IdC_AMF);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO DEMOCRATICO FEDERAL','PARTIDARIO','FUNDADOR', 2023, NULL, @IdC_AMF),
('PARTIDO DEMOCRATICO FEDERAL','PARTIDARIO','MIEMBRO COMISIÓN POLÍTICA', 2023, NULL, @IdC_AMF);

-- 7. SENTENCIAS (HISTORIAL CERRADO)
INSERT INTO RelacionSentencias (IdCandidato, MateriaDemanda, FalloPena)
VALUES
(@IdC_AMF, 'CONTRA EL PATRIMONIO', 'SOBRESEIDA/PENA CUMPLIDA'),
(@IdC_AMF, 'FRAUDE EN LA ADM. DE PERSONAS JURIDICAS', 'ABSUELTO/PENA CUMPLIDA');

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 682626.00, 682626.00, @IdC_AMF);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_AMF, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 381762.66),
(@IdC_AMF, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 25000.00),
(@IdC_AMF, 'INMUEBLE', 'LIBRO DE ASENTAMIENTOS HUMANOS', NULL, 15000.00),
(@IdC_AMF, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 130000.00),
(@IdC_AMF, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 40000.00),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 35774.76),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 32208.54),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 31055.64),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 29852.34),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 24740.94),
(@IdC_AMF, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 26578.80),
(@IdC_AMF, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 133856.00),
(@IdC_AMF, 'INMUEBLE', 'TERRENO', NULL, 15777.11),
(@IdC_AMF, 'INMUEBLE', 'INMUEBLE', NULL, 254556.72),
(@IdC_AMF, 'INMUEBLE', 'TERRENO AGRICOLA', NULL, 1000.00),

-- MUEBLES
(@IdC_AMF, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 5000.00),
(@IdC_AMF, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 1500.00),
(@IdC_AMF, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 75000.00),
(@IdC_AMF, 'MUEBLE', 'AUTOMÓVIL', NULL, 4000.00),
(@IdC_AMF, 'MUEBLE', 'CAMIONETA RURAL', NULL, 6000.00);

-- 9. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_AMF, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'masse.armando', 58, 88.7, 638);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_AMF, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'No tiene según página web');

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITOS
('DISTRITO', 'LURIGANCHO-CHOSICA', @IdC_AMF),
('DISTRITO', 'PACHACÁMAC', @IdC_AMF),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_AMF),
('DISTRITO', 'ATE', @IdC_AMF),

-- PROVINCIAS
('PROVINCIA', 'SAN ROMÁN', @IdC_AMF),
('PROVINCIA', 'JAUJA', @IdC_AMF),
('PROVINCIA', 'CASTILLA', @IdC_AMF),
('PROVINCIA', 'BARRANCA', @IdC_AMF),
('PROVINCIA', 'HUAURA', @IdC_AMF),
('PROVINCIA', 'HUARAL', @IdC_AMF),
('PROVINCIA', 'SANTA', @IdC_AMF),
('PROVINCIA', 'CHEPÉN', @IdC_AMF),
('PROVINCIA', 'SULLANA', @IdC_AMF),
('PROVINCIA', 'CHICLAYO', @IdC_AMF),
('PROVINCIA', 'TRUJILLO', @IdC_AMF),
('PROVINCIA', 'HUARMEY', @IdC_AMF),

-- REGIONES
('REGION', 'PUNO', @IdC_AMF),
('REGION', 'JUNÍN', @IdC_AMF),
('REGION', 'AREQUIPA', @IdC_AMF),
('REGION', 'LIMA', @IdC_AMF),
('REGION', 'ÁNCASH', @IdC_AMF),
('REGION', 'LA LIBERTAD', @IdC_AMF),
('REGION', 'PIURA', @IdC_AMF),
('REGION', 'LAMBAYEQUE', @IdC_AMF);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H
-- A. Clasificación Principal (N1-C)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_AMF, 1, 'C', 'N1-C', 
    'Conflictos administrativos resueltos por INDECOPI en relación a su gestión en APDAYC. No registra procesos penales vigentes.'
);
DECLARE @IdClas_AMF INT = SCOPE_IDENTITY();

-- B. Variable H1 (Conflicto de interés)
DECLARE @vH1 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H1');
INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, Justificacion)
VALUES (@IdClas_AMF, @vH1, 'Cuestionamientos mediáticos por relaciones comerciales entre APDAYC y empresas vinculadas a su círculo familiar mientras ejercía la presidencia.');

-- C. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Diario Correo','Mediática','https://diariocorreo.pe/espectaculos/indecopi-suspende-a-armando-masse-y-todo-el-47681/'),
('Peru21','Mediática','https://peru21.pe/politica/apdayc-indecopi-suspende-ano-armando-masse-directorio-147390-noticia/');

GO




/* =====================================================
   REGISTRO INTEGRAL: GEORGE PATRICK FORSYTH SOMMER
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO DEMOCRATICO SOMOS PERU') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO DEMOCRATICO SOMOS PERU');

DECLARE @IdP_GFS INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO DEMOCRATICO SOMOS PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('GEORGE PATRICK FORSYTH SOMMER', '41265978', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_GFS);

DECLARE @IdC_GFS INT = SCOPE_IDENTITY();

-- 3. UBICACIONES (Nacido en el extranjero)
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','CARACAS','VENEZUELA','CARACAS', @IdC_GFS),
('Domicilio','LIMA','LIMA','LA VICTORIA', @IdC_GFS);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_GFS, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UPC','BACHILLER EN ADMINISTRACIÓN DE EMPRESAS', 1, 2021, @IdC_GFS);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad del Pacífico','MAGÍSTER EN ADMINISTRACIÓN','MAESTRIA', 1, 2023, @IdC_GFS);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('ALHAMBRA INVERSIONES S.R.L', 'GERENTE GENERAL', 2024, 2025, @IdC_GFS),
('MUNICIPALIDAD DE LA VICTORIA', 'ALCALDE DISTRITAL', 2019, 2020, @IdC_GFS),
('CLUB ALIANZA LIMA', 'REPRESENTANTE DE CREDITO FISCAL', 2012, 2020, @IdC_GFS),
('LOS M SAC', 'GERENTE GENERAL', 2017, 2025, @IdC_GFS),
('CLUB ALIANZA LIMA', 'FUTBOLISTA PROFESIONAL', 2008, 2016, @IdC_GFS);   

-- 6. CARGOS DE ELECCIÓN POPULAR
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PPC - UNIDAD NACIONAL','ELECCION_POPULAR','REGIDOR DISTRITAL', 2011, 2014, @IdC_GFS),
('SOMOS PERU','ELECCION_POPULAR','ALCALDE DISTRITAL', 2019, 2022, @IdC_GFS);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 244000.00, 244000.00, @IdC_GFS);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_GFS, 'MUEBLE', 'PROPIEDAD VEHICULAR', 'Vehículo 1', 2000.00),
(@IdC_GFS, 'MUEBLE', 'PROPIEDAD VEHICULAR', 'Vehículo 2', 40000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_GFS, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'georgeforsyth_', 98, 6.184, 31.3);
INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_GFS, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'somosperuoficial',2.55,19.4 );

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITOS
('DISTRITO', 'COMAS', @IdC_GFS),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_GFS),
('DISTRITO', 'VILLA EL SALVADOR', @IdC_GFS),
('DISTRITO', 'CARABAYLLO', @IdC_GFS),

-- PROVINCIAS
('PROVINCIA', 'MAYNAS', @IdC_GFS),
('PROVINCIA', 'CHINCHA', @IdC_GFS),
('PROVINCIA', 'ICA', @IdC_GFS),
('PROVINCIA', 'PIURA', @IdC_GFS),
('PROVINCIA', 'CAJAMARCA', @IdC_GFS),
('PROVINCIA', 'TACNA', @IdC_GFS),
('PROVINCIA', 'ILO', @IdC_GFS),
('PROVINCIA', 'LEONCIO PRADO', @IdC_GFS),
('PROVINCIA', 'HUÁNUCO', @IdC_GFS),

-- REGIONES
('REGION', 'LORETO', @IdC_GFS),
('REGION', 'ICA', @IdC_GFS),
('REGION', 'PIURA', @IdC_GFS),
('REGION', 'CAJAMARCA', @IdC_GFS),
('REGION', 'TACNA', @IdC_GFS),
('REGION', 'MOQUEGUA', @IdC_GFS),
('REGION', 'HUÁNUCO', @IdC_GFS);

--10. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal (N3-COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_GFS, 3, 'COR', 'N3-COR', 
    'Investigación preliminar fiscal por Negociación Incompatible y Colusión Agravada (Caso Renzo Navarro y favorecimiento empresarial en La Victoria).'
);
DECLARE @IdClas_GFS INT = SCOPE_IDENTITY();

-- B. Variable H2 (Hoja de Vida)
INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, Justificacion)
VALUES (@IdClas_GFS, (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2'), 
'Antecedente de exclusión por el JEE en 2021 por omitir ingresos privados superiores a S/ 50,000.');

-- C. Variable H1 (Conflicto de Interés)
INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, Justificacion)
VALUES (@IdClas_GFS, (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H1'), 
'Cuestionamientos por uso de vehículos vinculados a empresarios donantes de la municipalidad durante su gestión.');

-- D. Fuentes
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('El Comercio','Jurídica','https://elcomercio.pe/politica/justicia/george-forsyth-fiscalia-inicia-investigacion-preliminar-en-su-contra/'),
('Wayka','Jurídica','https://wayka.pe/jee-excluye-a-forsyth-por-omitir-en-su-hoja-de-vida-que-gano-mas-de-s-50-000-en-2019/');

GO


/* =====================================================
   REGISTRO INTEGRAL: LUIS FERNANDO OLIVERA VEGA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO FRENTE DE LA ESPERANZA 2021') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO FRENTE DE LA ESPERANZA 2021');

DECLARE @IdP_LFO INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO FRENTE DE LA ESPERANZA 2021');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('LUIS FERNANDO OLIVERA VEGA', '06280714', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_LFO);

DECLARE @IdC_LFO INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_LFO),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_LFO);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_LFO, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad del Pacífico','BACHILLER EN CIENCIAS CON MENCION EN ADMINISTRACION', 1, NULL, @IdC_LFO);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('ASOCIACION AKUY UKUKU','DIRECTOR DE ECONOMIA Y COOPERACION INTERNACIONAL', 2025, 2025, @IdC_LFO),
('CONSEJO EMPRESARIAL DEL PERU EN ESPAÑA','PRESIDENTE', 2008, 2025, @IdC_LFO);

-- 6. CARGOS PARTIDARIOS Y DE ELECCIÓN
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO FRENTE DE LA ESPERANZA 2021','PARTIDARIO','FUNDADOR',2020,NULL, @IdC_LFO),
('PARTIDO FRENTE DE LA ESPERANZA 2021','PARTIDARIO','PRESIDENTE DEL PARTIDO', 2023, NULL, @IdC_LFO),
('FRENTE INDEPENDIENTE MORALIZADOR','ELECCION_POPULAR','CONGRESISTA', 2000, 2001, @IdC_LFO);

-- 7. INGRESOS Y BIENES
-- Nota: Registra S/ 0.00 en ingresos según info proporcionada
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 0.00, 0.00, @IdC_LFO);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_LFO,'INMUEBLE','REGISTRO DE PREDIOS','Predio 1',2801.54),
(@IdC_LFO,'INMUEBLE','REGISTRO DE PREDIOS','Predio 2',197834.20),
(@IdC_LFO,'INMUEBLE','REGISTRO DE PREDIOS','Predio 3',0.00),
(@IdC_LFO,'MUEBLE','REGISTRO DE PROPIEDAD VEHICULAR','Vehiculo 1',15000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_LFO, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'popyolivera', 128, 33.5, 253);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_LFO, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 0, 'No tiene según página web');

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITOS
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_LFO),
('DISTRITO', 'LA VICTORIA', @IdC_LFO),

-- PROVINCIAS
('PROVINCIA', 'SULLANA', @IdC_LFO),
('PROVINCIA', 'PIURA', @IdC_LFO),
('PROVINCIA', 'HUANCAYO', @IdC_LFO),
('PROVINCIA', 'HUANTA', @IdC_LFO),
('PROVINCIA', 'CHICLAYO', @IdC_LFO),
('PROVINCIA', 'FERREÑAFE', @IdC_LFO),
('PROVINCIA', 'TRUJILLO', @IdC_LFO),
('PROVINCIA', 'SANTA', @IdC_LFO),
('PROVINCIA', 'AREQUIPA', @IdC_LFO),
('PROVINCIA', 'ILO', @IdC_LFO),

-- REGIONES
('REGION', 'PIURA', @IdC_LFO),
('REGION', 'JUNÍN', @IdC_LFO),
('REGION', 'AYACUCHO', @IdC_LFO),
('REGION', 'LAMBAYEQUE', @IdC_LFO),
('REGION', 'LA LIBERTAD', @IdC_LFO),
('REGION', 'ÁNCASH', @IdC_LFO),
('REGION', 'AREQUIPA', @IdC_LFO),
('REGION', 'MOQUEGUA', @IdC_LFO);

--10. CLASIFICACIÓN LEGAL

-- A. Clasificación Principal (N3-COR)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_LFO, 3, 'COR', 'N3-COR', 
    'Investigación por presunta colusión agravada (Caso Interoceánica Sur). El PJ rechazó el archivo del caso en 2024, señalando indicios de complicidad.'
);
DECLARE @IdClas_LFO INT = SCOPE_IDENTITY();

-- B. Fuente de Información
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('RPP / AccesoPerú','Jurídica','https://www.accesoperu.com/pj-vuelve-a-rechazar-pedido-de-fernando-olivera-para-archivar-delito-de-colusion-agravada/'),
('LP Derecho','Jurídica','https://lpderecho.pe/para-imputar-colusion-desleal-no-basta-la-intervencion-en-actos-administrativos-que-viabilizan-un-contrato-como-el-levantar-observaciones-sino-que-se-requiere-acreditar-la-existenci/');

GO


/* =====================================================
   REGISTRO INTEGRAL: MESIAS ANTONIO GUEVARA AMASIFUEN
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO MORADO') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO MORADO');

DECLARE @IdP_MAG INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO MORADO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('MESIAS ANTONIO GUEVARA AMASIFUEN', '09871134', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_MAG);

DECLARE @IdC_MAG INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LAMBAYEQUE','CHICLAYO','ETEN', @IdC_MAG),
('Domicilio','CAJAMARCA','JAEN','JAEN', @IdC_MAG);

-- 4. EDUCACIÓN
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_MAG, 1, 1, 1);

INSERT INTO EstudiosTecnicos (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('ESEP MILITAR ELIAS AGUIRRE - CHICLAYO', 'MECANICA DE PRODUCCIÓN', 1, @IdC_MAG);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad Ricardo Palma','BACHILLER INGENIERIA ELECTRONICA', 1, 1988, @IdC_MAG),
('Universidad Ricardo Palma','INGENIERO ELECTRONICO', 1, 1990, @IdC_MAG);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UPC', 'MAGISTER EN ADMINISTRACION DE EMPRESAS', 'MAESTRIA', 1, 2001, @IdC_MAG);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('CONGRESO DE LA REPUBLICA', 'CONGRESISTA', 2011, 2016, @IdC_MAG),
('GOBIERNO REGIONAL DE CAJAMARCA', 'GOBERNADOR REGIONAL', 2019, 2022, @IdC_MAG),
('CEPLAN', 'MIEMBRO DEL CONSEJO DIRECTIVO', 2019, 2025, @IdC_MAG),
('CONSULTOR INDEPENDIENTE', 'CONSULTOR INDEPENDIENTE', 2023, 2025, @IdC_MAG),
('GOBIERNO REGIONAL ANCASH', 'LOCADOR FAG', 2025, 2025, @IdC_MAG);

-- 6. CARGOS PARTIDARIOS Y DE ELECCIÓN
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('ACCION POPULAR','PARTIDARIO','REPRESENTANTE LEGAL', 2011, 2013, @IdC_MAG),
('ACCION POPULAR','PARTIDARIO','PRESIDENTE', 2014, 2018, @IdC_MAG),
('PERÚ POSIBLE','ELECCION_POPULAR','CONGRESISTA', 2011, 2016, @IdC_MAG),
('ACCION POPULAR','ELECCION_POPULAR','GOBERNADOR(A) REGIONAL', 2019, 2022, @IdC_MAG);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (36000.00, 118941.00, 154941.00, @IdC_MAG);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_MAG,'INMUEBLE','REGISTRO DE PREDIOS',NULL,10121.49),
(@IdC_MAG,'INMUEBLE','TERRENO RURAL',NULL,85533.34),
(@IdC_MAG,'INMUEBLE','TERRENO',NULL,40560.00),
(@IdC_MAG,'INMUEBLE','TERRENO',NULL,85779.96),
(@IdC_MAG,'MUEBLE','REGISTRO DE PROPIEDAD VEHICULAR',NULL,5000.00),
(@IdC_MAG,'MUEBLE','REGISTRO DE PROPIEDAD VEHICULAR',NULL,20000.00);

-- 8. REDES SOCIALES
INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_MAG, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'mesiaspresidente', 94, 1.732, 18.1);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_MAG, (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK'), 1, 'partidomorado', 5.899, 74.2);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('PROVINCIA','AREQUIPA',@IdC_MAG),
('PROVINCIA','TACNA',@IdC_MAG),
('PROVINCIA','ICA',@IdC_MAG),
('REGION','AREQUIPA',@IdC_MAG),
('REGION','TACNA',@IdC_MAG),
('REGION','ICA',@IdC_MAG);

-- 10. CLASIFICACIÓN LEGAL
-- Perfil N0-A: Sin antecedentes penales ni investigaciones fiscales críticas reportadas al 2026.
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_MAG, 0, 'A', 'N0-A', 
    'Candidato con perfil académico y técnico sólido. Trayectoria en gestión regional y nacional sin registros de sentencias ni investigaciones fiscales de alto impacto.'
);
DECLARE @IdClas_MAG INT = SCOPE_IDENTITY();

GO


/* =====================================================
   REGISTRO INTEGRAL: CARLOS GONSALO ALVAREZ LOAYZA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO PAIS PARA TODOS') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO PAIS PARA TODOS');

DECLARE @IdP_CAL INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO PAIS PARA TODOS');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('CARLOS GONSALO ALVAREZ LOAYZA', '06002034', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_CAL);

DECLARE @IdC_CAL INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_CAL),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_CAL);

-- 4. EDUCACIÓN BÁSICA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_CAL, 1, 1, 1);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('INDEPENDIENTE','COMEDIANTE', 2020, 2025, @IdC_CAL),
('ANDINA DE RADIO DIFUSIÓN','COMEDIANTE', 2019, 2019, @IdC_CAL),
('WILLAX SAC','COMEDIANTE', 2018, 2018, @IdC_CAL);

-- 6. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 207543.00, 207543.00, @IdC_CAL);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,55000.00),
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,0.00),
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,0.00),
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,30000.00),
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,6000.00),
(@IdC_CAL,'INMUEBLE','REGISTRO DE PREDIOS',NULL,415000.00),
(@IdC_CAL,'MUEBLE','AUTO DEPORTIVO',NULL,102000.00);

-- 7. REDES SOCIALES (Asegurando que la red exista)
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_TikTok INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_CAL, @IdRS_TikTok, 1, 'carlosalvarez_tiktok', 91, 570, 11100);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_CAL, @IdRS_TikTok, 1, 'partidopaisparatodos', 254.5, 3100);

-- 8. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('PROVINCIA','TUMBES', @IdC_CAL),
('REGION','TUMBES', @IdC_CAL);

-- 9. CLASIFICACIÓN LEGAL Y VARIABLES H

-- A. Clasificación Principal
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_CAL, 5, 'ADM', 'N5-ADM', 
    'Registró condena en 2002 por peculado (cómplice) en el marco de pagos vinculados al régimen Fujimori-Montesinos. Aunque fue absuelto en 2006, el antecedente histórico marca el nivel máximo de alerta administrativa.'
);
DECLARE @IdClas_CAL INT = SCOPE_IDENTITY();

-- B. Variables Secundarias
-- Nota: Asegúrate de que los códigos H2 y H7 existan en VariableSecundaria
DECLARE @vH2_CAL INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');
DECLARE @vH7_CAL INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7');
DECLARE @sH7D_CAL INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7_CAL AND Codigo='D');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_CAL, @vH2_CAL, NULL, 'Omisiones en hoja de vida (sentencia y bien patrimonial)'),
(@IdClas_CAL, @vH7_CAL, @sH7D_CAL, 'Absolución judicial posterior');

-- C. FUENTES (Uso IF NOT EXISTS para evitar errores de duplicidad en UNIQUE)
IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://latinanoticias.pe/politica/carlos-alvarez-continua-en-elecciones-2026-jee-descarta-exclusion-por-condena-absuelta-vinculada-a-montesinos_20260226/')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) VALUES ('Latina Noticias','Mediática','https://latinanoticias.pe/politica/carlos-alvarez-continua-en-elecciones-2026-jee-descarta-exclusion-por-condena-absuelta-vinculada-a-montesinos_20260226/');

IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://peru21.pe/sites/default/efsfiles/2026-01/pl140126_02.pdf#:~:text=Una%20informaci%C3%B3n%20sobre%20carlos.%20%C3%81lvarez%20corri%C3%B3%20con,de%20peculado%20y%20que%20el%20hoy%20candidato')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) VALUES ('Peru 21','Mediática','https://peru21.pe/sites/default/efsfiles/2026-01/pl140126_02.pdf#:~:text=Una%20informaci%C3%B3n%20sobre%20carlos.%20%C3%81lvarez%20corri%C3%B3%20con,de%20peculado%20y%20que%20el%20hoy%20candidato');

IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://www.infobae.com/peru/2026/01/14/beto-ortiz-cuestiona-a-carlos-alvarez-por-no-declarar-condena-vinculada-a-vladimiro-montesinos-no-existe-una-absolucion/')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) VALUES ('Infobae','Mediática','https://www.infobae.com/peru/2026/01/14/beto-ortiz-cuestiona-a-carlos-alvarez-por-no-declarar-condena-vinculada-a-vladimiro-montesinos-no-existe-una-absolucion/');

GO


/* =====================================================
   REGISTRO INTEGRAL: HERBERT CALLER GUTIÉRREZ
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO PATRIOTICO DEL PERU') 
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO PATRIOTICO DEL PERU');

DECLARE @IdP_HC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO PATRIOTICO DEL PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('HERBERT CALLER GUTIERREZ', '43409673', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_HC);

DECLARE @IdC_HC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','CUSCO','CUSCO','CUSCO', @IdC_HC),
('Domicilio','LIMA','LIMA','LA MOLINA', @IdC_HC);

-- 4. EDUCACIÓN (Básica, Técnica y Universitaria)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_HC, 1, 1, 1);

INSERT INTO EstudiosTecnicos (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('ESEP MILITAR ELIAS AGUIRRE - CHICLAYO', 'MECANICA DE PRODUCCIÓN', 1, @IdC_HC);

INSERT INTO EducacionUniversitaria (Universidad, Concluido, Grado, AñoObtencion, IdCandidato)
VALUES 
('Universidad Nacional de Ingeniería', 1, 'BACHILLER EN CIENCIAS', 2010, @IdC_HC),
('Universidad Alas Peruanas S.A.', 1, 'BACHILLER EN DERECHO', 2016, @IdC_HC),
('Universidad Alas Peruanas S.A.', 1, 'ABOGADO', 2025, @IdC_HC),
('Escuela Naval del Perú', 1, 'BACHILLER EN CIENCIAS MARÍTIMO NAVALES', 2025, @IdC_HC);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Concluido, Grado, AñoObtencion, IdCandidato)
VALUES
('INSTITUTO NACIONAL DE INVESTIGACION Y CAPACITACION DE TELECOMUNICACIONES - INICTEL', 'POST GRADO', 1, NULL, NULL, @IdC_HC),
('UNIVERSIDAD CARLOS III DE MADRID - ESPAÑA', 'MASTER DE GESTION Y ANALISIS DE POLITICAS PUBLICAS', 1, 'MAESTRIA', 2009, @IdC_HC);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('CALLER LANGUAGE CENTER SAC', 'EMPRESARIO', 2015, 2025, @IdC_HC),
('CALLER COLEGIO INTERNACIONAL DE SUPER APRENDIZAJE SAC', 'EMPRESARIO', 2016, 2025, @IdC_HC),
('MARINA DE GUERRA DEL PERU', 'OFICIAL SUPERIOR', 1996, 2017, @IdC_HC);

-- 7. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES 
('PARTIDO PATRIOTICO DEL PERU', 'PARTIDARIO', 'PRESIDENTE FUNDADOR', 2025, NULL, @IdC_HC),
('PARTIDO PATRIOTICO DEL PERU', 'PARTIDARIO', 'FUNDADOR', 2020, NULL, @IdC_HC);

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (21259.32, 165000.00, 186259.32, @IdC_HC);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES 
(@IdC_HC, 'INMUEBLE', 'REGISTRO DE PREDIOS', NULL, 83269.00),
(@IdC_HC, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', NULL, 10000.00),
(@IdC_HC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', NULL, 2800.00);

-- 7. REDES SOCIALES (Asegurando que la red exista)
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_HC INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdC_HC, @IdRS_HC, 0, 'Varios (no oficial)');

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_HC, @IdRS_HC,0 , 'Varios (no oficial)');

-- 9. CLASIFICACIÓN LEGAL Y VARIABLES H (Basado en reporte del JEE 2026)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_HC, 1, 'C', 'N1-C', 
    'Conflictos administrativos por omisión de información en Hoja de Vida. El JEE de Lima Centro advirtió una posible declaración falsa respecto a una sentencia civil de 2022 por ejecución de garantías.'
);

DECLARE @IdClas_HC INT = SCOPE_IDENTITY();

-- Variable H2 (Hoja de Vida / Omisiones)
DECLARE @vH2_HC INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_HC, @vH2_HC, NULL, 'No consignó sentencia civil firme de 2022 por ejecución de garantías (S/ 84,000) en su declaración ante el JNE.');

-- 10. FUENTES
IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://peru21.pe/politica/elecciones-2026-candidatos-podran-ser-excluidos-si-mienten-en-su-hoja-de-vida/')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) 
    VALUES ('Peru 21', 'Mediática', 'https://peru21.pe/politica/elecciones-2026-candidatos-podran-ser-excluidos-si-mienten-en-su-hoja-de-vida/');

IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://larepublica.pe/politica/2026/01/27/elecciones-2026-informe-del-jee-advierte-que-candidato-presidencial-del-partido-patriotico-del-peru-habria-declarado-informacion-falsa-hnews-2196207')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) 
    VALUES ('La República', 'Mediática', 'https://larepublica.pe/politica/2026/01/27/elecciones-2026-informe-del-jee-advierte-que-candidato-presidencial-del-partido-patriotico-del-peru-habria-declarado-informacion-falsa-hnews-2196207');

GO



/* =====================================================
   REGISTRO INTEGRAL: YONHY LESCANO ANCIETA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO POLITICO COOPERACION POPULAR')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO POLITICO COOPERACION POPULAR');

DECLARE @IdP_YL INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO POLITICO COOPERACION POPULAR');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('YONHY LESCANO ANCIETA', '01211014', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_YL);

DECLARE @IdC_YL INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','PUNO','PUNO','PUNO', @IdC_YL),
('Domicilio','LIMA','LIMA','SANTIAGO DE SURCO', @IdC_YL);

-- 4. EDUCACIÓN BÁSICA Y UNIVERSITARIA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_YL, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad Católica de Santa María','BACHILLER EN DERECHO', 1, 1999, @IdC_YL),
('Universidad Católica de Santa María','ABOGADO', 1, 1999, @IdC_YL);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('UNIVERSIDAD DE CHILE','GRADO DE MAGÍSTER EN DERECHO (GRADO DE MAESTRO)','MAESTRIA', 1, 2022, @IdC_YL),
('UNIVERSIDAD NACIONAL DEL ALTIPLANO','DERECHO','', 0, NULL, @IdC_YL);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('UNIVERSIDAD ANTIPLANO PUNO','PROFESOR PRINCIPAL', 2025, 2025, @IdC_YL),
('CONGRESO DE LA REPUBLICA','ASESOR', 2021, 2025, @IdC_YL);

-- 7. CARGOS PARTIDARIOS / ELECCIÓN POPULAR
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('ACCION POPULAR','PARTIDARIO','SECRETARIO GENERAL NACIONAL', 2009, 2011, @IdC_YL),
('ACCION POPULAR','PARTIDARIO','ADHERENTE FUNDACIONAL', 2004, 2023, @IdC_YL),
('ACCION POPULAR','ELECCION_POPULAR','CONGRESISTA', 2016, 2021, @IdC_YL),
('PERÚ POSIBLE','ELECCION_POPULAR','CONGRESISTA', 2011, 2016, @IdC_YL);

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (120000.00, 0.00, 120000.00, @IdC_YL);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
-- INMUEBLES
(@IdC_YL, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 306599.00),
(@IdC_YL, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 200000.00),
(@IdC_YL, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 30000.00),
(@IdC_YL, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 30000.00),
(@IdC_YL, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 240000.00),
(@IdC_YL, 'INMUEBLE', 'CO PROP PREDIOS RUSTICOS (LLALLAHUANI,CACHIÑA,TANGRA,QUIVIANI)', '', 200000.00),

-- MUEBLES
(@IdC_YL, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', '', 25000.00),
(@IdC_YL, 'MUEBLE', 'REGISTRO de PROPIEDAD VEHICULAR', '', 37000.00),
(@IdC_YL, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', '', 40000.00);
-- 9. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_YL INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_YL, @IdRS_YL, 1, NULL, 'yonhy.lescano', 133, 31.6, 258.1);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_YL, @IdRS_YL, 0, 'No tiene según página web');

-- 10. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- Distritos
('DISTRITO', 'SAN JUAN DE MIRAFLORES', @IdC_YL),
('DISTRITO', 'ATE', @IdC_YL),
('DISTRITO', 'VILLA EL SALVADOR', @IdC_YL),
('DISTRITO', 'LA VICTORIA', @IdC_YL),
('DISTRITO', 'CHORRILLOS', @IdC_YL),
('DISTRITO', 'SAN MARTÍN DE PORRES', @IdC_YL),
('DISTRITO', 'VILLA MARÍA DEL TRIUNFO', @IdC_YL),

-- Provincias
('PROVINCIA', 'HUARAZ', @IdC_YL),
('PROVINCIA', 'SANTA', @IdC_YL),
('PROVINCIA', 'PACASMAYO', @IdC_YL),
('PROVINCIA', 'TRUJILLO', @IdC_YL),
('PROVINCIA', 'CHICLAYO', @IdC_YL),
('PROVINCIA', 'PIURA', @IdC_YL),
('PROVINCIA', 'TALARA', @IdC_YL),
('PROVINCIA', 'MORROPÓN', @IdC_YL),
('PROVINCIA', 'ZARUMILLA', @IdC_YL),
('PROVINCIA', 'BAGUA', @IdC_YL),
('PROVINCIA', 'JAÉN', @IdC_YL),
('PROVINCIA', 'CHOTA', @IdC_YL),
('PROVINCIA', 'CAJAMARCA', @IdC_YL),
('PROVINCIA', 'ICA', @IdC_YL),
('PROVINCIA', 'PISCO', @IdC_YL),
('PROVINCIA', 'SAN ROMÁN', @IdC_YL),
('PROVINCIA', 'PUNO', @IdC_YL),
('PROVINCIA', 'AZÁNGARO', @IdC_YL),
('PROVINCIA', 'MELGAR', @IdC_YL),
('PROVINCIA', 'EL COLLAO', @IdC_YL),
('PROVINCIA', 'HUANCANÉ', @IdC_YL),
('PROVINCIA', 'ILO', @IdC_YL),
('PROVINCIA', 'AREQUIPA', @IdC_YL),
('PROVINCIA', 'CANAS', @IdC_YL),
('PROVINCIA', 'CANCHIS', @IdC_YL),
('PROVINCIA', 'CUSCO', @IdC_YL),
('PROVINCIA', 'LA CONVENCIÓN', @IdC_YL),
('PROVINCIA', 'ABANCAY', @IdC_YL),
('PROVINCIA', 'ANDAHUAYLAS', @IdC_YL),
('PROVINCIA', 'HUANTA', @IdC_YL),

-- Regiones
('REGION', 'ÁNCASH', @IdC_YL),
('REGION', 'LA LIBERTAD', @IdC_YL),
('REGION', 'LAMBAYEQUE', @IdC_YL),
('REGION', 'PIURA', @IdC_YL),
('REGION', 'TUMBES', @IdC_YL),
('REGION', 'AMAZONAS', @IdC_YL),
('REGION', 'CAJAMARCA', @IdC_YL),
('REGION', 'ICA', @IdC_YL),
('REGION', 'PUNO', @IdC_YL),
('REGION', 'MOQUEGUA', @IdC_YL),
('REGION', 'AREQUIPA', @IdC_YL),
('REGION', 'CUSCO', @IdC_YL),
('REGION', 'APURÍMAC', @IdC_YL),
('REGION', 'AYACUCHO', @IdC_YL);

-- 11. CLASIFICACIÓN LEGAL Y VARIABLES H
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_YL, 2, 'A', 'N2-A', 
    'Infracción al principio de neutralidad electoral declarada por el JEE. En 2018 llamó a votar por un candidato municipal desde instalaciones del Congreso.'
);

DECLARE @IdClas_YL INT = SCOPE_IDENTITY();

-- Variable H3 (Neutralidad electoral)
DECLARE @vH3_YL INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_YL, @vH3_YL, NULL, 'Infracción administrativa electoral por proselitismo en funciones públicas (Elecciones Municipales 2018).');

-- 12. FUENTES
IF NOT EXISTS (SELECT 1 FROM FuenteInformacion WHERE LinkFuente = 'https://wayka.pe/congresista-lescano-comete-infraccion-electoral-llamar-a-votar-por-candidato-de-su-partido/')
    INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente) 
    VALUES ('Wayka', 'Mediática', 'https://wayka.pe/congresista-lescano-comete-infraccion-electoral-llamar-a-votar-por-candidato-de-su-partido/');

GO


/* =====================================================
   REGISTRO INTEGRAL: WOLFGANG MARIO GROZO COSTA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO POLITICO INTEGRIDAD DEMOCRATICA')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO POLITICO INTEGRIDAD DEMOCRATICA');

DECLARE @IdP_WG INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO POLITICO INTEGRIDAD DEMOCRATICA');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('WOLFGANG MARIO GROZO COSTA', '07260881', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_WG);

DECLARE @IdC_WG INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','JESUS MARIA', @IdC_WG),
('Domicilio','LIMA','LIMA','SAN BORJA', @IdC_WG);

-- 4. EDUCACIÓN BÁSICA Y UNIVERSITARIA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_WG, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Escuela de Oficiales de la Fuerza Aérea del Perú','BACHILLER EN CIENCIAS DE LA ADMINISTRACION AEROESPACIAL', 1, 2010, @IdC_WG),
('Escuela de Oficiales de la Fuerza Aérea del Perú','LICENCIADO EN CIENCIAS DE LA ADMINISTRACION AEROESPACIAL', 1, 2012, @IdC_WG);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Centro de Altos Estudios Nacionales - CAEN','MAESTRO EN DESARROLLO Y DEFENSA NACIONAL','MAESTRIA', 1, 2018, @IdC_WG),
('Centro de Altos Estudios Nacionales - CAEN','DOCTOR EN DESARROLLO y SEGURIDAD ESTRATEGICA','DOCTORADO', 1, 2020, @IdC_WG),
('CESEDEN - ESPAÑA','CURSO DE ALTOS ESTUDIOS ESTRATEGICOS','ESPECIALIZACION', 1, 2017, @IdC_WG);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('UNIVERSIDAD DE LIMA','PROFESOR EN GERENCIA', 2022, 2025, @IdC_WG);

-- 7. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PARTIDO POLITICO INTEGRIDAD DEMOCRATICA','PARTIDARIO','FUNDADOR', 2023, NULL, @IdC_WG),
('PARTIDO POLITICO INTEGRIDAD DEMOCRATICA','PARTIDARIO','REPRESENTANTE LEGAL', 2023, NULL, @IdC_WG);

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (122220.00, 155607.00, 277827.00, @IdC_WG);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES
(@IdC_WG,'INMUEBLE','REGISTRO DE PREDIOS','',8500.00),
(@IdC_WG,'INMUEBLE','REGISTRO DE PREDIOS','',12000.00),
(@IdC_WG,'INMUEBLE','REGISTRO DE PREDIOS','',78250.00),
(@IdC_WG,'INMUEBLE','REGISTRO DE PREDIOS','',78250.00),
(@IdC_WG,'MUEBLE','REGISTRO DE PROPIEDAD VEHICULAR','',67400.00);

-- 9. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_WG INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_WG, @IdRS_WG, 1, NULL, 'wolfgang_grozo', 292, 114.7, 1300);
INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_WG, @IdRS_WG, 0, 'No tiene según página web');

-- 10. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- Distritos
('DISTRITO', 'CARABAYLLO', @IdC_WG),
('DISTRITO', 'LINCE', @IdC_WG),
('DISTRITO', 'SANTA ANITA', @IdC_WG),
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_WG),
('DISTRITO', 'LURÍN', @IdC_WG),

-- Provincias
('PROVINCIA', 'CHINCHA', @IdC_WG),
('PROVINCIA', 'ICA', @IdC_WG),
('PROVINCIA', 'NAZCA', @IdC_WG),
('PROVINCIA', 'TRUJILLO', @IdC_WG),
('PROVINCIA', 'CHICLAYO', @IdC_WG),
('PROVINCIA', 'SANTA', @IdC_WG),
('PROVINCIA', 'PUNO', @IdC_WG),
('PROVINCIA', 'CAMANÁ', @IdC_WG),
('PROVINCIA', 'CALLAO', @IdC_WG),
('PROVINCIA', 'CAÑETE', @IdC_WG),

-- Regiones
('REGION', 'ICA', @IdC_WG),
('REGION', 'LA LIBERTAD', @IdC_WG),
('REGION', 'LAMBAYEQUE', @IdC_WG),
('REGION', 'ÁNCASH', @IdC_WG),
('REGION', 'PUNO', @IdC_WG),
('REGION', 'AREQUIPA', @IdC_WG);

-- 11. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_WG, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales, procesos judiciales o denuncias formales hasta la fecha (2026).'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: VLADIMIR ROY CERRÓN ROJAS
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO POLITICO NACIONAL PERU LIBRE')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO POLITICO NACIONAL PERU LIBRE');

DECLARE @IdP_VCR INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO POLITICO NACIONAL PERU LIBRE');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('VLADIMIR ROY CERRON ROJAS', '06466585', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_VCR);

DECLARE @IdC_VCR INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','JUNIN','CHUPACA','CHUPACA', @IdC_VCR),
('Domicilio','JUNIN','HUANCAYO','HUANCAYO', @IdC_VCR); -- Corregido "Huanzayo" por Huancayo

-- 4. EDUCACIÓN BÁSICA Y UNIVERSITARIA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_VCR, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('INSTITUTO SUPERIOR DE CIENCIAS MÉDICAS DE CAMAGUEY','TÍTULO DE ESPECIALISTA DE PRIMER GRADO EN NEUROCIRUGÍA', 1, 2002, @IdC_VCR),
('INSTITUTO SUPERIOR DE CIENCIAS MÉDICAS DE CAMAGUEY','TÍTULO DE DOCTOR EN MEDICINA', 1, 1997, @IdC_VCR);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad Nacional Mayor de San Marcos','DOCTOR EN MEDICINA','DOCTORADO', 1, 2010, @IdC_VCR),
('Universidad Nacional Mayor de San Marcos','MAGISTER EN NEUROCIENCIAS','MAESTRIA', 1, 2009, @IdC_VCR);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PARTIDO POLITICO NACIONAL PERÚ LIBRE','SECRETARIO GENERAL NACIONAL', 2025, 2025, @IdC_VCR),
('GOBIERNO REGIONAL JUNÍN','GOBERNADOR REGIONAL', 2019, 2022, @IdC_VCR),
('HOSPITAL NACIONAL ESSALUD HUANCAYO','MEDICO NEUROCIRUJANO ASISTENTE', 2003, 2019, @IdC_VCR),
('UNIVERSIDAD NACIONAL DEL CENTRO DEL PERÚ','DOCENTE AUXILIAR NOMBRADO', 2011, 2019, @IdC_VCR),
('GOBIERNO REGIONAL JUNIN','PRESIDENTE REGIONAL', 2011, 2014, @IdC_VCR);

-- 7. CARGOS PARTIDARIOS / ELECCIÓN POPULAR
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PARTIDO POLITICO NACIONAL PERU LIBRE','PARTIDARIO','SECRETARÍA GENERAL NACIONAL', 2025, NULL, @IdC_VCR),
('PARTIDO POLITICO NACIONAL PERU LIBRE','PARTIDARIO','REPRESENTANTE LEGAL', 2023, NULL, @IdC_VCR),
('MOVIMIENTO POLITICO REGIONAL PERU LIBRE','ELECCION_POPULAR','GOBERNADOR(A) REGIONAL', 2011, 2014, @IdC_VCR),
('MOVIMIENTO POLITICO REGIONAL PERU LIBRE','ELECCION_POPULAR','GOBERNADOR(A) REGIONAL', 2019, 2022, @IdC_VCR);

-- 8. RELACIÓN DE SENTENCIAS (Histórico reportado)
INSERT INTO RelacionSentencias (IdCandidato, MateriaDemanda, FalloPena)
VALUES
(@IdC_VCR, 'NEGOCIACIÓN INCOMPATIBLE', '4 AÑOS DE PENA PRIVATIVA/PENA CUMPLIDA (Anulada 2025)'),
(@IdC_VCR, 'COLUSIÓN', '3 AÑOS 6 MESES DE PENA PRIVATIVA/PENA CUMPLIDA (Absuelto 2025)');

-- 9. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 0.00, 0.00, @IdC_VCR);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, Descripcion, ValorAutovaluo)
VALUES (@IdC_VCR, 'INMUEBLE', 'REGISTRO DE PREDIOS', '', 396811.03);

-- 10. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_VCR INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_VCR, @IdRS_VCR, 1, NULL, 'vladicerron', 175, 47.5, 630.7);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_VCR, @IdRS_VCR, 0, 'No tiene según página web');

-- 11. CLASIFICACIÓN LEGAL Y VARIABLES H (N4-M)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_VCR, 4, 'M', 'N4-M', 
    'Prisión preventiva vigente de 24 meses por organización criminal y lavado de activos. Condición actual: Prófugo con orden de captura. Registra incautación de S/ 1.6 millones por extinción de dominio.'
);

DECLARE @IdClas_VCR INT = SCOPE_IDENTITY();

-- Selección de Variables H
DECLARE @vH1 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H1'); -- Financiamiento
DECLARE @vH4 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H4'); -- Controversia Patrimonial
DECLARE @vH7 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H7'); -- Archivados/Absueltos
DECLARE @vH9 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H9'); -- Medidas Judiciales

-- Subvariables específicas
DECLARE @sH7C INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='C'); -- Absolución
DECLARE @sH7E INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH7 AND Codigo='E'); -- Condena Anulada
DECLARE @sH9A INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH9 AND Codigo='A'); -- Orden de captura / Prisión

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_VCR, @vH1, NULL, 'Investigación fiscal por financiamiento ilícito de campañas de Perú Libre.'),
(@IdClas_VCR, @vH4, NULL, 'Extinción de dominio: Incautación de S/ 1.6 millones por presunto origen ilícito (2025).'),
(@IdClas_VCR, @vH7, @sH7C, 'Absuelto por la Corte Suprema en el caso Aeródromo Wanka (2025).'),
(@IdClas_VCR, @vH7, @sH7E, 'TC anuló sentencia de 2019 vinculada al caso La Oroya (2025).'),
(@IdClas_VCR, @vH9, @sH9A, 'Prisión preventiva confirmada (2026) y orden de captura vigente desde 2023.');

-- 12. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('La República','Mediática','https://larepublica.pe/politica/2025/03/28/vladimir-cerron-logra-segunda-victoria-juridica-tc-anula-su-primera-condena-del-2019-por-caso-la-oroya-hnews-2206148'),
('Caretas','Mediática','https://caretas.pe/politica/poder-judicial-ratifica-prision-preventiva-contra-vladimir-cerron-pese-a-su-candidatura-presidencial/'),
('Infobae - Incautación','Mediática','https://www.infobae.com/peru/2025/10/22/vladimir-cerron-pierde-mas-de-s16-millones-de-sus-cuentas-por-fallo-del-poder-judicial-dinero-sera-transferido-al-estado/'),
('Infobae - Absolución','Mediática','https://www.infobae.com/peru/2025/03/26/vladimir-cerron-corte-suprema-absuelve-al-profugo-lider-de-peru-libre-del-caso-aerodromo-wanka/');

GO


/* =====================================================
   REGISTRO INTEGRAL: FRANCISCO ERNESTO DIEZ-CANSECO TÁVARA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO POLITICO PERU ACCION')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO POLITICO PERU ACCION');

DECLARE @IdP_FDC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO POLITICO PERU ACCION');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('FRANCISCO ERNESTO DIEZ-CANSECO TÁVARA', '08263758', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_FDC);

DECLARE @IdC_FDC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','SAN ISIDRO', @IdC_FDC),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_FDC);

-- 4. EDUCACIÓN BÁSICA Y UNIVERSITARIA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_FDC, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad Nacional Mayor de San Marcos', 'ABOGADO', 1, 1972, @IdC_FDC);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('Independiente', 'ABOGADO', 1981, 2025, @IdC_FDC);

-- 6. CARGOS PARTIDARIOS / ELECCIÓN POPULAR
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PARTIDO POLITICO PERU ACCION', 'PARTIDARIO', 'PRESIDENTE FUNDADOR', 2021, NULL, @IdC_FDC),
('PERU NACION', 'PARTIDARIO', 'PRESIDENTE', 2020, 2021, @IdC_FDC),
('CONVERGENCIA DEMOCRATICA', 'ELECCION_POPULAR', 'DIPUTADO(A)', 1985, 1990, @IdC_FDC);

-- 7. INGRESOS
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 45000.00, 45000.00, @IdC_FDC);

-- 8. REDES SOCIALES (TikTok)
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_FDC INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_FDC, @IdRS_FDC, 1, 'panchodiezcanseco', 230, 4.647, 105.4);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_FDC, @IdRS_FDC, 1, 'peruaccionoficial', 1077, 14.7);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITOS
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_FDC),
('DISTRITO', 'CHORRILLOS', @IdC_FDC),
('DISTRITO', 'LA VICTORIA', @IdC_FDC),
('DISTRITO', 'CERCADO DE LIMA', @IdC_FDC),
('DISTRITO', 'VILLA MARÍA DEL TRIUNFO', @IdC_FDC),
('DISTRITO', 'CHACLACAYO', @IdC_FDC),
('DISTRITO', 'BREÑA', @IdC_FDC),

-- PROVINCIAS
('PROVINCIA', 'ICA', @IdC_FDC),
('PROVINCIA', 'HUARAL', @IdC_FDC),
('PROVINCIA', 'MARISCAL RAMÓN CASTILLA', @IdC_FDC),
('PROVINCIA', 'CUSCO', @IdC_FDC),
('PROVINCIA', 'SANTA', @IdC_FDC),
('PROVINCIA', 'TRUJILLO', @IdC_FDC),
('PROVINCIA', 'HUAROCHIRÍ', @IdC_FDC),
('PROVINCIA', 'HUANCAYO', @IdC_FDC),
('PROVINCIA', 'AREQUIPA', @IdC_FDC),
('PROVINCIA', 'TACNA', @IdC_FDC),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_FDC),
('PROVINCIA', 'PUNO', @IdC_FDC),
('PROVINCIA', 'HUARMEY', @IdC_FDC),
('PROVINCIA', 'CALLAO', @IdC_FDC),

-- REGIONES
('REGION', 'ICA', @IdC_FDC),
('REGION', 'LORETO', @IdC_FDC),
('REGION', 'LIMA', @IdC_FDC),
('REGION', 'CUSCO', @IdC_FDC),
('REGION', 'LA LIBERTAD', @IdC_FDC),
('REGION', 'ÁNCASH', @IdC_FDC),
('REGION', 'JUNÍN', @IdC_FDC),
('REGION', 'AREQUIPA', @IdC_FDC),
('REGION', 'TACNA', @IdC_FDC),
('REGION', 'UCAYALI', @IdC_FDC),
('REGION', 'PUNO', @IdC_FDC);

-- 10. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_FDC, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales, procesos judiciales o denuncias formales hasta la fecha disponible (2026).'
);

GO

/* =====================================================
   REGISTRO INTEGRAL: MARIO ENRIQUE VIZCARRA CORNEJO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PERU PRIMERO')
    INSERT INTO Partido (NombrePartido) VALUES ('PERU PRIMERO');

DECLARE @IdP_MVC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PERU PRIMERO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('MARIO ENRIQUE VIZCARRA CORNEJO', '04411300', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_MVC);

DECLARE @IdC_MVC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','MOQUEGUA','MARISCAL NIETO','MOQUEGUA', @IdC_MVC),
('Domicilio','MOQUEGUA','MARISCAL NIETO','MOQUEGUA', @IdC_MVC);

-- 4. EDUCACIÓN BÁSICA Y UNIVERSITARIA
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_MVC, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UNIVERSIDAD NACIONAL DE INGENIERIA','INGENIERIA INDUSTRIAL', 1, 1978, @IdC_MVC);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad ESAN','MAGISTER EN ADMINISTRACION','MAESTRIA', 1, 2003, @IdC_MVC);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('CyM VIZCARRA SAC','GERENTE ADMINISTRATIVO', 1993, 2017, @IdC_MVC),
('AGROTECNICA ESTUQUIÑA SA.','GERENTE ADMINISTRATIVO', 1998, 2025, @IdC_MVC);

-- 7. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('PARTIDO POLITICO PERU PRIMERO','PARTIDARIO','MIEMBRO DE LA COMISIÓN POLÍTICA NACIONAL', 2025, NULL, @IdC_MVC);

-- 8. RELACIÓN DE SENTENCIAS
INSERT INTO RelacionSentencias (IdCandidato, MateriaDemanda, FalloPena)
VALUES (@IdC_MVC, 'PECULADO', 'PENA PRIVATIVA DE LA LIBERTAD SUSPENDIDA (CONDENA 2005 - REHABILITADO)');

-- 9. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 117684.00, 117684.00, @IdC_MVC);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES
(@IdC_MVC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 181050.00),
(@IdC_MVC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 4595.91),
(@IdC_MVC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 22528.08),
(@IdC_MVC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 17244.05),
(@IdC_MVC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 216476.92),
(@IdC_MVC, 'INMUEBLE', 'DERECHOS MINEROS', 0.00),
(@IdC_MVC, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 10000.00);

-- 10. REDES SOCIALES (TikTok)
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_MVC INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_MVC, @IdRS_MVC, 1, 'mariovizcarrac', 27, 37.6, 190.3);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_MVC, @IdRS_MVC, 1, 'peruprimero_oficial', 165.5, 2400);

-- 11. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
('DISTRITO','VILLA MARÍA DEL TRIUNFO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','CARABAYLLO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','PACHACÁMAC',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','INDEPENDENCIA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','SAN MARTÍN DE PORRES',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','COMAS',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('DISTRITO','SAN MIGUEL',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','HUANCAYO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','MAYNAS',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','TACNA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','AREQUIPA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','CHICLAYO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('PROVINCIA','TRUJILLO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','JUNÍN',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','LORETO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','TACNA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','AREQUIPA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','MOQUEGUA',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','LAMBAYEQUE',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','LA LIBERTAD',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300')),
('REGION','AYACUCHO',(SELECT IdCandidato FROM Candidato WHERE DNI='04411300'));

-- 12. CLASIFICACIÓN LEGAL Y VARIABLES H (N5-ADM)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_MVC, 5, 'ADM', 'N5-ADM', 
    'Condena firme en 2005 por peculado (delito contra la administración pública). Aunque rehabilitado y habilitado por el JNE en 2026, el antecedente es crítico por la naturaleza del cargo.'
);

DECLARE @IdClas_MVC INT = SCOPE_IDENTITY();

-- Variable H2 (Hoja de Vida / Cuestionamientos declarativos)
DECLARE @vH2_MVC INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_MVC, @vH2_MVC, NULL, 'Candidatura inicialmente declarada improcedente por el JEE debido a sentencia de peculado; revocada por el JNE (Res. 0085-2026).');

-- 13. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Panamericana','Mediática','https://panamericana.pe/24horas/locales/462005-elecciones-2026-mario-vizcarra-registra-sentencia-suspendida-corrupcion'),
('Andina','Mediática','https://andina.pe/agencia/noticia-elecciones-2026-jne-confirma-candidaturas-mario-vizcarra-y-rafael-lopez-aliaga-1060245.aspx'),
('Infobae','Mediática','https://www.infobae.com/peru/2026/01/11/mario-vizcarra-excluido-por-condena-por-peculado-jee-dejo-fuera-al-candidato-de-peru-primero-de-la-lista-al-senado/');

GO


/* =====================================================
   REGISTRO INTEGRAL: WALTER GILMER CHIRINOS PURIZAGA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO POLITICO PRIN')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO POLITICO PRIN');

DECLARE @IdP_WCP INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO POLITICO PRIN');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('WALTER GILMER CHIRINOS PURIZAGA', '18870364', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_WCP);

DECLARE @IdC_WCP INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LA LIBERTAD','ASCOPE','PAIJAN', @IdC_WCP),
('Domicilio','LIMA','LIMA','LA MOLINA', @IdC_WCP);

-- 4. EDUCACIÓN (Básica, Técnica y Universitaria)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_WCP, 1, 1, 1);

INSERT INTO EstudiosTecnicos (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('COMPUTRON', 'PROFESIONAL TÉCNICO EN MERCADOTECNIA', 1, @IdC_WCP);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad Privada Telesup S.A.C.', 'CONTADOR PÚBLICO', 1, 2016, @IdC_WCP),
('Universidad Privada Telesup S.A.C.', 'BACHILLER EN CONTABILIDAD Y FINANZAS', 1, 2013, @IdC_WCP);

-- 5. POSGRADO
INSERT INTO Posgrado (CentroEstudio, Especialidad, Concluido, IdCandidato)
VALUES ('UNIVERSIDAD NACIONAL ENRIQUE GUZMAN Y VALLE', 'MAESTRIA EN GESTION PUBLICA', 0, @IdC_WCP);

-- 6. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('MINISTERIO DEL INTERIOR', 'DIRECTOR GENERAL DE GOBIERNO DEL INTERIOR', 2018, 2018, @IdC_WCP);

-- 7. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, IdCandidato)
VALUES 
('PARTIDO POLITICO PRIN', 'PARTIDARIO', 'APODERADO LEGAL', 2022, @IdC_WCP),
('PARTIDO POLITICO PRIN', 'PARTIDARIO', 'FUNDADOR', 2022, @IdC_WCP);

-- 8. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 24000.00, 24000.00, @IdC_WCP);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
(@IdC_WCP, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', 1520.00),
(@IdC_WCP, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 45000.00);

-- 9. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_WCP INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_WCP, @IdRS_WCP, 1, 'walterchirinospurizaga', 2, 2.541, 16.4);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_WCP, @IdRS_WCP, 1, 'partido.politico.oficial', 1288, 7415);

-- 10. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_WCP, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales, procesos judiciales o denuncias formales hasta la fecha (2026).'
);

GO



/* =====================================================
   REGISTRO INTEGRAL: ALFONSO CARLOS ESPA Y GARCES-ALVEAR
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PARTIDO SICREO')
    INSERT INTO Partido (NombrePartido) VALUES ('PARTIDO SICREO');

DECLARE @IdP_ACE INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PARTIDO SICREO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ALFONSO CARLOS ESPA Y GARCES-ALVEAR', '10266270', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_ACE);

DECLARE @IdC_ACE INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','MIRAFLORES', @IdC_ACE),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_ACE);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_ACE, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Pontificia Universidad Católica del Perú', 'BACHILLER EN DERECHO', 1, 1987, @IdC_ACE),
('Pontificia Universidad Católica del Perú', 'ABOGADO', 1, 1987, @IdC_ACE);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Concluido, Grado, AñoObtencion, IdCandidato)
VALUES ('The American University', 'MASTER CIENCIA POLÍTICA', 1, 'MAESTRIA', 1990, @IdC_ACE);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('PRENSA Y CULTURA EMBAJADA DE ESTADOS UNIDOS', 'DIRECTOR DE COMUNICACIONES', 2008, 2023, @IdC_ACE);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, IdCandidato)
VALUES 
('PARTIDO SICREO', 'PARTIDARIO', 'APODERADO', 2023, @IdC_ACE),
('PARTIDO SICREO', 'PARTIDARIO', 'FUNDADOR', 2023, @IdC_ACE);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 105103.00, 105103.00, @IdC_ACE);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_ACE, 'INMUEBLE', 'DEPARTAMENTO', 573759.81),
(@IdC_ACE, 'INMUEBLE', 'ESTACIONAMIENTO', 18917.62),
(@IdC_ACE, 'INMUEBLE', 'ESTACIONAMIENTO', 19852.49),
(@IdC_ACE, 'INMUEBLE', 'ESTACIONAMIENTO', 22877.29),
(@IdC_ACE, 'INMUEBLE', 'DEPOSITO', 3698.39),

-- MUEBLES
(@IdC_ACE, 'MUEBLE', 'CAMIONETA RURAL', 20000.00),
(@IdC_ACE, 'MUEBLE', 'CAMIONETA RURAL', 25000.00);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_ACE INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_ACE, @IdRS_ACE, 1, 'carlosespaoficial', 149, 54.3, 374.9);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_ACE, @IdRS_ACE, 1, 'sicreooficial', 0.516, 0.112);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES 
-- DISTRITO
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_ACE),

-- PROVINCIAS
('PROVINCIA', 'TRUJILLO', @IdC_ACE),
('PROVINCIA', 'HUANCABAMBA', @IdC_ACE),
('PROVINCIA', 'AREQUIPA', @IdC_ACE),

-- REGIONES
('REGION', 'LA LIBERTAD', @IdC_ACE),
('REGION', 'PIURA', @IdC_ACE),
('REGION', 'AREQUIPA', @IdC_ACE),
('REGION', 'LIMA', @IdC_ACE),
('REGION', 'LAMBAYEQUE', @IdC_ACE);

-- 10. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_ACE, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales, procesos judiciales o denuncias formales hasta la fecha (2026).'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: CARLOS ERNESTO JAICO CARRANZA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PERU MODERNO')
    INSERT INTO Partido (NombrePartido) VALUES ('PERU MODERNO');

DECLARE @IdP_CJC INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PERU MODERNO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('CARLOS ERNESTO JAICO CARRANZA', '06529088', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_CJC);

DECLARE @IdC_CJC INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','ANCASH','SANTA','CHIMBOTE', @IdC_CJC),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_CJC);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_CJC, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Concluido, Grado, AñoObtencion, IdCandidato)
VALUES ('Universidad de San Martín de Porres', 1, 'ABOGADO', 2021, @IdC_CJC);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Concluido, Grado, AñoObtencion, IdCandidato)
VALUES 
('UNIVERSITY OF FRIBOURG', 'MÁSTER EN DERECHO', 1, 'MAESTRIA', 2018, @IdC_CJC),
('SWISS BUSSINES SCHOOL', 'MBA', 1, 'MAESTRIA', 2004, @IdC_CJC);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('ALPAXOR S.A.C.', 'GERENTE GENERAL', 2024, 2025, @IdC_CJC),
('CARLOS ERNESTO JAICO CARRANZA', 'ABOGADO INDEPENDIENTE', 2022, 2025, @IdC_CJC),
('DESPACHO PRESIDENCIAL', 'SECRETARIO GENERAL', 2021, 2022, @IdC_CJC),
('CONGRESO DE LA REPUBLICA DEL PERU', 'ASESOR PARLAMENTARIO', 2020, 2021, @IdC_CJC),
('UNIVERSIDAD TECMILENIO', 'PROFESOR DE CATEDRA', 2014, 2018, @IdC_CJC);

-- 6. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 47158.00, 47158.00, @IdC_CJC);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES (@IdC_CJC, 'INMUEBLE', 'REGISTRO DE PREDIOS', 45426.58);

-- 7. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_CJC INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_CJC, @IdRS_CJC, 1, 'carlosjaicooficial', 105, 0.927, 8.012);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_CJC, @IdRS_CJC, 1, 'perumodernooficial', 1.081, 3.088);

-- 8. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- DISTRITOS
('DISTRITO', 'CERCADO DE LIMA', @IdC_CJC),
('DISTRITO', 'LA VICTORIA', @IdC_CJC),
('DISTRITO', 'CARABAYLLO', @IdC_CJC),
('DISTRITO', 'COMAS', @IdC_CJC),
('DISTRITO', 'RÍMAC', @IdC_CJC),
('DISTRITO', 'SAN JUAN DE MIRAFLORES', @IdC_CJC),

-- PROVINCIAS
('PROVINCIA', 'CAJAMARCA', @IdC_CJC),
('PROVINCIA', 'HUARAL', @IdC_CJC),
('PROVINCIA', 'SANTA', @IdC_CJC),
('PROVINCIA', 'HUANCAYO', @IdC_CJC),
('PROVINCIA', 'CHINCHA', @IdC_CJC),
('PROVINCIA', 'CALLAO', @IdC_CJC),

-- REGIONES
('REGION', 'CAJAMARCA', @IdC_CJC),
('REGION', 'LIMA', @IdC_CJC),
('REGION', 'ÁNCASH', @IdC_CJC),
('REGION', 'JUNÍN', @IdC_CJC),
('REGION', 'ICA', @IdC_CJC);

-- 9. CLASIFICACIÓN LEGAL Y VARIABLES H (N2-B)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_CJC, 2, 'B', 'N2-B', 
    'Investigación preliminar por presunto uso irregular de vehículo oficial durante periodos de licencia en 2022. Caso derivado a la Fiscalía Anticorrupción.'
);

DECLARE @IdClas_CJC INT = SCOPE_IDENTITY();

-- Variables H3 (Neutralidad/Recursos) y H5 (Vinculación indirecta)
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');
DECLARE @vH5 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H5');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_CJC, @vH3, NULL, 'Intervención fiscal en Palacio por presunto uso de bienes del Estado en beneficio personal.'),
(@IdClas_CJC, @vH5, NULL, 'Cuestionamientos públicos por reunión extraoficial con directivos de Repsol tras derrame de petróleo.');

-- 10. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('La República - Repsol', 'Mediática', 'https://larepublica.pe/politica/2022/01/28/derrame-de-petroleo-secretario-presidencial-carlos-jaico-se-reunio-con-repsol-fuera-de-palacio-de-gobierno-pedro-castillo'),
('Diario Correo - Vehículo', 'Mediática', 'https://diariocorreo.pe/politica/pedro-castillo-investigan-a-secretario-general-del-despacho-presidencial-por-uso-indebido-de-un-vehiculo-oficial-del-estado-nndc-noticia/');

GO


/* =====================================================
   REGISTRO INTEGRAL: JOSÉ LEÓN LUNA GÁLVEZ
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PODEMOS PERU')
    INSERT INTO Partido (NombrePartido) VALUES ('PODEMOS PERU');

DECLARE @IdP_JLG INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PODEMOS PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('JOSE LEON LUNA GALVEZ', '07246887', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_JLG);

DECLARE @IdC_JLG INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_JLG),
('Domicilio','LIMA','LIMA','SANTIAGO DE SURCO', @IdC_JLG);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_JLG, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad de San Martín de Porres','ECONOMISTA', 1, 2000, @IdC_JLG),
('Universidad de San Martín de Porres','BACHILLER EN CIENCIAS ECONÓMICAS', 1, 2000, @IdC_JLG);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES
('Universidad de San Martín de Porres','DOCTOR EN EDUCACIÓN','DOCTORADO', 1, 2005, @IdC_JLG),
('Universidad de San Martín de Porres','MAESTRO EN ECONOMÍA','MAESTRÍA', 1, 2004, @IdC_JLG);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('CONGRESO DE LA REPUBLICA','CONGRESISTA', 2021, 2025, @IdC_JLG),
('INSTITUTO INTUR PERU E.I.R.L','ASESOR', 2011, 2025, @IdC_JLG),
('SABIO ANTUNEZ DE MAYOLO E.I.R.L.','ASESOR', 2023, 2025, @IdC_JLG),
('UNIVERSIDAD PRIVADA TELESUP S.A.C.','ASESOR', 2020, 2025, @IdC_JLG);

-- 6. CARGOS (Partidarios y Elección Popular)
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PODEMOS PERU','PARTIDARIO','FUNDADOR', 2017, NULL, @IdC_JLG),
('PODEMOS PERU','PARTIDARIO','PRESIDENTE FUNDADOR', 2021, NULL, @IdC_JLG),
('ALIANZA SOLIDARIDAD NACIONAL','ELECCION_POPULAR','CONGRESISTA', 2011, 2016, @IdC_JLG),
('PODEMOS PERU','ELECCION_POPULAR','CONGRESISTA', 2021, 2025, @IdC_JLG);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (339848.64, 11069190.00, 11409038.64, @IdC_JLG);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES
-- INMUEBLES
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 267520.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 455911.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 176871.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 461500.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 774675.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 431720.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 151627.50),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 17000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 17000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 12000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 12000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 10000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 10000.00),
(@IdC_JLG, 'INMUEBLE', 'REGISTRO DE PREDIOS', 14881500.00),
(@IdC_JLG, 'INMUEBLE', 'PROPIEDAD', 12736000.00),

-- MUEBLES
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 1.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 1.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 52000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 47700.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 15000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 15000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 15000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 15000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 15000.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 79500.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 78500.00),
(@IdC_JLG, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 268312.20);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_JLG INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_JLG, @IdRS_JLG, 1, 'joseluna609', 16, 0.24, 1.86);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_JLG, @IdRS_JLG, 1, 'podemosperuoficial', 45.7, 523.4);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- DISTRITO
('DISTRITO', 'ATE', @IdC_JLG),

-- PROVINCIAS
('PROVINCIA', 'PIURA', @IdC_JLG),
('PROVINCIA', 'HUANCAVELICA', @IdC_JLG),
('PROVINCIA', 'CUSCO', @IdC_JLG),

-- REGIONES
('REGION', 'PIURA', @IdC_JLG),
('REGION', 'APURÍMAC', @IdC_JLG),
('REGION', 'HUANCAVELICA', @IdC_JLG),
('REGION', 'CUSCO', @IdC_JLG);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H (N4-M)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_JLG, 4, 'M', 'N4-M', 
    'Investigación fiscal relevante / acusación por delitos graves'
);

DECLARE @IdClas_JLG INT = SCOPE_IDENTITY();

-- Variables H1 (Financiamiento), H4 (Controversia Patrimonial/Educativa) y H9 (Medidas Judiciales)
DECLARE @vH1 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H1');
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_JLG, @vH1, NULL, 'Financiamiento o conflicto de interés.'),
(@IdClas_JLG, @vH3, NULL, 'Neutralidad / uso de recursos públicos');

-- 11. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Infobae', 'Mediática', 'https://www.infobae.com/peru/2025/05/28/jose-luna-galvez-sufre-reves-pj-revoca-sentencia-a-su-favor-y-mantiene-intactas-las-investigaciones-en-su-contra/#:~:text=Per%C3%BA-,Jos%C3%A9%20Luna%20G%C3%A1lvez%20pierde:%20PJ%20revoca%20sentencia%20que%20anul%C3%B3,investigaciones%20fiscales%20en%20su%20contra'),
('Infobae', 'Mediática', 'https://www.infobae.com/peru/2025/12/10/jose-luna-galvez-apela-decision-que-rechazo-anular-acusacion-por-caso-podemos-peru-fiscalia-pide-mas-de-22-anos-de-carcel/#:~:text=Per%C3%BA-,Jos%C3%A9%20Luna%20G%C3%A1lvez%20apela%20decisi%C3%B3n%20que%20rechaz%C3%B3%20anular%20acusaci%C3%B3n%20por,de%2022%20a%C3%B1os%20de%20c%C3%A1rcel');

GO



/* =====================================================
   REGISTRO INTEGRAL: MARÍA SOLEDAD PEREZ TELLO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PRIMERO LA GENTE - COMUNIDAD, ECOLOGIA, LIBERTAD Y PROGRESO')
    INSERT INTO Partido (NombrePartido) VALUES ('PRIMERO LA GENTE - COMUNIDAD, ECOLOGIA, LIBERTAD Y PROGRESO');

DECLARE @IdP_MPT INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PRIMERO LA GENTE - COMUNIDAD, ECOLOGIA, LIBERTAD Y PROGRESO');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('MARIA SOLEDAD PEREZ TELLO DE RODRIGUEZ', '07867789', 'Femenino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_MPT);

DECLARE @IdC_MPT INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','TACNA','JORGE BASADRE','ILABAYA', @IdC_MPT),
('Domicilio','LIMA','LIMA','SANTIAGO DE SURCO', @IdC_MPT);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_MPT, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad de San Martín de Porres','ABOGADO', 1, 1995, @IdC_MPT),
('Universidad de San Martín de Porres','BACHILLER EN DERECHO', 1, 1995, @IdC_MPT);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Concluido, IdCandidato)
VALUES ('PONTIFICIA UNIVERSIDAD CATOLICA DEL PERU','MAESTRIA EN DERECHO CONSTITUCIONAL', 1, @IdC_MPT);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('NOTARIA PEREZ TELLO','NOTARIA', 1999, 2025, @IdC_MPT),
('UNIVERSIDAD SAN MARTIN DE PORRES','DOCENTE FACULTAD DE DERECHO', 1996, 2020, @IdC_MPT),
('MINISTERIO DE JUSTICIA Y DERECHOS HUMANOS','MINISTRA DE JUSTICIA', 2016, 2017, @IdC_MPT),
('CONGRESO DE LA REPUBLICA','CONGRESISTA', 2011, 2016, @IdC_MPT);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PARTIDO POPULAR CRISTIANO - PPC','PARTIDARIO','SECRETARIO GENERAL NACIONAL', 2017, 2021, @IdC_MPT),
('PARTIDO POPULAR CRISTIANO - PPC','PARTIDARIO','SECRETARÍA NACIONAL ESTRUCTURAL', 2007, 2011, @IdC_MPT);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 4500000.00, 4500000.00, @IdC_MPT);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_MPT, 'INMUEBLE', 'REGISTRO DE PREDIOS', 500000.00),
(@IdC_MPT, 'INMUEBLE', 'REGISTRO DE PREDIOS', 7000.00),
(@IdC_MPT, 'INMUEBLE', 'SECCION ESPECIAL DE PREDIOS RURALES', 15000.00),

-- MUEBLES
(@IdC_MPT, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 2000.00),
(@IdC_MPT, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 170000.00),
(@IdC_MPT, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 70000.00),
(@IdC_MPT, 'MUEBLE', 'CAMIONETA', 70000.00);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TikTok')
    INSERT INTO RedSocial (NombreRed) VALUES ('TikTok');

DECLARE @IdRS_MPT INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TikTok');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_MPT, @IdRS_MPT, 1, 'pereztellomarisol', 85, 24.4, 456.1);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_MPT, @IdRS_MPT, 0, 'No tiene según página web');

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- PROVINCIAS
('PROVINCIA', 'CALCA', @IdC_MPT),
('PROVINCIA', 'VÍCTOR FAJARDO', @IdC_MPT),
('PROVINCIA', 'VILCAS HUAMÁN', @IdC_MPT),
('PROVINCIA', 'CHINCHA', @IdC_MPT),
('PROVINCIA', 'HUARMEY', @IdC_MPT),
('PROVINCIA', 'TRUJILLO', @IdC_MPT),
('PROVINCIA', 'MAYNAS', @IdC_MPT),

-- REGIONES
('REGION', 'CUSCO', @IdC_MPT),
('REGION', 'AYACUCHO', @IdC_MPT),
('REGION', 'ICA', @IdC_MPT),
('REGION', 'ÁNCASH', @IdC_MPT),
('REGION', 'LA LIBERTAD', @IdC_MPT),
('REGION', 'LORETO', @IdC_MPT);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H (N1-A1)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_MPT, 1, 'A1', 'N1-A1', 
    'Cuestionamientos mediáticos por presunta falsificación de firmas en la inscripción del partido Primero La Gente (2025). No tiene investigación directa.'
);

DECLARE @IdClas_MPT INT = SCOPE_IDENTITY();

-- Selección de Variables Madre
DECLARE @vH5 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H5'); -- Vinculación
DECLARE @vH8 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H8'); -- Acciones Legales

-- Selección de Subvariable específica para H8
-- Buscamos el IdSubVariable donde el código sea 'A' y pertenezca a la variable H8
DECLARE @sH8A INT = (SELECT IdSubVariable FROM SubVariable WHERE IdVariable=@vH8 AND Codigo='A'); 

-- Inserción con validación de Subvariable
INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_MPT, @vH5, NULL, 'Vínculo con el personero legal del partido investigado por presunta "fábrica de firmas".'),
(@IdClas_MPT, @vH8, @sH8A, 'La candidata interpuso denuncia penal por tráfico de datos y falsificación contra los que resulten responsables (Acción proactiva).');

-- 11. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('Infobae - Firmas', 'Mediática', 'https://www.infobae.com/peru/2025/05/15/elecciones-2026-fiscalia-investiga-a-partido-primero-la-gente-por-presunta-fabrica-de-firmas-falsas/'),
('Infobae - Inscripción', 'Mediática', 'https://www.infobae.com/peru/2026/01/20/marisol-perez-tello-queda-oficialmente-inscrita-como-candidata-presidencial-para-las-elecciones-2026/');

GO


/* =====================================================
   REGISTRO INTEGRAL: PAUL DAVIS JAIMES BLANCO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'PROGRESEMOS')
    INSERT INTO Partido (NombrePartido) VALUES ('PROGRESEMOS');

DECLARE @IdP_PJB INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='PROGRESEMOS');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('PAUL DAVIS JAIMES BLANCO', '40139245', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, DIPUTADO', @IdP_PJB);

DECLARE @IdC_PJB INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','JESUS MARIA', @IdC_PJB),
('Domicilio','LIMA','LIMA','RIMAC', @IdC_PJB);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_PJB, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad de San Martín de Porres','BACHILLER EN DERECHO Y CIENCIA POLÍTICA', 1, 2004, @IdC_PJB),
('Universidad de San Martín de Porres','ABOGADO', 1, 2009, @IdC_PJB);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('UNIVERSIDAD SAN MARTÍN DE PORRES','GOBIERNO Y GESTIÓN PÚBLICA', NULL, 1, NULL, @IdC_PJB);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('CONGRESO DE LA REPÚBLICA', 'ASESOR I', 2022, 2025, @IdC_PJB);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('PROGRESEMOS','PARTIDARIO','FUNDADOR', 2024, NULL, @IdC_PJB),
('PROGRESEMOS','PARTIDARIO','PRESIDENTE', 2024, NULL, @IdC_PJB);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (253900.00, 9600.00, 263500.00, @IdC_PJB);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
-- INMUEBLES
(@IdC_PJB, 'INMUEBLE', 'REGISTRO DE PREDIOS', 405000.00),
(@IdC_PJB, 'INMUEBLE', 'REGISTRO DE PREDIOS', 67000.00),
(@IdC_PJB, 'INMUEBLE', 'PREDIO RURAL', 600000.00),
(@IdC_PJB, 'INMUEBLE', 'PREDIO RURAL', 100396.10),

-- MUEBLES
(@IdC_PJB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 13000.00),
(@IdC_PJB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 155161.99);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed='TIKTOK') 
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_PJB INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed='TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_PJB, @IdRS_PJB, 1, 'pauljaimesprogresemos', 234, 139.3, 553.1);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario,Seguidores, Likes)
VALUES (@IdP_PJB, @IdRS_PJB, 1, 'progresemosoficial', 12.2, 48.6);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- DISTRITOS
('DISTRITO', 'SAN JUAN DE LURIGANCHO', @IdC_PJB),
('DISTRITO', 'RÍMAC', @IdC_PJB),
('DISTRITO', 'CERCADO DE LIMA', @IdC_PJB),

-- PROVINCIAS
('PROVINCIA', 'ILO', @IdC_PJB),
('PROVINCIA', 'AREQUIPA', @IdC_PJB),
('PROVINCIA', 'TAMBOPATA', @IdC_PJB),
('PROVINCIA', 'JAUJA', @IdC_PJB),
('PROVINCIA', 'CHINCHA', @IdC_PJB),
('PROVINCIA', 'PIURA', @IdC_PJB),
('PROVINCIA', 'CUSCO', @IdC_PJB),
('PROVINCIA', 'TALARA', @IdC_PJB),
('PROVINCIA', 'LA CONVENCIÓN', @IdC_PJB),
('PROVINCIA', 'ABANCAY', @IdC_PJB),
('PROVINCIA', 'MARISCAL NIETO', @IdC_PJB),
('PROVINCIA', 'PISCO', @IdC_PJB),
('PROVINCIA', 'ICA', @IdC_PJB),
('PROVINCIA', 'PALPA', @IdC_PJB),
('PROVINCIA', 'NAZCA', @IdC_PJB),
('PROVINCIA', 'URUBAMBA', @IdC_PJB),
('PROVINCIA', 'ESPINAR', @IdC_PJB),
('PROVINCIA', 'ANTA', @IdC_PJB),
('PROVINCIA', 'ANDAHUAYLAS', @IdC_PJB),
('PROVINCIA', 'LUCANAS', @IdC_PJB),
('PROVINCIA', 'BARRANCA', @IdC_PJB),
('PROVINCIA', 'CAÑETE', @IdC_PJB),

-- REGIONES
('REGION', 'MOQUEGUA', @IdC_PJB),
('REGION', 'AREQUIPA', @IdC_PJB),
('REGION', 'JUNÍN', @IdC_PJB),
('REGION', 'MADRE DE DIOS', @IdC_PJB),
('REGION', 'PIURA', @IdC_PJB),
('REGION', 'CUSCO', @IdC_PJB),
('REGION', 'APURÍMAC', @IdC_PJB),
('REGION', 'AYACUCHO', @IdC_PJB),
('REGION', 'UCAYALI', @IdC_PJB),
('REGION', 'LIMA', @IdC_PJB);

-- 10. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_PJB, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales, procesos judiciales o denuncias formales hasta la fecha (2026).'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: ANTONIO ORTIZ VILLANO
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'SALVEMOS AL PERU')
    INSERT INTO Partido (NombrePartido) VALUES ('SALVEMOS AL PERU');

DECLARE @IdP_AOV INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='SALVEMOS AL PERU');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ANTONIO ORTIZ VILLANO', '08587486', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA', @IdP_AOV);

DECLARE @IdC_AOV INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','APURIMAC','ANDAHUAYLAS','TALAVERA', @IdC_AOV),
('Domicilio','LIMA','LIMA','SAN MARTIN DE PORRES', @IdC_AOV);

-- 4. EDUCACIÓN (Básica, Técnica y No Universitaria)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_AOV, 1, 1, 0);

INSERT INTO EstudiosTecnicos (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('PUCP', 'HABILIDADES GERENCIALES', 1, @IdC_AOV);

INSERT INTO EstudiosNoUniversitarios (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('COLLEGE OF PROFESSIONAL STUDIES', 'I-WEEK PROGRAM EN COMUNICACION POLITICA', 1, @IdC_AOV);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('IMPORTADORA Y DISTRIBUIDORA DE RETENES RODAMIENTOS Y AFINES (IDRE) S.A', 'GERENTE GENERAL', 1999, 2025, @IdC_AOV),
('KMK HIDRAULICA Y SERVICIOS S.A', 'GERENTE GENERAL', 2005, 2025, @IdC_AOV),
('TONSAN DEL PERU S.A.', 'GERENTE GENERAL', 2010, 2025, @IdC_AOV);

-- 6. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 221634.00, 221634.00, @IdC_AOV);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
(@IdC_AOV, 'INMUEBLE', 'REGISTRO DE PREDIOS', 277628.87),
(@IdC_AOV, 'INMUEBLE', 'REGISTRO DE PREDIOS', 169000.00),
(@IdC_AOV, 'INMUEBLE', 'REGISTRO DE PREDIOS', 20000.00),
(@IdC_AOV, 'INMUEBLE', 'REGISTRO DE PREDIOS', 20000.00),
(@IdC_AOV, 'INMUEBLE', 'TERRENO', 0.00),
(@IdC_AOV, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 10000.00);

-- 7. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed = 'TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_AOV INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed = 'TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_AOV, @IdRS_AOV, 1, 'antonio_ortiz_presidente', 14, 0.131, 0.4);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdP_AOV, @IdRS_AOV, 0, 'Varios (no oficial)');

-- 8. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
('PROVINCIA','CUSCO', @IdC_AOV),
('PROVINCIA','ICA', @IdC_AOV),
('REGION','CUSCO', @IdC_AOV),
('REGION','ICA', @IdC_AOV);

-- 9. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_AOV, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales o procesos judiciales hasta la fecha (2026).'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: ROSARIO DEL PILAR FERNÁNDEZ BAZÁN
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'UN CAMINO DIFERENTE')
    INSERT INTO Partido (NombrePartido) VALUES ('UN CAMINO DIFERENTE');

DECLARE @IdP_RFB INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='UN CAMINO DIFERENTE');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ROSARIO DEL PILAR FERNANDEZ BAZAN', '18141156', 'Femenino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_RFB);

DECLARE @IdC_RFB INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LA LIBERTAD','TRUJILLO','TRUJILLO', @IdC_RFB),
('Domicilio','LA LIBERTAD','TRUJILLO','TRUJILLO', @IdC_RFB);

-- 4. EDUCACIÓN (Básica, Técnica y Universitaria)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RFB, 1, 1, 1);

INSERT INTO EstudiosTecnicos (CentroEstudio, Carrera, Concluido, IdCandidato)
VALUES ('INSTITUTO PEDAGÓGICO INDOAMÉRICA', 'EDUCACIÓN INICIAL', 1, @IdC_RFB);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad Privada César Vallejo', 'BACHILLER EN EDUCACIÓN', 1, 2001, @IdC_RFB);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('IEP JAN KOMESKY', 'DOCENTE', 2005, 2025, @IdC_RFB);

-- 6. CARGOS PARTIDARIOS
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('UN CAMINO DIFERENTE','PARTIDARIO','FUNDADOR', 2024, NULL, @IdC_RFB),
('UN CAMINO DIFERENTE','PARTIDARIO','PERSONERO LEGAL ALTERNO', 2024, 2025, @IdC_RFB);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 36520.00, 36520.00, @IdC_RFB);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
(@IdC_RFB, 'INMUEBLE', 'REGISTRO DE PREDIOS', 10387.85),
(@IdC_RFB, 'INMUEBLE', 'REGISTRO DE PREDIOS', 98761.50),
(@IdC_RFB, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 35000.00);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed = 'TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_RFB INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed = 'TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, MotivoNoTiene)
VALUES (@IdC_RFB, @IdRS_RFB, 0, 'No registra usuario');

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RFB, @IdRS_RFB, 1, 'uncaminodiferente.oficial', 8.957, 86.3);

-- 9. CLASIFICACIÓN LEGAL Y VARIABLES H (N2-B)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RFB, 2, 'B', 'N2-B', 
    'Investigación preliminar por presunta participación en disturbios y daños a la sede judicial de Trujillo en 2025. Denunciada por la Corte Superior de La Libertad.'
);

DECLARE @IdClas_RFB INT = SCOPE_IDENTITY();

-- Variables H6 (Protestas/Conductas Conflictivas) y H5 (Vinculación Indirecta)
DECLARE @vH6 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H6');
DECLARE @vH5 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H5');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_RFB, @vH6, NULL, 'Participación activa en protestas con agresiones a la PNP y daños materiales a infraestructura del Estado.'),
(@IdClas_RFB, @vH5, NULL, 'Fórmula presidencial incluye a su hermano César Arturo Fernández Bazán, quien tiene sentencia vigente y condición de prófugo.');

-- 10. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES ('Infobae - Denuncia Judicial', 'Mediática', 'https://www.infobae.com/peru/2025/12/19/rosario-fernandez-candidata-que-se-nego-a-firmar-pacto-etico-electoral-fue-denunciada-por-agredir-a-la-pnp-y-tirar-huevos-a-sede-judicial/#:~:text=Per%C3%BA-,Rosario%20Fern%C3%A1ndez%2C%20candidata%20que%20se%20neg%C3%B3%20a%20firmar%20Pacto%20%C3%89tico,tirar%20huevos%20a%20sede%20judicial');

GO



/* =====================================================
   REGISTRO INTEGRAL: ROBERTO ENRIQUE CHIABRA LEÓN
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'UNIDAD NACIONAL')
    INSERT INTO Partido (NombrePartido) VALUES ('UNIDAD NACIONAL');

DECLARE @IdP_RCL INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='UNIDAD NACIONAL');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('ROBERTO ENRIQUE CHIABRA LEON', '40728264', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_RCL);

DECLARE @IdC_RCL INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','CALLAO','CALLAO','BELLAVISTA', @IdC_RCL),
('Domicilio','LIMA','LIMA','SANTIAGO DE SURCO', @IdC_RCL);

-- 4. EDUCACIÓN (Básica y Universitaria)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RCL, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Escuela Militar de Chorrillos “Coronel Francisco Bolognesi”','BACHILLER EN CIENCIAS MILITARES', 1, 2012, @IdC_RCL),
('Escuela Militar de Chorrillos “Coronel Francisco Bolognesi”','LICENCIADO EN CIENCIAS MILITARES', 1, 2012, @IdC_RCL);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES ('CONGRESO DE LA REPUBLICA', 'CONGRESISTA', 2021, 2025, @IdC_RCL);

-- 6. CARGOS (Partidarios y Elección Popular)
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('UNIDAD NACIONAL','PARTIDARIO','PRESIDENTE DEL COMITÉ EJECUTIVO', 2025, NULL, @IdC_RCL),
('PARTIDO UNIDAD Y PAZ','PARTIDARIO','COMITÉ POLÍTICO NACIONAL - PRESIDENTE', 2023, NULL, @IdC_RCL),
('ALIANZA PARA EL PROGRESO','ELECCION_POPULAR','CONGRESISTA', 2021, 2025, @IdC_RCL);

-- 7. INGRESOS Y BIENES
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (320676.00, 0.00, 320676.00, @IdC_RCL);

INSERT INTO Bien (IdCandidato, TipoBien, Registro, ValorAutovaluo)
VALUES 
(@IdC_RCL, 'INMUEBLE', 'PREDIO', 288251.84),
(@IdC_RCL, 'INMUEBLE', 'PREDIO', 63215.98),
(@IdC_RCL, 'MUEBLE', 'REGISTRO DE PROPIEDAD VEHICULAR', 93573.00);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed = 'TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_RCL INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed = 'TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RCL, @IdRS_RCL, 1, 'chiabrallego', 79, 1573, 22.1);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RCL, @IdRS_RCL, 1, 'chiabrapresidente2026', 1.34, 10.2);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- PROVINCIAS
('PROVINCIA', 'CAÑETE', @IdC_RCL),
('PROVINCIA', 'PISCO', @IdC_RCL),
('PROVINCIA', 'ICA', @IdC_RCL),
('PROVINCIA', 'TUMBES', @IdC_RCL),
('PROVINCIA', 'SULLANA', @IdC_RCL),
('PROVINCIA', 'PIURA', @IdC_RCL),
('PROVINCIA', 'MORROPÓN', @IdC_RCL),
('PROVINCIA', 'LAMBAYEQUE', @IdC_RCL),
('PROVINCIA', 'CHICLAYO', @IdC_RCL),
('PROVINCIA', 'FERREÑAFE', @IdC_RCL),
('PROVINCIA', 'PACASMAYO', @IdC_RCL),
('PROVINCIA', 'VIRÚ', @IdC_RCL),
('PROVINCIA', 'TRUJILLO', @IdC_RCL),
('PROVINCIA', 'TACNA', @IdC_RCL),
('PROVINCIA', 'ILO', @IdC_RCL),
('PROVINCIA', 'ISLAY', @IdC_RCL),
('PROVINCIA', 'CAMANÁ', @IdC_RCL),
('PROVINCIA', 'AREQUIPA', @IdC_RCL),
('PROVINCIA', 'CAYLLOMA', @IdC_RCL),
('PROVINCIA', 'HUANCAYO', @IdC_RCL),

-- REGIONES
('REGION', 'LIMA', @IdC_RCL),
('REGION', 'ICA', @IdC_RCL),
('REGION', 'TUMBES', @IdC_RCL),
('REGION', 'PIURA', @IdC_RCL),
('REGION', 'LAMBAYEQUE', @IdC_RCL),
('REGION', 'LA LIBERTAD', @IdC_RCL),
('REGION', 'TACNA', @IdC_RCL),
('REGION', 'AREQUIPA', @IdC_RCL),
('REGION', 'JUNÍN', @IdC_RCL);

-- 10. CLASIFICACIÓN LEGAL (Nivel 0)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RCL, 0, NULL, 'N0', 
    'Sin información relevante. No se registran investigaciones fiscales o procesos judiciales hasta la fecha (2026).'
);

GO


/* =====================================================
   REGISTRO INTEGRAL: RAFAEL LÓPEZ ALIAGA
===================================================== */

-- 1. PARTIDO
IF NOT EXISTS (SELECT 1 FROM Partido WHERE NombrePartido = 'RENOVACION POPULAR')
    INSERT INTO Partido (NombrePartido) VALUES ('RENOVACION POPULAR');

DECLARE @IdP_RLA INT = (SELECT IdPartido FROM Partido WHERE NombrePartido='RENOVACION POPULAR');

-- 2. CANDIDATO
INSERT INTO Candidato (NombreCompleto, DNI, Sexo, CargoPostula, IdPartido)
VALUES ('RAFAEL BERNARDO LÓPEZ ALIAGA CAZORLA', '07845838', 'Masculino', 'PRESIDENTE DE LA REPÚBLICA, SENADOR', @IdP_RLA);

DECLARE @IdC_RLA INT = SCOPE_IDENTITY();

-- 3. UBICACIONES
INSERT INTO Ubicacion (Tipo, Departamento, Provincia, Distrito, IdCandidato) 
VALUES 
('Nacimiento','LIMA','LIMA','LIMA', @IdC_RLA),
('Domicilio','LIMA','LIMA','SAN ISIDRO', @IdC_RLA);

-- 4. EDUCACIÓN (Básica, Universitaria y Posgrado)
INSERT INTO EducacionBasica (IdCandidato, TieneEducacionBasica, TienePrimaria, TieneSecundaria)
VALUES (@IdC_RLA, 1, 1, 1);

INSERT INTO EducacionUniversitaria (Universidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES 
('Universidad de Piura','INGENIERO INDUSTRIAL', 1, 1995, @IdC_RLA),
('Universidad de Piura','BACHILLER EN CIENCIAS DE LA INGENIERÍA', 1, NULL, @IdC_RLA);

INSERT INTO Posgrado (CentroEstudio, Especialidad, Grado, Concluido, AñoObtencion, IdCandidato)
VALUES ('Universidad del Pacífico','MAGÍSTER EN ADMINISTRACIÓN','MAESTRÍA', 1, NULL, @IdC_RLA);

-- 5. EXPERIENCIA LABORAL
INSERT INTO ExperienciaLaboral (CentroTrabajo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('MUNICIPALIDAD METROPOLITANA DE LIMA','ALCALDE', 2023, 2025, @IdC_RLA),
('UNIVERSIDAD NACIONAL DE INGENIERÍA','CATEDRÁTICO', 2017, 2020, @IdC_RLA),
('PERURAIL S.A.','DIRECTOR', 1999, 2022, @IdC_RLA),
('PERU BELMOND HOTELS S.A.','DIRECTOR', 1990, 2022, @IdC_RLA),
('FERROCARRIL TRASANDINO S.A.','DIRECTOR', 1999, 2022, @IdC_RLA);

-- 6. CARGOS (Partidarios y Elección Popular)
INSERT INTO CargoPartidario (Organizacion, TipoCargo, Cargo, AnioInicio, AnioFin, IdCandidato)
VALUES
('RENOVACION POPULAR','PARTIDARIO','PRESIDENTE', 2025, NULL, @IdC_RLA),
('RENOVACION POPULAR','PARTIDARIO','REPRESENTANTE LEGAL', 2019, 2022, @IdC_RLA),
('ALIANZA ELECTORAL UNIDAD NACIONAL','ELECCION_POPULAR','REGIDOR PROVINCIAL', 2007, 2010, @IdC_RLA),
('RENOVACION POPULAR','ELECCION_POPULAR','ALCALDE PROVINCIAL', 2022, 2025, @IdC_RLA);

-- 7. INGRESOS
INSERT INTO Ingresos (RemuneracionPublica, RemuneracionPrivada, Total, IdCandidato)
VALUES (0.00, 1897374.00, 1897374.00, @IdC_RLA);

-- 8. REDES SOCIALES
IF NOT EXISTS (SELECT 1 FROM RedSocial WHERE NombreRed = 'TIKTOK')
    INSERT INTO RedSocial (NombreRed) VALUES ('TIKTOK');

DECLARE @IdRS_RLA INT = (SELECT IdRedSocial FROM RedSocial WHERE NombreRed = 'TIKTOK');

INSERT INTO CandidatoRedSocial (IdCandidato, IdRedSocial, Tiene, Usuario, CantidadVideos, Seguidores, Likes)
VALUES (@IdC_RLA, @IdRS_RLA, 1, 'rafael_lopez_aliaga', 246, 849.5, 31100);

INSERT INTO PartidoRedSocial (IdPartido, IdRedSocial, Tiene, Usuario, Seguidores, Likes)
VALUES (@IdP_RLA, @IdRS_RLA, 1, 'renovacionpopularoficial', 33.3, 399.7);

-- 9. VISITAS DE CAMPAÑA
INSERT INTO VisitaCampaña (TipoLugar, NombreLugar, IdCandidato)
VALUES
-- DISTRITOS
('DISTRITO', 'LA VICTORIA', @IdC_RLA),
('DISTRITO', 'PUENTE PIEDRA', @IdC_RLA),
('DISTRITO', 'LURIGANCHO-CHOSICA', @IdC_RLA),

-- PROVINCIAS
('PROVINCIA', 'ICA', @IdC_RLA),
('PROVINCIA', 'SAN MARTÍN', @IdC_RLA),
('PROVINCIA', 'TRUJILLO', @IdC_RLA),
('PROVINCIA', 'OTUZCO', @IdC_RLA),
('PROVINCIA', 'CHICLAYO', @IdC_RLA),
('PROVINCIA', 'PIURA', @IdC_RLA),
('PROVINCIA', 'TUMBES', @IdC_RLA),
('PROVINCIA', 'HUARAZ', @IdC_RLA),
('PROVINCIA', 'HUANCAYO', @IdC_RLA),
('PROVINCIA', 'MOYOBAMBA', @IdC_RLA),
('PROVINCIA', 'AREQUIPA', @IdC_RLA),
('PROVINCIA', 'PUNO', @IdC_RLA),
('PROVINCIA', 'TACNA', @IdC_RLA),
('PROVINCIA', 'HUÁNUCO', @IdC_RLA),
('PROVINCIA', 'MAYNAS', @IdC_RLA),
('PROVINCIA', 'CORONEL PORTILLO', @IdC_RLA),

-- REGIONES
('REGION', 'ICA', @IdC_RLA),
('REGION', 'SAN MARTÍN', @IdC_RLA),
('REGION', 'LA LIBERTAD', @IdC_RLA),
('REGION', 'LAMBAYEQUE', @IdC_RLA),
('REGION', 'PIURA', @IdC_RLA),
('REGION', 'TUMBES', @IdC_RLA),
('REGION', 'ÁNCASH', @IdC_RLA),
('REGION', 'JUNÍN', @IdC_RLA),
('REGION', 'AREQUIPA', @IdC_RLA),
('REGION', 'TACNA', @IdC_RLA),
('REGION', 'HUÁNUCO', @IdC_RLA),
('REGION', 'LORETO', @IdC_RLA),
('REGION', 'UCAYALI', @IdC_RLA);

-- 10. CLASIFICACIÓN LEGAL Y VARIABLES H (N2-A)
INSERT INTO ClasificacionLegalPenal (IdCandidato, NivelPrincipal, SubNivel, CodigoCompleto, Justificacion)
VALUES (
    @IdC_RLA, 2, 'A', 'N2-A', 
    'Infracción al principio de neutralidad electoral confirmada por el JNE (2025) y controversia tributaria por deuda coactiva de empresa Peruval Corp S.A.'
);

DECLARE @IdClas_RLA INT = SCOPE_IDENTITY();

-- Variables H3 (Neutralidad), H4 (Tributaria/Empresarial) y H2 (Elegibilidad)
DECLARE @vH3 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H3');
DECLARE @vH4 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H4');
DECLARE @vH2 INT = (SELECT IdVariable FROM VariableSecundaria WHERE Codigo='H2');

INSERT INTO ClasificacionVariable (IdClasificacion, IdVariable, IdSubVariable, Justificacion)
VALUES 
(@IdClas_RLA, @vH3, NULL, 'Difusión de contenido oficial municipal con fines partidarios según Resolución N.° 05473-2025-JEE.'),
(@IdClas_RLA, @vH4, NULL, 'Deuda coactiva con SUNAT por aproximadamente S/ 13 millones vinculada a Peruval Corp. S.A.'),
(@IdClas_RLA, @vH2, NULL, 'Orden de retiro de propaganda electoral con invocaciones religiosas por vulnerar normativa del JNE.');

-- 11. FUENTES
INSERT INTO FuenteInformacion (NombreFuente, TipoFuente, LinkFuente)
VALUES 
('La República - Neutralidad', 'Mediática', 'https://larepublica.pe/politica/2025/12/10/jee-ordena-a-rafael-lopez-aliaga-no-invocar-temas-religiosos-y-da-5-dias-para-retirar-propaganda-electoral-hnews-842720'),
('Infobae - Deuda Sunat', 'Mediática', 'https://www.infobae.com/peru/2026/01/04/confirman-que-rafael-lopez-aliaga-mantiene-deuda-coactiva-con-sunat-por-mas-de-s129-millones-empresa-fue-declarada-irregular/#:~:text=Per%C3%BA-,Confirman%20que%20Rafael%20L%C3%B3pez%20Aliaga%20mantiene%20deuda%20coactiva%20con%20Sunat,:%20empresa%20fue%20declarada%20%E2%80%9Cirregular%E2%80%9D'),
('La pderecho', 'Mediática', 'https://lpderecho.pe/promueve-el-voto-favor-renovacion-popular-jee-concluye-lopez-aliaga-infringio-neutralidad-electoral-publicacion-facebook/'),
('Infobae', 'Mediática', 'https://www.infobae.com/peru/2025/11/05/rafael-lopez-aliaga-si-vulnero-la-neutralidad-electoral-jne-confirma-infraccion-del-exalcalde/#:~:text=Rafael%20L%C3%B3pez%20Aliaga%20s%C3%AD%20vulner%C3%B3,del%20exalcalde%20de%20Lima%20%2D%20Infobae');
GO


USE Elecciones2026DB17; 
GO

ALTER TABLE Candidato 
ADD FechaNacimiento DATE;
GO

UPDATE Candidato SET FechaNacimiento = '1950-07-17' WHERE NombreCompleto LIKE '%PABLO ALFONSO LOPEZ CHAU NAVA%';
UPDATE Candidato SET FechaNacimiento = '1981-09-30' WHERE NombreCompleto LIKE '%RONALD DARWIN ATENCIO SOTOMAYOR%';
UPDATE Candidato SET FechaNacimiento = '1952-08-11' WHERE NombreCompleto LIKE '%CESAR ACUÑA PERALTA%';
UPDATE Candidato SET FechaNacimiento = '1951-11-09' WHERE NombreCompleto LIKE '%JOSE DANIEL WILLIAMS ZAPATA%';
UPDATE Candidato SET FechaNacimiento = '1983-07-26' WHERE NombreCompleto LIKE '%ALVARO GONZALO PAZ DE LA BARRA FREIGEIRO%';
UPDATE Candidato SET FechaNacimiento = '1975-05-25' WHERE NombreCompleto LIKE '%KEIKO SOFIA FUJIMORI HIGUCHI%';
UPDATE Candidato SET FechaNacimiento = '1974-03-20' WHERE NombreCompleto LIKE '%FIORELLA GIANNINA MOLINELLI ARISTONDO%';
UPDATE Candidato SET FechaNacimiento = '1969-02-03' WHERE NombreCompleto LIKE '%ROBERTO HELBERT SANCHEZ PALOMINO%';
UPDATE Candidato SET FechaNacimiento = '1974-12-26' WHERE NombreCompleto LIKE '%RAFAEL JORGE BELAUNDE LLOSA%';
UPDATE Candidato SET FechaNacimiento = '1986-04-14' WHERE NombreCompleto LIKE '%PITTER ENRIQUE VALDERRAMA PEÑA%';
UPDATE Candidato SET FechaNacimiento = '1945-08-29' WHERE NombreCompleto LIKE '%RICARDO PABLO BELMONT CASSINELLI%';
UPDATE Candidato SET FechaNacimiento = '1964-04-11' WHERE NombreCompleto LIKE '%NAPOLEON BECERRA GARCIA%';
UPDATE Candidato SET FechaNacimiento = '1951-10-29' WHERE NombreCompleto LIKE '%JORGE NIETO MONTESINOS%';
UPDATE Candidato SET FechaNacimiento = '1980-06-02' WHERE NombreCompleto LIKE '%CHARLIE CARRASCO SALAZAR%';
UPDATE Candidato SET FechaNacimiento = '1961-11-24' WHERE NombreCompleto LIKE '%ALEX GONZALES CASTILLO%';
UPDATE Candidato SET FechaNacimiento = '1959-06-13' WHERE NombreCompleto LIKE '%ARMANDO JOAQUIN MASSE FERNANDEZ%';
UPDATE Candidato SET FechaNacimiento = '1982-06-20' WHERE NombreCompleto LIKE '%GEORGE PATRICK FORSYTH SOMMER%';
UPDATE Candidato SET FechaNacimiento = '1958-07-26' WHERE NombreCompleto LIKE '%LUIS FERNANDO OLIVERA VEGA%';
UPDATE Candidato SET FechaNacimiento = '1963-06-13' WHERE NombreCompleto LIKE '%MESIAS ANTONIO GUEVARA AMASIFUEN%';
UPDATE Candidato SET FechaNacimiento = '1964-01-07' WHERE NombreCompleto LIKE '%CARLOS GONSALO ALVAREZ LOAYZA%';
UPDATE Candidato SET FechaNacimiento = '1978-09-19' WHERE NombreCompleto LIKE '%HERBERT CALLER GUTIERREZ%';
UPDATE Candidato SET FechaNacimiento = '1959-02-15' WHERE NombreCompleto LIKE '%YONHY LESCANO ANCIETA%';
UPDATE Candidato SET FechaNacimiento = '1967-09-21' WHERE NombreCompleto LIKE '%WOLFGANG MARIO GROZO COSTA%';
UPDATE Candidato SET FechaNacimiento = '1970-12-16' WHERE NombreCompleto LIKE '%VLADIMIR ROY CERRON ROJAS%';
UPDATE Candidato SET FechaNacimiento = '1946-04-18' WHERE NombreCompleto LIKE '%FRANCISCO ERNESTO DIEZ-CANSECO TÁVARA%';
UPDATE Candidato SET FechaNacimiento = '1954-07-12' WHERE NombreCompleto LIKE '%MARIO ENRIQUE VIZCARRA CORNEJO%';
UPDATE Candidato SET FechaNacimiento = '1968-06-27' WHERE NombreCompleto LIKE '%WALTER GILMER CHIRINOS PURIZAGA%';
UPDATE Candidato SET FechaNacimiento = '1960-09-01' WHERE NombreCompleto LIKE '%ALFONSO CARLOS ESPA Y GARCES-ALVEAR%';
UPDATE Candidato SET FechaNacimiento = '1967-04-28' WHERE NombreCompleto LIKE '%CARLOS ERNESTO JAICO CARRANZA%';
UPDATE Candidato SET FechaNacimiento = '1955-07-17' WHERE NombreCompleto LIKE '%JOSE LEON LUNA GALVEZ%';
UPDATE Candidato SET FechaNacimiento = '1969-04-11' WHERE NombreCompleto LIKE '%MARIA SOLEDAD PEREZ TELLO DE RODRIGUEZ%';
UPDATE Candidato SET FechaNacimiento = '1979-02-02' WHERE NombreCompleto LIKE '%PAUL DAVIS JAIMES BLANCO%';
UPDATE Candidato SET FechaNacimiento = '1955-05-10' WHERE NombreCompleto LIKE '%ANTONIO ORTIZ VILLANO%';
UPDATE Candidato SET FechaNacimiento = '1975-01-19' WHERE NombreCompleto LIKE '%ROSARIO DEL PILAR FERNANDEZ BAZAN%';
UPDATE Candidato SET FechaNacimiento = '1949-07-15' WHERE NombreCompleto LIKE '%ROBERTO ENRIQUE CHIABRA LEON%';
UPDATE Candidato SET FechaNacimiento = '1961-02-11' WHERE NombreCompleto LIKE '%RAFAEL BERNARDO LÓPEZ ALIAGA CAZORLA%';


CREATE TABLE HistorialTikTok (
    IdHistorial INT PRIMARY KEY IDENTITY(1,1),
    IdCandidato INT,
    Usuario VARCHAR(100),
    Seguidores INT,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
ALTER TABLE HistorialTikTok ADD Likes BIGINT, Videos INT;

UPDATE CandidatoRedSocial
SET Usuario = 'robertochiabra'
WHERE IdCandidatoRed = 35;

ALTER TABLE HistorialTikTok ADD Likes BIGINT, Videos INT;

USE Elecciones2026DB17;
GO


IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('CandidatoRedSocial') AND name = 'Likes')
    ALTER TABLE CandidatoRedSocial ADD Likes BIGINT;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('CandidatoRedSocial') AND name = 'Videos')
    ALTER TABLE CandidatoRedSocial ADD Videos INT;


IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('HistorialTikTok') AND name = 'Likes')
    ALTER TABLE HistorialTikTok ADD Likes BIGINT;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('HistorialTikTok') AND name = 'Videos')
    ALTER TABLE HistorialTikTok ADD Videos INT;

UPDATE CandidatoRedSocial
SET Usuario = 'mesiasguevaraa'
WHERE IdCandidatoRed = 19;

USE Elecciones2026DB17;
GO


TRUNCATE TABLE HistorialTikTok;
GO


UPDATE CandidatoRedSocial
SET Usuario = 'pepeluna.presidente'
WHERE IdCandidatoRed = 30;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'PAT', 
    SubSubNivel = NULL 
WHERE IdCandidato = 13;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A', 
    SubSubNivel = 1  
WHERE IdCandidato = 31;

UPDATE ClasificacionLegalPenal
SET SubSubNivel = 2
WHERE IdCandidato = 2;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 23;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 25;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 27;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 28;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 32;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 33;

UPDATE ClasificacionLegalPenal
SET SubNivel = 'A'
WHERE IdCandidato = 35;

USE Elecciones2026DB17;
GO


SELECT TOP 1 * FROM Candidato;

TRUNCATE TABLE NoticiasPendientes;
SELECT COUNT(*) FROM NoticiasPendientes;


ALTER TABLE Candidato ADD FotoUrl VARCHAR(500);
GO

UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/ddfa74eb-cae3-401c-a34c-35543ae83c57.jpg' WHERE NombreCompleto LIKE '%PABLO ALFONSO LOPEZ CHAU NAVA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/bac0288d-3b21-45ac-8849-39f9177fb020.jpg' WHERE NombreCompleto LIKE '%RONALD DARWIN ATENCIO SOTOMAYOR%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/d6fe3cac-7061-474b-8551-0aa686a54bad.jpg' WHERE NombreCompleto LIKE '%CESAR ACUÑA PERALTA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/b60c471f-a6bb-4b42-a4b2-02ea38acbb0d.jpg' WHERE NombreCompleto LIKE '%JOSE DANIEL WILLIAMS ZAPATA%';
UPDATE Candidato SET FotoUrl = 'https://votoinformado.jne.gob.pe/assets/images/candidatos/ALVARO%20PAZ%20DE%20LA%20BARRA.jpg' WHERE NombreCompleto LIKE '%ALVARO GONZALO PAZ DE LA BARRA FREIGEIRO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/251cd1c0-acc7-4338-bd8a-439ccb9238d0.jpeg' WHERE NombreCompleto LIKE '%KEIKO SOFIA FUJIMORI HIGUCHI%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/1de656b5-7593-4c60-ab7a-83d618a3d80d.jpg' WHERE NombreCompleto LIKE '%FIORELLA GIANNINA MOLINELLI ARISTONDO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/bb7c7465-9c6e-44eb-ac7d-e6cc7f872a1a.jpg' WHERE NombreCompleto LIKE '%ROBERTO HELBERT SANCHEZ PALOMINO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/3302e45b-55c8-4979-a60b-2b11097abf1d.jpg' WHERE NombreCompleto LIKE '%RAFAEL JORGE BELAUNDE LLOSA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/d72c4b29-e173-42b8-b40d-bdb6d01a526a.jpg' WHERE NombreCompleto LIKE '%PITTER ENRIQUE VALDERRAMA PEÑA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/78647f15-d5d1-4ed6-8ac6-d599e83eeea3.jpg' WHERE NombreCompleto LIKE '%RICARDO PABLO BELMONT CASSINELLI%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/bab206cb-b2d5-41ec-bde8-ef8cf3e0a2df.jpg' WHERE NombreCompleto LIKE '%NAPOLEON BECERRA GARCIA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/9ae56ed5-3d0f-49ff-8bb9-0390bad71816.jpg' WHERE NombreCompleto LIKE '%JORGE NIETO MONTESINOS%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/12fa17db-f28f-4330-9123-88549539b538.jpg' WHERE NombreCompleto LIKE '%CHARLIE CARRASCO SALAZAR%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/c0ae56bf-21c1-4810-890a-b25c8465bdd9.jpg' WHERE NombreCompleto LIKE '%ALEX GONZALES CASTILLO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/cb1adeb7-7d2f-430c-ae87-519137d8edfa.jpg' WHERE NombreCompleto LIKE '%ARMANDO JOAQUIN MASSE FERNANDEZ%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/b1d60238-c797-4cba-936e-f13de6a34cc7.jpg' WHERE NombreCompleto LIKE '%GEORGE PATRICK FORSYTH SOMMER%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/3e2312e1-af79-4954-abfa-a36669c1a9e9.jpg' WHERE NombreCompleto LIKE '%LUIS FERNANDO OLIVERA VEGA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/1b861ca7-3a5e-48b4-9024-08a92371e33b.jpg' WHERE NombreCompleto LIKE '%MESIAS ANTONIO GUEVARA AMASIFUEN%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/2bd18177-d665-413d-9694-747d729d3e39.jpg' WHERE NombreCompleto LIKE '%CARLOS GONSALO ALVAREZ LOAYZA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/6ad6c5ff-0411-4ddd-9cf7-b0623f373fcf.jpg' WHERE NombreCompleto LIKE '%HERBERT CALLER GUTIERREZ%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/b9db2b5c-02ff-4265-ae51-db9b1001ad70.jpg' WHERE NombreCompleto LIKE '%YONHY LESCANO ANCIETA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/064360d1-ce49-4abe-939c-f4de8b0130a2.jpg' WHERE NombreCompleto LIKE '%WOLFGANG MARIO GROZO COSTA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/82ee0ff2-2336-4aba-9590-e576f7564315.jpg' WHERE NombreCompleto LIKE '%VLADIMIR ROY CERRON ROJAS%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/2d1bf7f2-6e88-4ea9-8ed2-975c1ae5fb92.jpg' WHERE NombreCompleto LIKE '%FRANCISCO ERNESTO DIEZ-CANSECO TÁVARA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/ee7a080e-bc81-4c81-9e5e-9fd95ff459ab.jpg' WHERE NombreCompleto LIKE '%MARIO ENRIQUE VIZCARRA CORNEJO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/a2d0f631-fe47-4c41-92ba-7ed9f4095520.jpg' WHERE NombreCompleto LIKE '%WALTER GILMER CHIRINOS PURIZAGA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/85935f77-6c46-4eab-8c7e-2494ffbcece0.jpg' WHERE NombreCompleto LIKE '%ALFONSO CARLOS ESPA Y GARCES-ALVEAR%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/7d91e14f-4417-4d61-89ba-3e686dafaa95.jpg' WHERE NombreCompleto LIKE '%CARLOS ERNESTO JAICO CARRANZA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/a669a883-bf8a-417c-9296-c14b943c3943.jpg' WHERE NombreCompleto LIKE '%JOSE LEON LUNA GALVEZ%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/073703ca-c427-44f0-94b1-a782223a5e10.jpg' WHERE NombreCompleto LIKE '%MARIA SOLEDAD PEREZ TELLO DE RODRIGUEZ%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/929e1a63-335d-4f3a-ba26-f3c7ff136213.jpg' WHERE NombreCompleto LIKE '%PAUL DAVIS JAIMES BLANCO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/b2e00ae2-1e50-4ad3-a103-71fc7e4e8255.jpg' WHERE NombreCompleto LIKE '%RAFAEL BERNARDO LÓPEZ ALIAGA CAZORLA%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/8e6b9124-2883-4143-8768-105f2ce780eb.jpg' WHERE NombreCompleto LIKE '%ANTONIO ORTIZ VILLANO%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/ac0b0a59-ead5-4ef1-8ef8-8967e322d6ca.jpg' WHERE NombreCompleto LIKE '%ROSARIO DEL PILAR FERNANDEZ BAZAN%';
UPDATE Candidato SET FotoUrl = 'https://mpesije.jne.gob.pe/apidocs/5c703ce9-ba1e-4490-90bf-61006740166f.jpg' WHERE NombreCompleto LIKE '%ROBERTO ENRIQUE CHIABRA LEON%';



ALTER TABLE Partido ADD LogoUrl VARCHAR(500);
GO
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2980' WHERE NombrePartido LIKE '%AHORA NACION%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/3025' WHERE NombrePartido LIKE '%ALIANZA ELECTORAL VENCEREMOS%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/1257' WHERE NombrePartido LIKE '%ALIANZA PARA EL PROGRESO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2173' WHERE NombrePartido LIKE '%AVANZA PAIS%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2898' WHERE NombrePartido LIKE '%FE EN EL PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/1366' WHERE NombrePartido LIKE '%FUERZA POPULAR%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/3024' WHERE NombrePartido LIKE '%FUERZA Y LIBERTAD%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/1264' WHERE NombrePartido LIKE '%JUNTOS POR EL PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2933' WHERE NombrePartido LIKE '%LIBERTAD POPULAR%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2930' WHERE NombrePartido LIKE '%PARTIDO APRISTA PERUANO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2941' WHERE NombrePartido LIKE '%PARTIDO CIVICO OBRAS%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2939' WHERE NombrePartido LIKE '%PARTIDO DE LOS TRABAJADORES%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2961' WHERE NombrePartido LIKE '%PARTIDO DEL BUEN GOBIERNO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2867' WHERE NombrePartido LIKE '%PARTIDO DEMOCRATA UNIDO PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2895' WHERE NombrePartido LIKE '%PARTIDO DEMOCRATA VERDE%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2986' WHERE NombrePartido LIKE '%PARTIDO DEMOCRATICO FEDERAL%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/14' WHERE NombrePartido LIKE '%SOMOS PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2857' WHERE NombrePartido LIKE '%FRENTE DE LA ESPERANZA%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2840' WHERE NombrePartido LIKE '%PARTIDO MORADO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2956' WHERE NombrePartido LIKE '%PARTIDO PAIS PARA TODOS%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2869' WHERE NombrePartido LIKE '%PARTIDO PATRIOTICO DEL PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2995' WHERE NombrePartido LIKE '%COOPERACION POPULAR%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2985' WHERE NombrePartido LIKE '%INTEGRIDAD DEMOCRATICA%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2218' WHERE NombrePartido LIKE '%PERU LIBRE%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2932' WHERE NombrePartido LIKE '%PERU ACCION%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2925' WHERE NombrePartido LIKE '%PERU PRIMERO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2921' WHERE NombrePartido LIKE '%PRIN%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2935' WHERE NombrePartido LIKE '%SICREO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2924' WHERE NombrePartido LIKE '%PERU MODERNO%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2731' WHERE NombrePartido LIKE '%PODEMOS PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2931' WHERE NombrePartido LIKE '%PRIMERO LA GENTE%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2967' WHERE NombrePartido LIKE '%PROGRESEMOS%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/22' WHERE NombrePartido LIKE '%RENOVACION POPULAR%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2927' WHERE NombrePartido LIKE '%SALVEMOS AL PERU%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/2998' WHERE NombrePartido LIKE '%UN CAMINO DIFERENTE%';
UPDATE Partido SET LogoUrl = 'https://sroppublico.jne.gob.pe/Consulta/Simbolo/GetSimbolo/3023' WHERE NombrePartido LIKE '%UNIDAD NACIONAL%';