EXEC SP_HELPSRVROLE

EXEC SP_HELPSRVROLEMEMBER

EXEC SP_HELPSRVROLEMEMBER 'SYSADMIN'

EXEC SP_ADDSRVROLEMEMBER 'ZE', 'SYSADMIN'
--OU
ALTER SERVER ROLE SYSADMIN
ADD MEMBER ZE

--ABRIR JANELA USANDO ZE

USE DB

CREATE TABLE TABELA
(
	CAMPO INT
)

SELECT *
FROM DB.DBO.TABELA

EXEC SP_WHO 

KILL 51
KILL 52

--VOLTAR

CREATE SERVER ROLE TI

USE DB

EXEC SP_HELPROLE

EXEC SP_HELPROLEMEMBER

EXEC SP_HELPROLEMEMBER 'DB_OWNER'

EXEC SP_ADDROLEMEMBER 'DB_OWNER', 'ZE'
--OU
ALTER ROLE DB_OWNER
ADD MEMBER ZE

EXEC SP_HELPROLEMEMBER 'DB_OWNER'

EXEC sp_dropsrvrolemember 'ZE', 'SYSADMIN'
--OU
ALTER SERVER ROLE SYSADMIN
DROP MEMBER ZE

EXEC sp_droprolemember 'DB_OWNER', 'ZE'
--OU
ALTER ROLE DB_OWNER
DROP MEMBER ZE

EXEC SP_ADDROLE 'FINANCEIRO'
--OU
CREATE ROLE FINANCEIRO

----------------------

GRANT SELECT 
ON TABELA
TO ZE

--ABRIR A JANELA DO ZE

SELECT *
FROM DB.DBO.TABELA

--VOLTAR

GRANT INSERT, UPDATE, DELETE
ON TABELA
TO ZE

--ABRIR A JANELA DO ZE

INSERT DB.DBO.TABELA
VALUES (1)

UPDATE DB.DBO.TABELA
SET CAMPO = CAMPO * 2

SELECT *
FROM DB.DBO.TABELA

DELETE DB.DBO.TABELA

--VOLTAR

GO

CREATE PROC USP_TIPO_PRODUTO
AS
	SELECT *
	FROM TIPO_PRODUTO
GO

GRANT EXEC 
ON USP_TIPO_PRODUTO
TO ZE

--ABRIR A JANELA DO ZE

EXEC USP_TIPO_PRODUTO

--VOLTAR

GO

CREATE FUNCTION UDF_NOME_PRODUTO_POR_COD_PRODUTO
(
	@COD_PRODUTO INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN 
	(
		SELECT NOME_PRODUTO 
		FROM PRODUTO
		WHERE COD_PRODUTO = @COD_PRODUTO	
	)
END

GRANT EXEC 
ON UDF_NOME_PRODUTO_POR_COD_PRODUTO
TO ZE

--ABRIR A JANELA DO ZE

SELECT DBO.UDF_NOME_PRODUTO_POR_COD_PRODUTO(10)

--VOLTAR

GO

CREATE FUNCTION UDF_PRODUTOS_POR_TIPO_PRODUTO
(
	@COD_TIPO_PRODUTO INT
)
RETURNS TABLE
AS
	RETURN
	(
		SELECT *
		FROM PRODUTO
		WHERE COD_TIPO_PRODUTO = @COD_TIPO_PRODUTO
	)
GO

GRANT SELECT
ON UDF_PRODUTOS_POR_TIPO_PRODUTO
TO ZE

--ABRIR A JANELA DO ZE

SELECT *
FROM UDF_PRODUTOS_POR_TIPO_PRODUTO(2)

--VOLTAR

GO

CREATE VIEW UV_TIPO_PRODUTO_PRODUTO
AS
	SELECT TP.*, 
		P.COD_PRODUTO, 
		P.NOME_PRODUTO, 
		P.PRECO_PRODUTO
	FROM TIPO_PRODUTO TP
	JOIN PRODUTO P
		ON TP.COD_TIPO_PRODUTO = P.COD_TIPO_PRODUTO
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON UV_TIPO_PRODUTO_PRODUTO
TO ZE

--ABRIR A JANELA DO ZE

INSERT UV_TIPO_PRODUTO_PRODUTO (NOME_TIPO_PRODUTO)
VALUES('ALIMENTO')

--VOLTAR

SELECT *
FROM TIPO_PRODUTO

GRANT SELECT, INSERT, UPDATE, DELETE
ON TIPO_PRODUTO
TO FINANCEIRO

EXEC SP_ADDROLEMEMBER 'FINANCEIRO', 'ZE'
--OU
ALTER ROLE FINANCEIRO
ADD MEMBER ZE

CREATE LOGIN CHICO 
WITH PASSWORD = 'abc123@'

CREATE USER CHICO
FOR LOGIN CHICO

ALTER ROLE FINANCEIRO
ADD MEMBER CHICO

--NOVA JANELA COM O CHICO

SELECT * FROM DB.DBO.TIPO_PRODUTO

SELECT * FROM DB.DBO.PRODUTO

--VOLTAR

EXECUTE AS USER = 'CHICO'

SELECT * FROM DB.DBO.TIPO_PRODUTO

SELECT * FROM DB.DBO.PRODUTO

REVERT

EXEC sp_addsrvrolemember 'CHICO', 'SYSADMIN'

EXECUTE AS USER = 'CHICO'

SELECT SUSER_SNAME(), USER_NAME()

REVERT

EXECUTE AS USER = 'ZE'

SELECT SUSER_SNAME(), USER_NAME()

REVERT

CREATE APPLICATION ROLE XPTO_APP
WITH PASSWORD = 'abc123@'

GRANT SELECT ON SCHEMA::DBO
TO XPTO_APP

SELECT *
FROM SYS.USER_TOKEN

EXEC sp_setapprole 'XPTO_APP', 'abc123@'

SELECT *
FROM SYS.USER_TOKEN
