delimiter $$
use workshop_CesarPetit$$

/* SE CREA STORE PRODEDURE QUE PERMITE ORDER LAS CLASE POR DISTINTOS TIPO Y DE MANERA ASCENTENTE Y DESCENDENTE 
	field : se debera agregar por que tipo de columna se desea ordenar
    orden : ASC - DESC
*/

CREATE PROCEDURE sp_ordenar_clase (in field varchar(20), in orden VARCHAR(20) )
BEGIN

	if field <> '' then    
		set @order_clase =  concat('ORDER BY',' ',field ,' ', orden);    
    else
    	set @order_clase = '';    
    end if; 
    SET @clausula = concat('select * from clase ', @order_clase);
	PREPARE runSQL FROM @clausula;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL;
 
END$$

/* SE CREA STORE PRODEDURE QUE INGRESA UN NUEVO PROFESOR */

CREATE PROCEDURE sp_agregar_profesor(in p_nombre varchar(50), p_apellido varchar(50), in p_email varchar(100), in p_horasDiarias time)
BEGIN
	INSERT INTO profesor(nombre,apellido,email,horas_diarias)
    values(p_nombre,p_apellido,p_email,p_horasDiarias);
END$$
delimiter ;

delimiter $$

CREATE PROCEDURE sp_agregar_profesor(in p_nombre varchar(50), p_apellido varchar(50), in p_email varchar(100), in p_horasDiarias time)
BEGIN
	INSERT INTO profesor(nombre,apellido,email,horas_diarias)
    values(p_nombre,p_apellido,p_email,p_horasDiarias);
END$$

delimiter ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_quitarProfesor`(in p_id int)
BEGIN
delete from profesor where id_profesor = p_id;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaccion`()
BEGIN
	declare registros int default 0;
 START TRANSACTION;
		set @registros = (select count(*) FROM profesor);	
    
		IF (@registros > 0) THEN
			 call sp_quitarProfesor(1);			
		ELSE
			call sp_cargarProfesor('Carlos','Sand','carlos@gmail.com','9:00');  
		END IF ;
COMMIT;
-- ROLLBACK;

END$$


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cargarProfesor`(	in p_nombre varchar(50),
										in p_apellido varchar(50),
                                        in p_email varchar(70),
                                        in p_horas time)
BEGIN

INSERT INTO profesor()
values (null,p_nombre,p_apellido,p_email,p_horas);

END$$
DELIMITER ;




DELIMITER ;
