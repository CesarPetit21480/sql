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
