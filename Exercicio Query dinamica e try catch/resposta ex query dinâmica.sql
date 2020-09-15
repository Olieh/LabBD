CREATE DATABASE exercicio
GO
USE exercicio

CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2),
tipo CHAR(1) DEFAULT('e')
PRIMARY KEY (idProduto))

CREATE TABLE compra(
codigo INT IDENTITY NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))

CREATE TABLE venda(
codigo INT IDENTITY NOT NULL,
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)
PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))




CREATE PROCEDURE sp_insereproduto(@idProduto INT, @nome VARCHAR(100),@valor DECIMAL(7,2), @tipo CHAR(1), @qtd INT)
AS
	DECLARE 
		@erro		VARCHAR(MAX),
		@tabela		VARCHAR(10)
	
	BEGIN TRY
		INSERT INTO produto VALUES (@idProduto,@nome,@valor,@tipo)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%') BEGIN
			RAISERROR('CHAVE PRIMÁRIA DUPLICADA', 16, 1)
		END	ELSE BEGIN
			RAISERROR('ERRO DE PROCESSAMENTO', 16, 1)
		END
	END CATCH

	IF(@erro is null)BEGIN
		IF(@tipo = 's')BEGIN
			SET @tabela = 'venda'
		END ELSE BEGIN
			SET @tabela = 'compra'
		END

		DECLARE @query		VARCHAR(MAX)
		SET @query = 'INSERT INTO '+@tabela+' VALUES('+CAST(@idProduto AS VARCHAR(MAX))+
		','+CAST(@qtd AS VARCHAR(MAX))+
		','+CAST((@valor*@qtd) AS VARCHAR(MAX))+')'
		PRINT @query
		BEGIN TRY
			EXEC (@query)
			--INSERT INTO tabela VALUES (@var1, @var2)
		END TRY
		BEGIN CATCH
			SET @erro = ERROR_MESSAGE()
			IF (@erro LIKE '%primary%') BEGIN
				RAISERROR('Chave primária duplicada', 16, 1)
			END	ELSE BEGIN
				RAISERROR('Erro de processamento', 16, 1)
			END
		END CATCH
	END ELSE BEGIN
	PRINT 'FIM DO PROGRAMA'
	END

EXEC sp_insereproduto 1001,'Coca-Cola',6.00,'e',100
EXEC sp_insereproduto 1002,'Pepsi',4.00,'s',200
EXEC sp_insereproduto 1003,'Papel',1.00,'e',1000
EXEC sp_insereproduto 1004,'Papelão',1.20,'e',500
EXEC sp_insereproduto 1005,'Papel higienico',4.00,'e',1000
EXEC sp_insereproduto 1006,'Óleo',7.00,'e',10000
EXEC sp_insereproduto 1007,'Mouse',45.00,'s',20
EXEC sp_insereproduto 1008,'Teclado',89.00,'s',70
EXEC sp_insereproduto 1009,'Monitor',1200.00,'s',20
EXEC sp_insereproduto 1014,'CD Virgem',4.00,'s',100
EXEC sp_insereproduto 1015,'MP3',10000.00,'s',2
