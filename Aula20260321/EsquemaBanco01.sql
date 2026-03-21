-- Isso é um comentario

USE MASTER; --Contexto em MASTER

CREATE DATABASE db_aula20260321_01; --Cria banco de dados

GO
USE db_aula20260321_01;

CREATE TABLE tbAluno (RA DECIMAL(7), NOME VARCHAR(60))

INSERT INTO tbAluno (RA, NOME) VALUES (2376542, 'Sofia');

SELECT * FROM tbAluno; --Exibe todas as colunas

SELECT * FROM tbAluno WHERE NOME = 'Sofia'; --Exibe todas as colunas