-- Tabela de Disciplinas
CREATE TABLE Disciplinas (
    Codigo INT PRIMARY KEY, -- O ID ser� fornecido manualmente
    Nome NVARCHAR(100) NOT NULL
);


-- Tabela de Hor�rios
CREATE TABLE Horarios (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- ID gerado automaticamente
    DiaSemana NVARCHAR(50) NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraTermino TIME NOT NULL
);


-- Tabela de Coordena��es
CREATE TABLE Coordenacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- ID gerado automaticamente
    Nome NVARCHAR(100) NOT NULL
);


-- Tabela de Docentes
CREATE TABLE Docentes (
    Codigo INT PRIMARY KEY, -- O ID ser� fornecido manualmente
    Nome NVARCHAR(100) NOT NULL
);


-- Tabela de Solicita��o de Oferta de Disciplinas
CREATE TABLE SolicitacaoOfertaDisciplinas (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- ID gerado automaticamente
    CoordenacaoId INT NOT NULL, -- Relacionado � tabela Coordenacoes
    Responsavel NVARCHAR(100) NOT NULL,
    DisciplinaCodigo INT NOT NULL, -- Relacionado � tabela Disciplinas
    DocenteCodigo INT, -- Relacionado � tabela Docentes
    Perfil NVARCHAR(50),
    Turma NVARCHAR(50),
    NumeroVagasCalouros INT,
    NumeroVagasTotal INT NOT NULL,
    CONSTRAINT FK_Solicitacao_Coordenacao FOREIGN KEY (CoordenacaoId) REFERENCES Coordenacoes(Id),
    CONSTRAINT FK_Solicitacao_Disciplina FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplinas(Codigo),
    CONSTRAINT FK_Solicitacao_Docente FOREIGN KEY (DocenteCodigo) REFERENCES Docentes(Codigo)
);


-- Tabela para Relacionamento entre Solicita��es e Hor�rios
CREATE TABLE Solicita��oHorarios (
    SolicitacaoId INT NOT NULL, -- Relacionado � tabela SolicitacaoOfertaDisciplinas
    HorarioId INT NOT NULL, -- Relacionado � tabela Horarios
    PRIMARY KEY (SolicitacaoId, HorarioId),
    CONSTRAINT FK_SolicitacaoHorarios_Solicitacao FOREIGN KEY (SolicitacaoId) REFERENCES SolicitacaoOfertaDisciplinas(Id),
    CONSTRAINT FK_SolicitacaoHorarios_Horario FOREIGN KEY (HorarioId) REFERENCES Horarios(Id)
);


-- Inserir dados de documento externo na tabela disciplinas:
BULK INSERT Disciplinas
FROM 'C:\Users\Usuario\Downloads\disciplinas.csv'
WITH (
    FIELDTERMINATOR = ';', -- Delimitador de campos (v�rgula)
    ROWTERMINATOR = '\n', -- Delimitador de linhas
    FIRSTROW = 2  ,        -- Ignorar cabe�alho
	CODEPAGE = '65001'       -- For�a o encodamento UTF-8
);


-- Inserir dados de documento externo na tabela docentes:
BULK INSERT Docentes
FROM 'C:\Users\Usuario\Downloads\docentes.csv'
WITH (
    FIELDTERMINATOR = ';', -- Delimitador de campos (v�rgula)
    ROWTERMINATOR = '\n', -- Delimitador de linhas
    FIRSTROW = 2  ,        -- Ignorar cabe�alho
	CODEPAGE = '65001'       -- For�a o encodamento UTF-8
);


-- Identificar o local do arquivo
SELECT 
    name AS 'Nome do Arquivo',
    physical_name AS 'Caminho Completo do Arquivo',
    type_desc AS 'Tipo de Arquivo'
FROM 
    sys.master_files
WHERE 
    database_id = DB_ID('SolicitacaoDisciplinas'); -- Substitua com o nome do seu banco de dados


-- Ver dados de coordena��es
SELECT * FROM Coordenacoes;


-- Deletar dados da tabela disciplinas
DELETE FROM Disciplinas;


-- Deletar dados da tabela docentes
DELETE FROM Docentes;


-- Alterar tabamnho dos caracteres na tabela disciplinas, coluna Nome
ALTER TABLE Disciplinas
ALTER COLUMN Nome NVARCHAR(200);


