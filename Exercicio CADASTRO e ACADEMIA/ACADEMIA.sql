/*Exercício
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                                                                    

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.

Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/

CREATE DATABASE academia
GO
USE academia

CREATE TABLE Aluno(
Codigo_aluno	INT IDENTITY not null PRIMARY KEY,
Nome			varchar(100)
)

create table Atividade(
Codigo		int identity not null primary key,
Descrição	varchar(200),
IMC			numeric(7,2)
)

insert into Atividade values ('Corrida + Step',18.5)
insert into Atividade values ('Biceps + Costas + Pernas',24.9)
insert into Atividade values ('Esteira + Biceps + Costas + Pernas',29.9)
insert into Atividade values ('Bicicleta + Biceps + Costas + Pernas',34.9)
insert into Atividade values ('Esteira + Bicicleta',39.9)

create table Atividadesaluno(
Codigo_aluno	int not null,
altura			numeric(3,2),
Peso			numeric(5,2),
IMC				numeric(7,2),
Atividade		int not null
);


CREATE PROCEDURE sp_alterar_aluno(	
	@Codigo_aluno	INT,
	@Nome			VARCHAR(100)
)
AS
	UPDATE Aluno SET Nome = @Nome
	WHERE Codigo_aluno = @Codigo_aluno


CREATE PROCEDURE sp_adicionar_aluno(	
	@Nome			VARCHAR(100),
	@retorno		INT OUTPUT
)
AS
	INSERT INTO Aluno VALUES (@Nome);	
	SET @retorno = SCOPE_IDENTITY();


CREATE PROCEDURE sp_calcular_imc(	
	@altura			numeric(3,2),
	@Peso			numeric(5,2),
	@IMC_saida		numeric(7,2) output
)
AS
	SET @IMC_saida =  @Peso  /  power( @altura,2) 


CREATE PROCEDURE sp_atribuir_atividade(	
	@IMC			NUMERIC(7,2),
	@atividade		INT output
)
AS
DECLARE
	@Codigo				INT,
	@IMC_BD			NUMERIC(7,2)
	SELECT @Codigo = Codigo, @IMC_BD = IMC from Atividade where Codigo = 1
	IF(@IMC <= @IMC_BD)BEGIN
		SET @atividade = 1
	END ELSE BEGIN
		SELECT @Codigo = Codigo, @IMC_BD = IMC from Atividade where Codigo = 2
		IF(@IMC <= @IMC_BD)BEGIN
			SET @atividade = 2
		END ELSE BEGIN
			SELECT @Codigo = Codigo, @IMC_BD = IMC from Atividade where Codigo = 3
			IF(@IMC <= @IMC_BD)BEGIN
				SET @atividade = 3
			END ELSE BEGIN
				SELECT @Codigo = Codigo, @IMC_BD = IMC from Atividade where Codigo = 4
				IF(@IMC <= @IMC_BD)BEGIN
					SET @atividade = 4
				END ELSE BEGIN
					SET @atividade = 5
				END
			END
		END
	END


CREATE PROCEDURE sp_alunoatividades(	
	@Codigo_aluno	INT,
	@Nome			VARCHAR(100),
	@altura			NUMERIC(3,2),
	@Peso			NUMERIC(5,2)
)
AS
DECLARE
	@IMC			NUMERIC(7,2),
	@Atividade		INT
IF(@Codigo_aluno is NULL)BEGIN
	IF(@Nome is not NULL or  @altura is not null and @Peso is not null) BEGIN
		EXEC sp_adicionar_aluno @Nome, @Codigo_aluno OUTPUT
		EXEC sp_calcular_imc @altura,@Peso,@IMC OUTPUT
		EXEC sp_atribuir_atividade @IMC, @Atividade OUTPUT
		INSERT INTO Atividadesaluno VALUES (@Codigo_aluno,@altura,@Peso,@IMC,@Atividade)
	END ELSE BEGIN
		PRINT 'Não possui altura ou peso'
	END
END ELSE BEGIN
		EXEC sp_alterar_aluno @Codigo_aluno,@Nome
		EXEC sp_calcular_imc @altura,@Peso,@IMC OUTPUT
		EXEC sp_atribuir_atividade @IMC, @Atividade OUTPUT
		UPDATE Atividadesaluno SET altura = @altura, Peso = @Peso, IMC = @IMC, Atividade = @Atividade
		WHERE Codigo_aluno = @Codigo_aluno
END


EXEC sp_alunoatividades NULL,'Joao',1.70,65
EXEC sp_alunoatividades NULL,'Pedro',1.60,72
EXEC sp_alunoatividades NULL,'André',1.68,64
EXEC sp_alunoatividades NULL,'Bento',1.90,90

select * from Aluno
select * from Atividadesaluno


EXEC sp_alunoatividades 1,'Joao A',1.71,64
EXEC sp_alunoatividades 2,'Pedro B',1.62,71
EXEC sp_alunoatividades 3,'André C',1.69,63
EXEC sp_alunoatividades 4,'Bento C',1.93,89