
USE MASTER;

IF NOT EXISTS ( SELECT * FROM SYS.DATABASES WHERE NAME = 'dbBancoGrantRevoke' )
BEGIN
	PRINT( 'CRIANDO O BANCO ' )
	CREATE DATABASE dbBancoGrantRevoke;
END
ELSE
	PRINT( 'O BANCO JÁ EXISTE' )
GO
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