-- Listar todas as colunas da tabela
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SolicitacaoOfertaDisciplinas';


-- Excluir coluna Id da tabela SolicitacaoOfertaDisciplinas
ALTER TABLE SolicitacaoOfertaDisciplinas
DROP COLUMN Id;


-- Incluir tabela Solicita��es
CREATE TABLE Solicitacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY,  -- Chave prim�ria
    CoordenacaoId INT NOT NULL,        -- Chave estrangeira para Coordenacoes
    DocenteId INT,                     -- Chave estrangeira para Docentes (opcional)
    DisciplinaId INT NOT NULL,         -- Chave estrangeira para Disciplinas
    Responsavel NVARCHAR(100) NOT NULL,
    Curso NVARCHAR(100) NOT NULL,
    Grade NVARCHAR(50) NOT NULL,
    Perfil NVARCHAR(100) NOT NULL,
    NumeroVagasCalouros INT NOT NULL,
    NumeroVagasTotal INT NOT NULL,

    -- Configura��o das chaves estrangeiras
    CONSTRAINT FK_Solicitacoes_Coordenacoes FOREIGN KEY (CoordenacaoId) REFERENCES Coordenacoes(Id),
    CONSTRAINT FK_Solicitacoes_Docentes FOREIGN KEY (DocenteId) REFERENCES Docentes(Codigo),
    CONSTRAINT FK_Solicitacoes_Disciplinas FOREIGN KEY (DisciplinaId) REFERENCES Disciplinas(Codigo)
);


-- Incluir tabela HorariosSolicitacoes
CREATE TABLE HorariosSolicitacoes (
    Id INT IDENTITY(1,1) PRIMARY KEY,      -- Chave prim�ria
    SolicitacaoId INT NOT NULL,            -- Chave estrangeira para Solicitacoes
    DiaSemana NVARCHAR(20) NOT NULL,       -- Exemplo: "Segunda-feira"
    HorarioInicio TIME NOT NULL,
    HorarioTermino TIME NOT NULL,

    -- Configura��o da chave estrangeira
    CONSTRAINT FK_HorariosSolicitacoes_Solicitacoes FOREIGN KEY (SolicitacaoId) REFERENCES Solicitacoes(Id)
);


--Testar inserir na tabela Solicitacoes os dados gerais da solicita��o
INSERT INTO Solicitacoes (
    CoordenacaoId, DocenteId, DisciplinaId, Responsavel, Curso, Grade, Perfil, NumeroVagasCalouros, NumeroVagasTotal
)
VALUES (
    1, -- ID da coordena��o
    706015, -- C�digo do docente
    520080, -- C�digo da disciplina
    'Maria Silva', 
    'Engenharia El�trica', 
    '2024.1', 
    'Bacharelado', 
    10, 
    50
);


-- Recuperar o Id gerado para essa solicita��o
SELECT SCOPE_IDENTITY() AS NovaSolicitacaoId;


-- Ap�s obter o SolicitacaoId, insirir os hor�rios na tabela HorariosSolicitacoes
INSERT INTO HorariosSolicitacoes (SolicitacaoId, DiaSemana, HorarioInicio, HorarioTermino)
VALUES
    (1, 'Segunda-feira', '08:00', '10:00'), -- Primeiro hor�rio
    (1, 'Quarta-feira', '14:00', '16:00'); -- Segundo hor�rio


-- Para exibir as solicita��es com os hor�rios associados, usando um JOIN
SELECT 
    s.Id AS SolicitacaoId,
    c.Nome AS Coordenacao,
    d.Nome AS Docente,
    di.Nome AS Disciplina,
    s.Responsavel,
    s.Curso,
    s.Grade,
    s.Perfil,
    s.NumeroVagasCalouros,
    s.NumeroVagasTotal,
    h.DiaSemana,
    h.HorarioInicio,
    h.HorarioTermino
FROM 
    Solicitacoes s
INNER JOIN 
    Coordenacoes c ON s.CoordenacaoId = c.Id
LEFT JOIN 
    Docentes d ON s.DocenteId = d.Codigo
INNER JOIN 
    Disciplinas di ON s.DisciplinaId = di.Codigo
INNER JOIN 
    HorariosSolicitacoes h ON s.Id = h.SolicitacaoId
ORDER BY 
    s.Id, h.DiaSemana;