CREATE DATABASE  IF NOT EXISTS sa_db;

USE sa_db;

DROP TABLE IF EXISTS Archivo;

CREATE TABLE Archivo (
  Complemento varchar(100) NOT NULL,
  Localizacion varchar(100) NOT NULL,
  tipoArchivo varchar(20) DEFAULT NULL,
  Archivo blob,
  idEstado int(11) DEFAULT NULL,
  PRIMARY KEY (Complemento,Localizacion)
);

LOCK TABLES Archivo WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS ArchivoCadena;

CREATE TABLE ArchivoCadena (
  idDetalleArchivo int(11) NOT NULL AUTO_INCREMENT,
  Complemento varchar(100) NOT NULL,
  Idioma varchar(100) NOT NULL,
  Localizacion varchar(100) DEFAULT NULL,
  nombreusr varchar(100) DEFAULT NULL,
  correousr varchar(100) DEFAULT NULL,
  Cadena varchar(6000) DEFAULT NULL,
  Traduccion varchar(6000) DEFAULT NULL,
  PRIMARY KEY (idDetalleArchivo)
);

LOCK TABLES ArchivoCadena WRITE;

INSERT INTO ArchivoCadena VALUES (1,'WordPress Menu','es_ES','UA-08','Alan Rene Bautista','abautistausac@gmail.com','Menu','Menu'),
                                 (2,'WordPress Menu','es_ES','UA-08','Alan Rene Bautista','abautistausac@gmail.com','Login','Iniciciar Sesion'),                                 
                                 (3,'WordPress Menu','es_ES','UA-08','Alan Rene Bautista','abautistausac@gmail.com','Welcome','Bienvenida'),                                 
                                 (4,'WordPress Menu','es_ES','UA-08','Alan Rene Bautista','abautistausac@gmail.com','About','Acerca de');

UNLOCK TABLES;

DROP TABLE IF EXISTS table1;

CREATE TABLE table1 (
  id int(11) NOT NULL AUTO_INCREMENT,
  value varchar(6000) DEFAULT NULL,
  PRIMARY KEY (id)
);

LOCK TABLES table1 WRITE;

INSERT INTO table1 VALUES (1,'Menu, Iniciciar Sesion, Bienvenida, Acerca de, Cargar, Prueba');

UNLOCK TABLES;

DELIMITER ;;
CREATE DEFINER=root@'%' PROCEDURE sp_traducidosubeArchivo(
_nombre varchar(100), _Idioma varchar(100), _correo varchar(100),_nombrecomplemento varchar(100),_localizacion varchar(50),
_cadena varchar(6632), _traduccion varchar(6632)
)
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al insertar la traduccion ' mensaje;               
	  END;
truncate table table1;
insert into table1 (value) values(_cadena);
insert into ArchivoCadena (Complemento,Localizacion,Idioma,nombreusr,correousr,cadena, Traduccion)
SELECT
  _nombrecomplemento,_localizacion,_Idioma,_nombre,_correo,
  SUBSTRING_INDEX(SUBSTRING_INDEX(value, ',', n.digit+1), ',', -1) Valor, _traduccion
FROM
  table1
  INNER JOIN
  (SELECT 0 digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) n
  ON LENGTH(REPLACE(value, ',' , '')) <= LENGTH(value)-n.digit
ORDER BY
  id,
  n.digit;
  
select 200 estado, 'Archivo cargado correctamente';
END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=root@'%' PROCEDURE sp_traducircargaArchivo(_Complemento varchar(100),_Localizacion varchar(100), _tipoArchivo varchar(20), _idEstado int,_Archivo blob)
BEGIN
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN

		select 200 estado, 'Archivo cargado correctamente' mensaje;
		select 401 estado,'Error al insertar la traduccion ' mensaje;    
           
	  END;
      
      insert into Archivo (Complemento,Localizacion,tipoArchivo,Archivo,idEstado) values (_Complemento,_Localizacion,_tipoArchivo,_Archivo,_idEstado);
		select 200 estado, 'Archivo cargado correctamente' mensaje;
END ;;
DELIMITER ;

call sp_traducidosubeArchivo('Alan Plata','es_ES','plata346@gmail.com','WordPress Sing In','UA-08','out','Salir');
call sp_traducidosubeArchivo('Alan Plata','es_ES','plata346@gmail.com','WordPress Sing In','UA-08','Ok','Hecho');