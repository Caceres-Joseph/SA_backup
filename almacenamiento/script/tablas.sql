DROP DATABASE IF EXISTS ALMACENAMIENTO;

CREATE DATABASE ALMACENAMIENTO;

USE ALMACENAMIENTO;

-- ELIMINACION DE TABLAS
-- DROP TABLE IF EXISTS CADENA;
-- DROP TABLE IF EXISTS COMPLEMENTO;
-- DROP TABLE IF EXISTS ESTADO;
-- DROP TABLE IF EXISTS LOCALIZACION;



CREATE TABLE ESTADO(
	idEstado int primary key not null AUTO_INCREMENT,
    estado varchar(100) not null
);

CREATE TABLE LOCALIZACION(
	idLocalizacion int primary key not null AUTO_INCREMENT,
    localizacion varchar(100) null,
    internacionalizacion varchar(100) null,
    idEstado int not null
);

CREATE TABLE COMPLEMENTO(
	idComplemento int primary key not null AUTO_INCREMENT,
    complemento varchar(100),
    nombreusr varchar(100),
    correousr varchar(100),
    idLocalizacion int not null,
    idEstado int null,
	FOREIGN KEY (idEstado) REFERENCES estado(idEstado),
    FOREIGN KEY (idLocalizacion) REFERENCES localizacion(idLocalizacion)
);


CREATE TABLE CADENA(
	idDetalleComplemento int primary key not null AUTO_INCREMENT,
    idComplemento int,
    idLocalizacion int,
    idEstado int,
    cadena varchar(100),
    nombreusr varchar(100),
    correousr varchar(100),
    FOREIGN KEY (idComplemento) REFERENCES complemento(idComplemento),
    FOREIGN KEY (idEstado) REFERENCES estado(idEstado),
    FOREIGN KEY (idLocalizacion) REFERENCES localizacion(idLocalizacion)
);







