CREATE DEFINER=`root`@`%` PROCEDURE `sp_almacenamientoInsertaLocalizacion`(in localizacion varchar(10) )
BEGIN
	declare varEstado int;
    declare Internalizacion varchar(20);
    set Internalizacion = localizacion;
    select idEstado INTO varEstado from estado where Estado = 'Activo';
   	if (select count(*) from Localizacion where (Localizacion  = localizacion)) = 0 then
		Insert Into Localizacion
			(Localizacion,Internalizacion,idEstado)
			Values
			(localizacion,internacionalizacion,varEstado);
		end if;
        if exists (select idLocalizacion from Localizacion where (Localizacion = localizacion)) then
			select '200' Estado, 'OK' Mensaje, 'data' data, localizacion Nombre;
		else
			select '401' Estado,'Error al crear el la localizacion' Mensaje;
		end if;
END