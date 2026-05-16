USE MASTER;
GO

EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

-- Recriar banco
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'dbBancoPermissoes')
BEGIN
    ALTER DATABASE dbBancoPermissoes SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE dbBancoPermissoes;
END;
GO

CREATE DATABASE dbBancoPermissoes;
GO
ALTER DATABASE dbBancoPermissoes SET CONTAINMENT = PARTIAL;
GO

USE dbBancoPermissoes;
GO

CREATE TABLE DADOS_RESTRITOS ( ID INT IDENTITY ( 1, 1 ) PRIMARY KEY,
								INFO VARCHAR ( 60 )
							 );

INSERT INTO DADOS_RESTRITOS ( INFO ) VALUES ( 'PRIMEIRO SEGREDO' );
INSERT INTO DADOS_RESTRITOS ( INFO ) VALUES ( 'SEGUNDO SEGREDO' );
INSERT INTO DADOS_RESTRITOS ( INFO ) VALUES ( 'TERCEIRO SEGREDO' );

GO

-- Criar procedure que valida a senha
CREATE PROCEDURE LER_TABELA @USUARIO CHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @autenticado BIT = 0;
    
    -- Verifica se o usuário existe
    IF NOT EXISTS (SELECT 1 FROM SYS.DATABASE_PRINCIPALS WHERE name = @USUARIO)
    BEGIN
        PRINT('ERRO: Usuário não encontrado');
        RETURN;
    END
    
    -- Tenta autenticar (valida a senha)
    BEGIN TRY
        EXECUTE AS USER = @USUARIO WITH NO REVERT;
        SET @autenticado = 1;
        REVERT;
    END TRY
    BEGIN CATCH
        PRINT('ERRO: Falha na autenticação - usuário ou senha inválidos');
        RETURN;
    END CATCH
    
    -- Se chegou aqui, autenticou com sucesso
    IF @autenticado = 1
    BEGIN
        PRINT('EXECUTANDO A STORED PROCEDURE.');
        PRINT('Usuário autenticado: ' + @USUARIO);
        PRINT('Data/Hora: ' + CAST(GETDATE() AS VARCHAR));
        
        -- Aqui vai a lógica principal da sua procedure
        SELECT * FROM DADOS_RESTRITOS;
    END
END
GO

-- Criar usuário contido
CREATE USER USUARIO_01 WITH PASSWORD = 'SENHA123';
GO
-- Conceder permissão para executar
GRANT EXECUTE ON LER_TABELA TO USUARIO_01;
GRANT SELECT ON DADOS_RESTRITOS TO USUARIO_01;
GO

-- Testes
PRINT '=== TESTE 1: Credenciais corretas ===';
EXEC LER_TABELA @USUARIO= 'USUARIO_01'
GO


PRINT '=== TESTE 3: Usuário inexistente ===';
EXEC LER_TABELA @USUARIO= 'INEXISTENTE'
GO