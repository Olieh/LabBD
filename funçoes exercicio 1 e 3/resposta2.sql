/*-------------------------------------------------------------------------*/
CREATE DATABASE aula6
USE aula6

CREATE TABLE Funcionario(
codigo		INT IDENTITY not null,
nome		VARCHAR(100),
salario		DECIMAL(7,2)
PRIMARY KEY(codigo)
)

CREATE TABLE Dependente(
codigo_funcionario		INT FOREIGN KEY REFERENCES Funcionario(codigo),
nome_dependente			VARCHAR(100),
salario_dependente		DECIMAL(7,2)
)

/* INSERIR DADOS -------------------------------------------------------------------------*/
DECLARE @i INT = 0,
		@cont INT,
		@proximoId INT
WHILE @i < 4 
BEGIN
    SET @i = @i + 1
    INSERT INTO Funcionario (nome,salario) VALUES (('nome'+CAST(@i AS VARCHAR(50))),(1000.00+@i))

	SET @cont = (SELECT COUNT(*) FROM Funcionario)
	IF (@cont != 0)
	BEGIN
		SET @proximoId = (SELECT MAX(codigo)FROM Funcionario)
	END

	INSERT INTO Dependente(codigo_funcionario,nome_dependente,salario_dependente) VALUES (@proximoId,('nome dependente'+CAST(@i AS VARCHAR(50))),(1000.00+@i))
END
INSERT INTO Dependente(codigo_funcionario,nome_dependente,salario_dependente) VALUES (1,('nome dependente acrescentado'),(1654))

SELECT * FROM Funcionario
SELECT * FROM Dependente

/* FUNÇÃO RETORNA TABELA -------------------------------------------------------------------------*/
CREATE ALTER FUNCTION retorna_tabela() RETURNS @tabela TABLE(
nome_funcionario		VARCHAR(100),
nome_dependente			VARCHAR(100),
salario_funcionario		DECIMAL(7,2),
salario_dependente		DECIMAL(7,2)
)
AS
	BEGIN
		INSERT @tabela (nome_funcionario, nome_dependente, salario_funcionario, salario_dependente) 
		SELECT fun.nome, dep.nome_dependente,	fun.salario, dep.salario_dependente
		FROM Funcionario AS fun
		INNER JOIN Dependente  AS dep
		ON fun.codigo = dep.codigo_funcionario
		GROUP BY fun.nome, dep.nome_dependente,	fun.salario, dep.salario_dependente
		ORDER BY fun.nome, dep.nome_dependente
	RETURN
END
SELECT * FROM dbo.retorna_tabela()

/* FUNÇÃO RETORNA SOMA DE SALARIO DE ACORDO COM O NOME PROCURADO -------------------------------------------------------------------------*/

CREATE FUNCTION soma_salario(@nome VARCHAR(100))
RETURNS INT
AS
BEGIN
		DECLARE @qtd	INT
		SET @qtd =  (SELECT SUM(salar.salario_dependente) 
		FROM (SELECT * FROM dbo.retorna_tabela()) AS salar 
		WHERE salar.nome_funcionario = @nome )
	RETURN @qtd
END

PRINT dbo.soma_salario('nome1')
PRINT dbo.soma_salario('nome2')
