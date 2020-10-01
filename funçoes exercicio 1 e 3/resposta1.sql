CREATE DATABASE aula6
USE aula6

/* CRIAR TABELA PRODUTO -------------------------------------------------------------------------*/
CREATE TABLE produto(
codigo		INT IDENTITY NOT NULL,
nome		VARCHAR(100),
valor		DECIMAL(7,2),
estoque		INT NOT NULL
PRIMARY KEY (codigo))

/* CADASTRAR PRODUTO -------------------------------------------------------------------------*/
DECLARE @i INT = 0
WHILE @i < 300 
BEGIN
    SET @i = @i + 1
    INSERT INTO produto (nome, valor, estoque) VALUES (('nome'+CAST(@i AS VARCHAR(50))),(1000.00+@i), (@i*7))
END
SELECT * FROM produto WHERE produto.estoque < 100

/* FUNÇÃO RETORNA UM Nº DE ESTOQUES ABAIXO DE UM X QUANTIDADE-------------------------------------------------------------------------*/
CREATE FUNCTION retorna_qtd_estoque_abaixo(@estoque INT)
RETURNS INT
AS
BEGIN
		DECLARE @qtd	INT
		SET @qtd =  (select count(produto.codigo) FROM produto WHERE produto.estoque < @estoque )
	RETURN @qtd
END

print dbo.retorna_qtd_estoque_abaixo(100)

/*FUNÇÃO QUE RETORNA UMA TABELA COM ESTOQUES ABAIXO DE UM X QUANTIDADE-------------------------------------------------------------------------*/
CREATE FUNCTION retorna_tabela_estoque_abaixo(@estoque INT)
RETURNS @tabela  TABLE(
codigo		INT,
nome		VARCHAR(100),
estoque		INT 
)
AS
BEGIN
		INSERT @tabela (codigo, nome, estoque) SELECT codigo, nome, estoque FROM	produto WHERE estoque < @estoque
	RETURN 
END


select * from dbo.retorna_tabela_estoque_abaixo(100)
