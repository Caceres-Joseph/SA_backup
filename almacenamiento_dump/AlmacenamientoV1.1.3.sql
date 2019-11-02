-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: Almacenamiento
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `BitacoraCambio`
--

DROP TABLE IF EXISTS `BitacoraCambio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BitacoraCambio` (
  `idBitacoraCambio` int(11) NOT NULL AUTO_INCREMENT,
  `idDetalleComplemento` int(11) NOT NULL,
  `IdEstado` int(11) DEFAULT NULL,
  `FechaCambio` datetime DEFAULT NULL,
  `nombreusr` varchar(100) DEFAULT NULL,
  `correousr` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`idBitacoraCambio`,`idDetalleComplemento`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Bitacora de cambios en la cadena, usuarios ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BitacoraCambio`
--

LOCK TABLES `BitacoraCambio` WRITE;
/*!40000 ALTER TABLE `BitacoraCambio` DISABLE KEYS */;
INSERT INTO `BitacoraCambio` VALUES (1,1,1,'2019-10-21 18:19:04','jcmaeda','jcmaeda@gmail.com'),(2,2,1,'2019-10-21 18:21:41','jcmaeda','jcmaeda@gmail.com'),(3,3,1,'2019-10-21 18:24:49','jcmaeda','jcmaeda@gmail.com'),(4,4,1,'2019-10-22 13:35:38','jcmaeda','jcmaeda@gmail.com'),(5,5,1,'2019-10-22 13:36:38','jcmaeda','jcmaeda@gmail.com'),(18,16,5,'2019-10-26 18:36:14','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(19,17,5,'2019-10-26 18:36:36','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(20,18,5,'2019-10-26 18:38:05','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(21,19,5,'2019-10-26 18:38:36','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(22,20,5,'2019-10-26 18:40:03','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(23,21,5,'2019-10-26 18:43:16','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(25,17,6,'2019-10-27 01:58:48','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(26,18,6,'2019-10-27 01:59:01','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(27,19,6,'2019-10-27 02:07:31','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(28,20,6,'2019-10-27 02:08:12','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(29,21,6,'2019-10-27 02:08:57','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(111,17,6,'2019-10-28 05:19:47','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(112,17,6,'2019-10-28 05:20:24','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(113,18,6,'2019-10-28 05:22:50','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(114,19,6,'2019-10-28 05:22:50','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(115,20,6,'2019-10-28 05:22:50','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(116,21,6,'2019-10-28 05:22:50','Juan Carlos Maeda','jcarlosmaeda@gmail.com'),(117,18,7,'2019-10-28 05:23:17','Admin','admin@gmail.com'),(118,19,7,'2019-10-28 05:23:17','Admin','admin@gmail.com'),(119,20,7,'2019-10-28 05:23:17','Admin','admin@gmail.com'),(120,21,7,'2019-10-28 05:23:17','Admin','admin@gmail.com');
/*!40000 ALTER TABLE `BitacoraCambio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cadena`
--

DROP TABLE IF EXISTS `Cadena`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cadena` (
  `idDetalleComplemento` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Correlativo del detalle del complemento de la cadena',
  `idComplemento` int(11) NOT NULL COMMENT 'Identificador del complemento',
  `idLocalizacion` int(11) NOT NULL COMMENT 'Idioma o lenguaje de la cadena',
  `idEstado` int(11) NOT NULL COMMENT 'Estado de la cadena',
  `cadena` longtext COMMENT 'Cadena',
  `nombreusr` varchar(100) DEFAULT NULL COMMENT 'Nombre de usuario que trabajo la cadena',
  `correousr` varchar(150) DEFAULT NULL,
  `idCadenaOriginal` int(11) DEFAULT NULL COMMENT 'Cadena original a la que pertence la traduccion, para el primer caso o la cadena orignal este valor es null',
  PRIMARY KEY (`idDetalleComplemento`,`idComplemento`,`idLocalizacion`,`idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda las cadenas de los complementos, por cada complemento N cadenas ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cadena`
--

LOCK TABLES `Cadena` WRITE;
/*!40000 ALTER TABLE `Cadena` DISABLE KEYS */;
INSERT INTO `Cadena` VALUES (1,8,5,1,'Login','jcmaeda','jcmaeda@gmail.com',NULL),(2,8,5,1,'User','jcmaeda','jcmaeda@gmail.com',NULL),(3,8,5,1,'Password','jcmaeda','jcmaeda@gmail.com',NULL),(4,8,5,1,'Return','jcmaeda','jcmaeda@gmail.com',NULL),(5,8,5,1,'Welcome','jcmaeda','jcmaeda@gmail.com',NULL),(6,6,5,1,'Welcome','jcmaeda','jcmaeda@gmail.com',NULL),(7,6,5,1,'Menu','jcmaeda','jcmaeda@gmail.com',NULL),(10,6,3,5,'Menu','Juan Maeda','jcarlosmaeda@gmail.com',7),(11,6,3,5,'Bienvenido','Juan Maeda','jcarlosmaeda@gmail.com',6),(12,6,5,1,'About','Juan Carlos Maeda','jcarlosmaeda@gmail.com',NULL),(13,6,3,5,'Acerca de','Juan Carlos Maeda','jcarlosmaeda@gmail.com',12),(14,6,5,1,'Close','Juan Carlos Maeda','jcarlosmaeda@gmail.com',NULL),(15,6,3,5,'Cerrar','Juan Carlos Maeda','jcarlosmaeda@gmail.com',14),(17,8,3,5,'Contrase;a','Juan Carlos Maeda','jcarlosmaeda@gmail.com',3),(18,8,3,5,'Usuario','Juan Carlos Maeda','jcarlosmaeda@gmail.com',2),(19,8,3,5,'Binvenido','Juan Carlos Maeda','jcarlosmaeda@gmail.com',5),(20,8,3,5,'Retornar','Juan Carlos Maeda','jcarlosmaeda@gmail.com',4),(21,8,3,5,'Ingreso','Juan Carlos Maeda','jcarlosmaeda@gmail.com',1);
/*!40000 ALTER TABLE `Cadena` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cliente`
--

DROP TABLE IF EXISTS `Cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cliente` (
  `idCliente` int(11) NOT NULL AUTO_INCREMENT,
  `IP` varchar(20) DEFAULT NULL,
  `idEstado` int(11) DEFAULT NULL,
  `fechasuscripcion` datetime DEFAULT NULL,
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de Clientes del servicio de Almacenamiento, este microservicios que se subscribiran';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cliente`
--

LOCK TABLES `Cliente` WRITE;
/*!40000 ALTER TABLE `Cliente` DISABLE KEYS */;
INSERT INTO `Cliente` VALUES (1,'20.190.200.34',1,'2019-10-28 05:35:36');
/*!40000 ALTER TABLE `Cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Complemento`
--

DROP TABLE IF EXISTS `Complemento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Complemento` (
  `idComplemento` int(11) NOT NULL AUTO_INCREMENT,
  `Complemento` varchar(60) NOT NULL,
  `nombreusr` varchar(100) NOT NULL COMMENT 'Nombre del usuario que ha creado el complemento',
  `correousr` varchar(150) NOT NULL COMMENT 'Correo del usuario que ha creado el contenedor',
  `idEstado` int(11) DEFAULT NULL COMMENT 'Llave foranea de Estados',
  PRIMARY KEY (`idComplemento`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla en donde se guardan los complementos, y la o las localizaciones originales, aunque debe ser una sola ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Complemento`
--

LOCK TABLES `Complemento` WRITE;
/*!40000 ALTER TABLE `Complemento` DISABLE KEYS */;
INSERT INTO `Complemento` VALUES (8,'WordPress Login','jcmaeda','jcmaeda@gmail.com',1),(9,'WordPress Galery','Juan Carlos Maeda','jcarlosmaeda@gmail.com',1);
/*!40000 ALTER TABLE `Complemento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ComplementoLocalizacion`
--

DROP TABLE IF EXISTS `ComplementoLocalizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ComplementoLocalizacion` (
  `idComplemento` int(11) NOT NULL,
  `idLocalizacion` int(11) NOT NULL,
  `idEstado` int(11) NOT NULL,
  `Ruta` varchar(500) DEFAULT NULL COMMENT 'Ruta del archivo que guardara el complemento',
  PRIMARY KEY (`idComplemento`,`idLocalizacion`,`idEstado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Por cada complemento se debe guardar la localizacion y el lenguaje, la ruta del archivo';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ComplementoLocalizacion`
--

LOCK TABLES `ComplementoLocalizacion` WRITE;
/*!40000 ALTER TABLE `ComplementoLocalizacion` DISABLE KEYS */;
INSERT INTO `ComplementoLocalizacion` VALUES (8,3,1,NULL),(8,5,1,NULL),(9,5,1,NULL);
/*!40000 ALTER TABLE `ComplementoLocalizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Localizacion`
--

DROP TABLE IF EXISTS `Localizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Localizacion` (
  `idLocalizacion` int(11) NOT NULL AUTO_INCREMENT,
  `Localizacion` varchar(45) DEFAULT NULL,
  `Internalizacion` varchar(45) DEFAULT NULL,
  `idEstado` int(11) DEFAULT NULL COMMENT 'LLave foranea de los estados',
  PRIMARY KEY (`idLocalizacion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla que guarda las localizaciones que se pueden utilizar en el sistema	';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Localizacion`
-- 
/*!40000 ALTER TABLE `Localizacion` DISABLE KEYS */;
-- INSERT INTO `Localizacion` VALUES (3,'UA-08','US-EN',1),(5,'UA-09','US-ES',1);
INSERT INTO `Localizacion` VALUES (3, 'de', 'alemán', 1);
INSERT INTO `Localizacion` VALUES (4, 'en_CA', 'inglés [Canadá]', 1);
INSERT INTO `Localizacion` VALUES (5, 'en_US', 'inglés [Estados Unidos]', 1);
INSERT INTO `Localizacion` VALUES (6, 'es_GT', 'español [Guatemala]', 1);
INSERT INTO `Localizacion` VALUES (7, 'es_MX', 'español [México]', 1);
INSERT INTO `Localizacion` VALUES (8, 'fr', 'francés', 1);
INSERT INTO `Localizacion` VALUES (9, 'it', 'italiano', 1);
INSERT INTO `Localizacion` VALUES (10, 'ja', 'japonés', 1);
INSERT INTO `Localizacion` VALUES (11, 'ko', 'coreano', 1);
INSERT INTO `Localizacion` VALUES (12, 'zh', 'chino', 1);
/*!40000 ALTER TABLE `Localizacion` ENABLE KEYS */;
 

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `idEstado` int(11) NOT NULL AUTO_INCREMENT,
  `Estado` varchar(45) NOT NULL,
  PRIMARY KEY (`idEstado`),
  UNIQUE KEY `idEstado_UNIQUE` (`idEstado`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabla de Estados de los Complementos';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,'Activo'),(3,'Inactivo'),(5,'Traducido'),(6,'Aprobado'),(7,'Completado');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table1`
--

DROP TABLE IF EXISTS `table1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(6000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table1`
--

LOCK TABLES `table1` WRITE;
/*!40000 ALTER TABLE `table1` DISABLE KEYS */;
INSERT INTO `table1` VALUES (1,'Mail,Send,Recived,Attached');
/*!40000 ALTER TABLE `table1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'Almacenamiento'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoEliminaComplemento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoEliminaComplemento`(IN iidcomplemento int)
BEGIN
	Declare	varidcomplemento int;
    Declare varidlocalizacion int;
   /*  DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al eliminar Complemento ' mensaje;               
	  END;
    */
    
	if iidcomplemento = 0 then
		select idComplemento into varidcomplemento from Complemento where Complemento = iComplemento;
	else 
		set varidcomplemento = iidcomplemento;
    end if;
    delete from ComplementoLocalizacion where idComplemento = varidcomplemento;   
    if (select count(*) from ComplementoLocalizacion where idComplemento = varidcomplemento) = 0 then
     SET SQL_SAFE_UPDATES = 0;
		delete BC
		from BitacoraCambio BC,Cadena C
		where BC.idDetalleComplemento = C.idDetalleComplemento 
		and C.idComplemento = varidComplemento;
        delete from Cadena where idComplemento = varidComplemento;
	SET SQL_SAFE_UPDATES = 1;
       delete from Complemento where idComplemento = varidcomplemento;
          
	  select '200' Estado, 'OK' Mensaje, 'data' data, 'Se elimino el complemento y la localizacion correctamente.' Nombre;
   else
      select '401' Estado,'Error al eliminar el complemento' Mensaje;
	end if; 
    
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoEliminarCatalogo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoEliminarCatalogo`(IN idCatalogo int, IN localizacion varchar(25), IN Internacionalizacion varchar(25))
BEGIN
	declare varidCatalogo int;
    select idLocalizacion into varidCatalogo from Localizacion where (Localizacion = localizacion or Internalizacion = Internacionalizacion);
	delete from Localizacion where idLocalizacion = varidCatalogo;
    if (select count(*) from Localizacion where (idLocalizacion = idCatalogo or Localizacion = localizacion or Internalizacion = Internacionalizacion)) = 0 then
    	select '200' Estado, 'OK' Mensaje, 'data' data, 'Se elimino correctamente la Localizacion' Nombre;
	else
			select '401' Estado,'Error al eliminar el catalogo' Mensaje;
	end if; 
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoInsertaCadena` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_almacenamientoInsertaCadena`(
	_Complemento varchar(60),
    _Localizacion varchar(10),
  	_cadena varchar(16383),
    _nombreusr varchar(100),
    _correousr varchar(150)
)
BEGIN

	declare _iddetalleComplemento int;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al insertar la cadena ' mensaje;               
	  END;
      If (select count(*) from Localizacion where (Localizacion = _Localizacion) ) = 0 Then
			call sp_almacenamientoInsertaLocalizacion(_Localizacion,_internacionalizacion);
        end if;
      
		set  @idComplemento = (select idComplemento  from Complemento where Complemento = _Complemento limit 1);

        
		set @idLocalizacion  = (select  idlocalizacion from Localizacion where (Localizacion = _Localizacion) limit 1); 
        set @idEstado = (select  idEstado from estado where Estado = 'Activo' limit 1);
        
        if (select count(*) from Cadena where IdComplemento = @idComplemento and idlocalizacion = @idlocalizacion and cadena = _cadena) = 0 then
			insert into Cadena (IdComplemento, idLocalizacion, IdEstado, cadena,nombreusr, correousr)
			values (@idComplemento,@idLocalizacion,@idEstado,_cadena,_nombreusr,_correousr);      
		end if;
		
		set _iddetalleComplemento = (select idDetalleComplemento  from Cadena where IdComplemento = @idComplemento and idlocalizacion = @idlocalizacion and cadena = _cadena);
        
      
        insert into BitacoraCambio (idDetalleComplemento,IdEstado,FechaCambio,nombreusr,correousr)
		values (_iddetalleComplemento,@idEstado,now(),_nombreusr,_correousr);    
 		
        
        select 200 estado, concat('Cadena agregada correctamente al complemento ',_Complemento) Mensaje;
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoInsertaComplemento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;

-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoInsertaComplemento;


DELIMITER ;;
CREATE PROCEDURE `sp_almacenamientoInsertaComplemento`(IN nombreusr varchar(100),IN correousr varchar(150),IN icomplemento varchar(50),IN ilocalizacion varchar(15),_cadena varchar(6500))
BEGIN
	declare vaidEstado int;
    declare vaidLocalizacion int;
    declare vaidComplemento int;
    declare Ruta varchar(500);
         
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
			select 401 estado, 'Error al crear complemento' mensaje;				 	          
	  END;
     


	 
	-- Busca el estado activo y si no está lo inserta  
    select idEstado INTO vaidEstado from estado where Estado = 'Activo' limit 1;


    if (select count(*) from Complemento where Complemento = iComplemento) = 0 then
		insert into Complemento (Complemento,nombreusr,correousr,idEstado) values (icomplemento,nombreusr,correousr,vaidEstado);   
	end if;
    set Ruta = null;

    select idComplemento INTO vaidComplemento from Complemento where Complemento = iComplemento limit 1;


 
	If (select count(*) from Localizacion where (Localizacion = ilocalizacion) ) = 0 Then
		call sp_almacenamientoInsertaLocalizacion(ilocalizacion,ilocalizacion);
	end if;
 
    select idlocalizacion INTO vaidLocalizacion from Localizacion where Localizacion = ilocalizacion limit 1;
   
   
	If (select count(*) from ComplementoLocalizacion where (idComplemento = vaidComplemento AND idLocalizacion=vaidLocalizacion AND idEstado=vaidEstado ) ) = 0 Then
		insert into ComplementoLocalizacion (idComplemento,idLocalizacion,idEstado,Ruta) 
		values(vaidComplemento,vaidLocalizacion,vaidEstado,Ruta);
	end if;


   
    truncate table table1;
	insert into table1 (value) values(_cadena);
   

    insert into Cadena (idComplemento,idLocalizacion,idEstado,nombreusr,correousr,cadena)
	SELECT
	  vaidComplemento,vaidLocalizacion,vaidEstado,nombreusr,correousr,
	  SUBSTRING_INDEX(SUBSTRING_INDEX(value, ',', n.digit+1), ',', -1) Valor
	FROM
	  table1
	  INNER JOIN
	  (SELECT 0 digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) n
	  ON LENGTH(REPLACE(value, ',' , '')) <= LENGTH(value)-n.digit
	ORDER BY
	  id,
	  n.digit;
	 
    
    
        
    if (select count(*) from Complemento where Complemento = Complemento) > 0 then
    	select '200' Estado, 'OK' Mensaje, concat('Se Inserto correctamente el Complemento ', iComplemento) Nombre;
	end if;    
END ;;
DELIMITER ;

-- call sp_almacenamientoInsertaComplemento ('nombre_creador','corrego1@gmail.com','ENGLISH','en_us','asdf');

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoInsertaEstado` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoInsertaEstado`(IN inEstado varchar(25))
BEGIN 
	if (select count(*) from estado where Estado = inEstado) = 0 then
		INSERT INTO estado
		(     
		Estado)
		VALUES
		(
		inEstado);
    end if;
	if exists (select * from estado where Estado = inEstado) then
		select '200' Estado, 'OK' Mensaje, 'data' data, inEstado Nombre;
    else
		select '401' Estado,'Error al crear el estado' Mensaje;
    end if;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoInsertaLocalizacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;

-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoInsertaLocalizacion;


DELIMITER ;;
CREATE PROCEDURE `sp_almacenamientoInsertaLocalizacion`(in localizacion varchar(10), in internacionalizacion varchar(10) )
BEGIN
	declare varEstado int;
    select idEstado INTO varEstado from estado where Estado = 'Activo';
   	if (select count(*) from Localizacion where (Localizacion  = localizacion and Internalizacion = internacionalizacion)) = 0 then
		Insert Into Localizacion
			(Localizacion,Internalizacion,idEstado)
			Values
			(localizacion,internacionalizacion,varEstado);
		end if;
        if exists (select idLocalizacion from Localizacion where (Localizacion = localizacion or Internalizacion = internacionalizacion)) then
			select '200' Estado, 'OK' Mensaje, 'data' data, localizacion Nombre;
		else
			select '401' Estado,'Error al crear el la localizacion' Mensaje;
		end if;
END ;;
DELIMITER ;


-- CALL sp_almacenamientoInsertaLocalizacion( 'as', 'asd');
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoInsertaTraduccion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;


-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoInsertaTraduccion;

DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoInsertaTraduccion`(
_Complemento varchar(60),_idComplementov int,_LocalizacionOriginal varchar(10),_Localizacion varchar(10),
	_cadenaOrginal varchar(16383),_cadena varchar(16383),_nombreusr varchar(100),_correousr varchar(150),
    _opcion int
)
BEGIN
	  declare _idComplemento int;
      declare _idLocalizacion int;
      declare _idCadenaOriginal int;
      declare _idestado int;
      declare _iddetallecomplemento int;
      declare _idLocalizacionOriginal int;
      DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	  BEGIN
		select 401 estado,'Error al insertar la traduccion ' mensaje;               
	  END;
		set _idComplemento = _idComplementov;
		-- set _idComplemento = (select idComplemento from Complemento where Complemento = _Complemento);
		set _idComplemento = _idComplementov;
		set _idLocalizacion = (select idLocalizacion from Localizacion where lower(trim(Localizacion)) = lower(trim(_Localizacion)) limit 1);
		set _idLocalizacionOriginal = (select idLocalizacion from Localizacion where lower(trim(Localizacion)) = lower(trim(_LocalizacionOriginal)) limit 1);
		set _idestado = (select idestado from estado where Estado = 'Traducido');
		set _idCadenaOriginal = (select idDetalleComplemento from Cadena 
								  where idComplemento = _idComplemento 
								  and idLocalizacion = _idLocalizacionOriginal
								  and lower(trim(cadena)) = lower(trim(_cadenaOrginal)) and idCadenaOriginal is null limit 1);
      
      /*Se puede utilizar el mismo procedimiento para insertar y para aprobar una traduccion,
        el parametro opcion 1 para insertar una traducicon, y 0 para aprobarlas*/
		/*Hace las busquedas de los identificadores*/
        if _opcion = 1 then
        			
			insert into Cadena (idComplemento,idLocalizacion,idEstado,cadena,nombreusr,correousr,idCadenaOriginal)
			values (_idComplemento,_idLocalizacion,_idestado, _cadena,_nombreusr,_correousr,_idCadenaOriginal);
			
			set _iddetallecomplemento = (select iddetallecomplemento from Cadena 
											where idComplemento = _idComplemento
											and idEstado = _idestado
											and lower(trim(cadena)) = lower(trim(_cadena))
											and idLocalizacion = _idLocalizacion limit 1);
										   
			insert into BitacoraCambio (idDetalleComplemento,IdEstado,FechaCambio,nombreusr,correousr)
			values (_iddetallecomplemento,_idestado,now(),_nombreusr,_correousr);
			select 200 estado, 'Traduccion insertada correctamente';
		else
			set _iddetallecomplemento = (select iddetallecomplemento 
										 from Cadena 
										 where idComplemento = _idComplemento
											and idEstado = _idestado
											and lower(trim(cadena)) = lower(trim(_cadena))
											and idLocalizacion = _idLocalizacion);
			set _idestado = (select idestado from estado where Estado = 'Aprobado');
            if (select count(*) from BitacoraCambio where idDetalleComplemento = _iddetallecomplemento and idestado = _idestado) < 2 then
				insert into BitacoraCambio (idDetalleComplemento,IdEstado,FechaCambio,nombreusr,correousr)
				values (_iddetallecomplemento,_idestado,now(),_nombreusr,_correousr);
                select 200 estado, concat('Aprobacion de traduccion ',lower(trim(_cadena))) mensaje;
			else
				select 201 estado, concat('La cadena tiene suficientes aprobaciones, es una cadena limpia ',lower(trim(_cadena))) mensaje;
			end if;
            
		end if;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoObtenerCatalogo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoObtenerCatalogo`(IN _idComplemento int,IN _Complemento varchar(100))
BEGIN
	if (_idComplemento != 0 or _Complemento is not null) then
		SELECT 200 Estado, 'OK' Mensaje, CO.idComplemento,CO.Complemento,L.Localizacion LocalizacionOriginal,L1.Localizacion LocalizacionTraduccion, C.Cadena msgid, C1.Cadena msgstr,ifnull(count(BC.idDetalleComplemento),0) numeroAprobaciones
		from Cadena C
		inner join Cadena C1 on C.idDetalleComplemento = C1.idCadenaOriginal
		inner join Localizacion L on C.idLocalizacion = L.idLocalizacion
		inner join Localizacion L1 on C1.idLocalizacion = L1.idLocalizacion
		inner join Complemento CO on CO.idComplemento = C.idComplemento
		left join BitacoraCambio BC on BC.idDetalleComplemento = C1.idDetalleComplemento and BC.IdEstado in (select idEstado from estado where estado = 'Aprobado')
        where (CO.idComplemento = _idComplemento or CO.Complemento = _Complemento) 
		group by CO.idComplemento,CO.Complemento,L.Localizacion,L1.Localizacion, C.Cadena , C1.Cadena;
    else
		SELECT 200 Estado, 'OK' Mensaje, CO.idComplemento,CO.Complemento,L.Localizacion LocalizacionOriginal,L1.Localizacion LocalizacionTraduccion, C.Cadena msgid, C1.Cadena msgstr,ifnull(count(BC.idDetalleComplemento),0) numeroAprobaciones
		from Cadena C
		inner join Cadena C1 on C.idDetalleComplemento = C1.idCadenaOriginal
		inner join Localizacion L on C.idLocalizacion = L.idLocalizacion
		inner join Localizacion L1 on C1.idLocalizacion = L1.idLocalizacion
		inner join Complemento CO on CO.idComplemento = C.idComplemento
		left join BitacoraCambio BC on BC.idDetalleComplemento = C1.idDetalleComplemento and BC.IdEstado in (select idEstado from estado where estado = 'Aprobado')
		group by CO.idComplemento,CO.Complemento,L.Localizacion,L1.Localizacion, C.Cadena , C1.Cadena;
	end if;
END ;;
DELIMITER ;




-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoObtenerCatalogo2;

DELIMITER ;;
CREATE PROCEDURE `sp_almacenamientoObtenerCatalogo2`(IN _idComplemento int,IN _Complemento varchar(100))
BEGIN

SELECT 200 Estado, 'OK' Mensaje, CO.idComplemento,CO.Complemento,L.Localizacion LocalizacionOriginal,L1.Localizacion LocalizacionTraduccion, C.Cadena msgid, C1.Cadena msgstr,ifnull(count(BC.idDetalleComplemento),0) numeroAprobaciones
from Cadena C
inner join Cadena C1 on C.idDetalleComplemento = C1.idCadenaOriginal
inner join Localizacion L on C.idLocalizacion = L.idLocalizacion
inner join Localizacion L1 on C1.idLocalizacion = L1.idLocalizacion
inner join Complemento CO on CO.idComplemento = C.idComplemento
left join BitacoraCambio BC on BC.idDetalleComplemento = C1.idDetalleComplemento and BC.IdEstado in (select idEstado from estado where estado = 'Aprobado')
where (CO.idComplemento = _idComplemento) 
group by CO.idComplemento,CO.Complemento,L.Localizacion,L1.Localizacion, C.Cadena , C1.Cadena


	UNION DISTINCT

SELECT 
	200 Estado, 'OK' Mensaje,CO.idComplemento, CO.Complemento,L.Localizacion LocalizacionOriginal,'de' LocalizacionTraduccion, C.Cadena msgid,'' msgstr, 0 numeroAprobaciones
from 
	Cadena C
inner join 
	Complemento CO on CO.idComplemento = C.idComplemento
inner join 
	Localizacion L on C.idLocalizacion = L.idLocalizacion
	
	
where 
	C.idComplemento =_idComplemento and  C.idDetalleComplemento not in 
	( 
		select 
			T.idDetalleComplemento from Cadena T
		inner join 
			Cadena C1 on T.idDetalleComplemento = C1.idCadenaOriginal
		where 
		 T.idComplemento =_idComplemento

		UNION DISTINCT

		select 
			idDetalleComplemento from Cadena
		where 
			idCadenaOriginal is not null and idComplemento =_idComplemento	 
	 )
;
END ;;
DELIMITER ;









/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoObtenerCatalogoTraducciones` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoObtenerCatalogoTraducciones`()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al listar las traducciones Aprobadas ' mensaje;               
	  END;


	CREATE TEMPORARY TABLE tmpTraducidos 
		(
			tmpid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
		)
	SELECT 200 Estado, 'OK' Mensaje, CO.idComplemento,CO.Complemento,L.Localizacion LocalizacionOriginal,L1.Localizacion LocalizacionTraduccion, C.Cadena msgid, C1.Cadena msgstr,ifnull(count(BC.idDetalleComplemento),0) numeroAprobaciones
	from Cadena C
	inner join Cadena C1 on C.idDetalleComplemento = C1.idCadenaOriginal
	inner join Localizacion L on C.idLocalizacion = L.idLocalizacion
	inner join Localizacion L1 on C1.idLocalizacion = L1.idLocalizacion
	inner join Complemento CO on CO.idComplemento = C.idComplemento
	left join BitacoraCambio BC on BC.idDetalleComplemento = C1.idDetalleComplemento and BC.IdEstado in (select idEstado from estado where estado = 'Aprobado')
    where C1.idDetalleComplemento not in  (select idDetalleComplemento from BitacoraCambio where IdEstado = 7)
	group by CO.idComplemento,CO.Complemento,L.Localizacion,L1.Localizacion, C.Cadena , C1.Cadena;
    
    insert into BitacoraCambio (idDetalleComplemento,idEstado,FEchaCambio,nombreusr,correousr)
	select distinct BC.idDetalleComplemento,7,now(),'Admin','admin@gmail.com'
    from tmpTraducidos T
    inner join Cadena C on C.idComplemento = T.idComplemento and T.msgstr = C.Cadena
    inner join BitacoraCambio BC on BC.idDetalleComplemento = C.idDetalleComplemento and BC.IdEstado = 6
    where numeroAprobaciones = 2;

	select * from tmpTraducidos  where numeroAprobaciones = 2;

	drop table tmpTraducidos;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoObtenerComplemento` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoObtenerComplemento`(IN iidcomplemento int,IN icomplemento varchar(60))
BEGIN
   DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
			select 401 estado, 'Error al Obtener complemento' mensaje;				 	          
	  END;
     
      if iidcomplemento > 0 or icomplemento is not null then		
      	 SELECT 200 estado, 'OK' mensaje,Complemento nombre,idComplemento,(select L.Localizacion from ComplementoLocalizacion CL,Localizacion L  where idComplemento = Complemento.idComplemento and L.idLocalizacion = CL.idLocalizacion limit 1) LocalizacionOriginal,nombreusr,correousr, GROUP_CONCAT(Localizacion) localizaciones
		 FROM Complemento
			INNER JOIN ComplementoLocalizacion USING (idComplemento)
			INNER JOIN Localizacion USING (idLocalizacion)
		 where idComplemento = iidcomplemento or Complemento = icomplemento
		 GROUP BY idComplemento;
	else
		 SELECT 200 estado, 'OK' mensaje,Complemento nombre,idComplemento,(select L.Localizacion from ComplementoLocalizacion CL,Localizacion L  where idComplemento = Complemento.idComplemento and L.idLocalizacion = CL.idLocalizacion limit 1) LocalizacionOriginal,nombreusr,correousr, GROUP_CONCAT(Localizacion) localizaciones
		 FROM Complemento
			INNER JOIN ComplementoLocalizacion USING (idComplemento)
			INNER JOIN Localizacion USING (idLocalizacion)
		 GROUP BY idComplemento;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoObtenerComplementoId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoObtenerComplementoId`(IN _idComplemento int)
BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
			select 401 estado, 'Error al Obtener complemento' mensaje;				 	          
	  END;


		SELECT 200 estado, 'OK' mensaje,Complemento nombre,CO.idComplemento,(select L.Localizacion from ComplementoLocalizacion CL,Localizacion L  where idComplemento = CO.idComplemento and L.idLocalizacion = CL.idLocalizacion limit 1) LocalizacionOriginal,CO.nombreusr,CO.correousr, GROUP_CONCAT(distinct Localizacion) localizaciones,GROUP_CONCAT(Cadena) Cadenas
		 FROM Complemento CO
			INNER JOIN ComplementoLocalizacion CL on CO.idComplemento = CL.idComplemento
			INNER JOIN Localizacion L on CL.idLocalizacion = L.idLocalizacion
            INNER JOIN Cadena C on C.idComplemento = CO.idComplemento and CL.IdLocalizacion = C.idLocalizacion
		 where CO.idComplemento = _idComplemento
		 GROUP BY CO.idComplemento;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoObtenerLocalizacion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoObtenerLocalizacion`()
BEGIN
	select 200 estado,'OK', localizacion from Localizacion;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientoRetornaCadena` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_almacenamientoRetornaCadena`(
)
BEGIN
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado, 'Error al Retornar cadenas' mensaje;		                   
	  END;
	  	 
      CREATE TEMPORARY TABLE tmpComplemento1 
		(
			tmpid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
		)
		SELECT 200 estado, 'OK' mensaje,idComplemento,Complemento nombreComplemento, GROUP_CONCAT(Localizacion) localizaciones,nombreusr nombre,correousr correo
		FROM Complemento
		INNER JOIN ComplementoLocalizacion USING (idComplemento)
		INNER JOIN Localizacion USING (idLocalizacion)
		GROUP BY idComplemento;

		CREATE TEMPORARY TABLE tmpComplemento 
		(
			tmpid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
		)
		select * from tmpComplemento1;


		select estado,mensaje,idComplemento,nombreComplemento,localizaciones localizacionOriginal,nombre,correo,null cadena ,null localizacion 
		from tmpComplemento1
		where not exists (select * from Cadena where Cadena.IdComplemento = tmpComplemento1.IdComplemento)
		union all
		select distinct estado,mensaje,tmpComplemento.idComplemento,nombreComplemento,localizaciones localizacionOriginal,nombre,correo,group_concat(distinct cadena) cadena ,group_concat(distinct localizacion) localizacion
		from tmpComplemento
		inner JOIN Cadena using (idComplemento)
		inner join Localizacion using (idLocalizacion)
		group by estado,mensaje,idComplemento,nombreComplemento,localizaciones,idlocalizacion,nombre,correo;

		drop table tmpComplemento;		
		drop table tmpComplemento1;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_almacenamientosuscripcion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientosuscripcion`(IN _ip varchar(20))
BEGIN
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al insertar la suscripcion ' mensaje;               
	  END;
      
      insert into Cliente (IP,idEstado,fechasuscripcion)
      values (_ip,1,now());
      select 200 codigo, 'Suscrito corretamente' mensaje;
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_traducidoscomplementoTraducido` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;



-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_traducidoscomplementoTraducido;


DELIMITER ;;
CREATE PROCEDURE `sp_traducidoscomplementoTraducido`()
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	  BEGIN
		select 401 estado,'Error al listar las traducciones Aprobadas ' mensaje;               
	  END;


	/*
	CREATE temporary  TABLE tmpTraducidos 
		(
			tmpid INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
		)
	*/
	Select CO.nombreusr nombre,CO.correousr correo,CO.complemento nombre,L.Localizacion localizacionoriginal,L1.Localizacion localizaciontraduccion,C.Cadena msgid, C1.Cadena msgstr
	from Cadena C
	inner join Cadena C1 on C.idDetalleComplemento = C1.idCadenaOriginal
	inner join Localizacion L on C.idLocalizacion = L.idLocalizacion
	inner join Localizacion L1 on C1.idLocalizacion = L1.idLocalizacion
	inner join Complemento CO on CO.idComplemento = C.idComplemento
	left join BitacoraCambio BC on BC.idDetalleComplemento = C1.idDetalleComplemento and BC.IdEstado in (select idEstado from estado where estado = 'Aprobado')
    where C1.idDetalleComplemento not in  (select idDetalleComplemento from BitacoraCambio where IdEstado = 7)
	group by CO.idComplemento,CO.Complemento,L.Localizacion,L1.Localizacion, C.Cadena , C1.Cadena;
    /*
    insert into BitacoraCambio (idDetalleComplemento,idEstado,FEchaCambio,nombreusr,correousr)
	select distinct BC.idDetalleComplemento,7,now(),'Admin','admin@gmail.com'
    from tmpTraducidos T
    inner join Cadena C on C.idComplemento = T.idComplemento and T.msgstr = C.Cadena
    inner join BitacoraCambio BC on BC.idDetalleComplemento = C.idDetalleComplemento and BC.IdEstado = 6
    where numeroAprobaciones = 2;

	select * from tmpTraducidos  where numeroAprobaciones = 2;

	drop table tmpTraducidos;
	*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-10-28 11:00:41
