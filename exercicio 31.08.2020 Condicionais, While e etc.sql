-- Fazer um algoritmo que, dado 1 n�mero, mostre se s�o m�ltiplos de 2,3,5 ou nenhum deles

DECLARE @numero INT
SET @numero = 60
IF (@numero % 2 = 0) BEGIN
	IF (@numero % 3 = 0) BEGIN
		IF (@numero % 5 = 0) BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 2, 3 e 5'
		END	ELSE BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 2 e 3'
		END
	END	ELSE BEGIN
		IF (@numero % 5 = 0) BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 2 e 5'
		END ELSE BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 2'
		END
	END
END ELSE BEGIN
	IF (@numero % 3 = 0) BEGIN
		IF (@numero % 5 = 0) BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 3 e 5'
		END ELSE BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 3'
		END
	END ELSE BEGIN
		IF (@numero % 5 = 0) BEGIN
			PRINT 'O numero ' + CAST(@numero AS VARCHAR) + ' � multiplo de 5'
		END ELSE BEGIN
			PRINT 'N�o � multiplo de 2, 3 ou 5'
		END
	END
END


-- Fazer um algoritmo que, dados 3 n�meros, mostre o maior e o menor

DECLARE @numero1 INT,
		@numero2 INT,
		@numero3 INT
SET		@numero1 = 3
SET		@numero2 = 6
SET		@numero3 = 1
IF (@numero1 >= @numero2) BEGIN
	IF (@numero1 >= @numero3) BEGIN
		PRINT '1� Numero � o maior'
	END ELSE BEGIN
		PRINT '3� Numero � o maior'
	END
END ELSE BEGIN
	IF(@numero2 >= 3) BEGIN
		PRINT '2� Numero � o maior'
	END ELSE BEGIN
		PRINT '3� Numero � o maior'
	END
END




--Fazer um algoritmo que calcule os 15 primeiros termos da s�rie de Fibonacci e a soma dos 15 primeiros termos
DECLARE @atual		INT, 
		@anterior	INT,
		@i			INT,
		@aux		INT
SET	@atual		= 1
SET @anterior	= 0
SET @i			= 1
SET @aux		= 0
WHILE (@i <= 15) BEGIN
	SET @aux = @atual
	PRINT @atual
	SET @atual = @atual + @anterior
	SET @anterior = @aux
	SET @i = @i + 1
END


-- Fazer um algoritmo que separa uma frase, imprimindo todas as letras em mai�sculo e, depois imprimindo todas em min�sculo
DECLARE @frase VARCHAR(200)
SET @frase = 'O mundo n�o se divide em pessoas boas e m�s. Todos n�s temos Luz e Trevas dentro de n�s. O que importa � o lado que escolhemos para agir. Isso � o que realmente somos.'
SET	@frase = SUBSTRING(@frase,1,CHARINDEX('.',@frase))
PRINT @frase
SET @frase = UPPER(@frase)
PRINT @frase
SET @frase = LOWER(@frase)
PRINT @frase

-- Fazer um algoritmo que verifica, dada uma palavra, se �, ou n�o, pal�ndromo

DECLARE @palavra			VARCHAR(200),
		@palavraInversa		VARCHAR(200),
		@auxiliar				INT
SET @palavra = 'arara'
SET @auxiliar = LEN(@palavra)
PRINT @palavra
WHILE (@auxiliar > 0) BEGIN
	SET @palavra = SUBSTRING(@palavra,2,@auxiliar)
	PRINT @palavra
	SET @auxiliar = @auxiliar - 1
	print @auxiliar
END
PRINT @palavra
PRINT @palavraInversa


--Fazer um algoritmo que, dado um CPF diga se � v�lido

DECLARE @cpf					VARCHAR(11),
		@validador				VARCHAR(2),
		@i						INT,
		@aux				INT,
		@letra					VARCHAR(1),
		@resto					INT
SET @cpf = '11144477735'
SET @i = 9
SET @aux = 0
WHILE (1 <= @i) BEGIN
	SET  @letra = SUBSTRING(@cpf,@i,@i)
	SET @aux = @aux + ((11-@i) * CAST(@letra AS INT)) 
	set @i = @i - 1
END
SET @resto = (@aux % 11)
IF (@resto < 2) BEGIN
	SET @validador = '0'
END ELSE BEGIN
	SET @validador = CAST((11 - @resto) AS VARCHAR)
END
SET @i = 10
SET @aux = 0
WHILE (1 <= @i) BEGIN
	SET  @letra = SUBSTRING(@cpf,@i,@i)
	SET @aux = @aux + ((12-@i) * CAST(@letra AS INT)) 
	set @i = @i - 1
END
SET @resto = (@aux % 11)
IF (@resto < 2) BEGIN
	SET @validador = @validador + '0'
END ELSE BEGIN
	SET @validador = @validador + CAST((11 - @resto) AS VARCHAR)
END
IF (@validador =SUBSTRING(@cpf,10,11) ) BEGIN
	PRINT 'cpf � valido'
END ELSE BEGIN
	PRINT 'cpf n�o � valido'
END