
/*
+-----------------------------------------------
| Insertar Estado
+-----------------------------------------------
| Author:		Grupo 2
| Create date: 2019-10-06
| Description:	Inserta estado en la tabla de estados, devuelve un string con formato json
*/

-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS insertarEstado;

DELIMITER ;;
CREATE PROCEDURE  insertarEstado
(
    IN v_estado  varchar(100)
)
BEGIN
DECLARE resultado text;

	-- EXCEPCIÓN DE ERROR 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		SET @resultado = '{
						 "estado": "401",
						 "mensaje":"Error al Crear Estado"
						}
						';
		SELECT @resultado;
	END;
    
    -- TRANSACCIÓN SIN ERROR
	START TRANSACTION;
		insert into ESTADO(estado) values(v_estado);
		SET @resultado = concat('{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "',v_estado, '"							 
							}
						}
					');
		COMMIT;
		SELECT @resultado;
END;;
DELIMITER ;

 

-- PRUEBA LLAMADA A PROCEDIMIENTO
-- CALL insertarEstado("ESTADO99");


/*
+-----------------------------------------------
| Insertar localización
+-----------------------------------------------
| Author:		Grupo 2
| Create date: 2019-10-06
| Description:	Inserta una nueva localización
*/

-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoInsertaLocalizacion;

-- PROCEDIMIENTO
DELIMITER ;;
CREATE PROCEDURE  sp_almacenamientoInsertaLocalizacion
(
    IN p_localizacion  varchar(100),
    IN p_internacionalizacion varchar(100)
)
BEGIN

DECLARE v_idEstado INT DEFAULT 0;
DECLARE resultado text;

	-- EXCEPCIÓN DE ERROR 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		SET @resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al crear la Localizacion"
						}
						';
		SELECT @resultado;
	END;
    
    -- TRANSACCIÓN SIN ERROR
	START TRANSACTION;
     
		-- Busca el estado activo y si no está lo inserta
		IF (SELECT count(*) FROM Estado where Estado = 'Activo') < 1 then
			CALL insertarEstado("Activo");
		END IF; 
 
		-- Obteniendo el idEstado
		SELECT idEstado into v_idEstado FROM Estado where Estado = 'Activo' limit 1;

        -- inserta en la tabla de localizcaion.
    	INSERT  INTO 
			localizacion (localizacion,internacionalizacion, idEstado)
		VALUES (p_localizacion, p_internacionalizacion, idEstado);

         SET @resultado = concat( ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre":  "',v_idEstado, '"							 
							}
						}
					'); 
					
		COMMIT;
		SELECT @resultado;
	
END;;
DELIMITER ;

 

-- PRUEBA LLAMADA A PROCEDIMIENTO
-- CALL sp_almacenamientoInsertaLocalizacion("en_us", "en_us");


/*
+-----------------------------------------------
| Insertar complemento
+-----------------------------------------------
| Author:		Grupo 2
| Create date: 2019-10-06
| Description:	Inserta un nuevo complemento
*/
  
-- ELIMINAR PROCEDIMIENTO 
DROP PROCEDURE IF EXISTS sp_almacenamientoInsertaComplemento;

-- PROCEDIMIENTO
DELIMITER ;;
CREATE PROCEDURE  sp_almacenamientoInsertaComplemento
(
    p_complemento varchar(100),
    p_nombreusr varchar(100),
    p_correousr varchar(100),
    p_localizacion varchar(100)
)
BEGIN
DECLARE v_idLocalizacion int;
DECLARE v_idEstado int;
declare resultado text;

	-- EXCEPCIÓN DE ERROR 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN
		SET @resultado = '{
					 	 "estado": "401",
						 "mensaje":"Error al Crear el Complemento"
						}
						';
		SELECT @resultado;
	END;
    
    -- TRANSACCIÓN SIN ERROR
	START TRANSACTION;
    
		-- Si no existe la localizacion se crea
		IF  (SELECT COUNT(*) FROM Localizacion WHERE (internacionalizacion = p_localizacion or localizacion = p_localizacion))  < 1 THEN
			CALL sp_almacenamientoInsertaLocalizacion( p_localizacion, p_localizacion);
		END IF;
        

		-- Busca el estado activo y si no está lo inserta
		IF (SELECT COUNT(*) FROM Estado where Estado = 'Activo') < 1 then
			CALL insertarEstado("Activo");
		END IF; 



		-- Obteniendo el idEstado
		SELECT idEstado into v_idEstado FROM Estado where Estado = 'Activo' limit 1;

		-- Obteniendo el localización
		SELECT idLocalizacion into v_idLocalizacion FROM Localizacion where (internacionalizacion = p_localizacion or localizacion = p_localizacion) limit 1;

		
		-- Insertando el complemento
		INSERT INTO 
			Complemento(complemento, nombreusr, correousr, idLocalizacion, idEstado)		 
		 VALUES(p_complemento, p_nombreusr, p_correousr, v_idLocalizacion, v_idEstado);
		
		
		SET @resultado = ' 
						{
						  "estado": "200",
						  "mensaje": "OK",
						  "data": 
							{
							  "nombre": "Se ha insertado el Complemento Correctamente "							 
							}
						}
					';
		SELECT @resultado;

END;;
DELIMITER ;



-- PRUEBA LLAMADA A PROCEDIMIENTO
-- CALL sp_almacenamientoInsertaComplemento("ENGLISH", "usuario", "correo","es_us");
