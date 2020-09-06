/**Exercícios :
1) Criar um database, fazer uma tabela cadastros (cpf, nome, rua, numero e cep)
com uma procedure que só permitirá a inserção dos dados se o CPF for válido, caso 
contrário retornar uma mensagem de erro
*/
CREATE DATABASE bd_cadastro
GO
USE bd_cadastro




CREATE TABLE cadastro(
cpf		VARCHAR(11) NOT NULL PRIMARY KEY,
nome	VARCHAR(100),
rua		VARCHAR(15),
numero	VARCHAR(5),
cep		VARCHAR(9))




CREATE PROCEDURE valida_cpf(
	@cpf VARCHAR(11),
	@saida	INT	output)
as
DECLARE @validador			VARCHAR(2),
		@i					INT,
		@aux				INT,
		@letra				VARCHAR(1),
		@resto				INT
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
	SET @saida = 1
END ELSE BEGIN
	SET @saida = 0
END




CREATE PROCEDURE cadastrar_usuario(	
	@cpf		VARCHAR(11),
	@nome		VARCHAR(100),
	@rua		VARCHAR(15),
	@numero		VARCHAR(5),
	@cep		VARCHAR(9),
	@saida		VARCHAR(MAX) output)
AS
declare @out varchar(max)
exec valida_cpf @cpf, @out output
IF( @out = 1)BEGIN
	insert into cadastro values (@cpf,@nome,@rua,@numero,@cep)
	set @saida = 'Inserido com sucesso'
end else begin
	raiserror('Operação Invalida',16,1)
end







declare @out varchar(max)
exec Cadastrar_usuario '11144477735','Joao','rua 2', '2','19994-23', @out output
print @out





select * from cadastro











