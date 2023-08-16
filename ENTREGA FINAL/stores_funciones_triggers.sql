

-- **************************************************************************************************************************************************************************
-- ******************************************************************************* VISTAS ***********************************************************************************
-- **************************************************************************************************************************************************************************


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 1:   ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use workshop_CesarPetit;
CREATE VIEW vistaCantTipoClase AS (

  /* ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)*/
select CONCAT(p.nombre,' ',p.apellido) 'nombre Profesor', tc.nombre, count(*) 'Cantidad Clase' from clase c

inner join profesor p on p.id_profesor = c.id_profesor

inner join tipo_clase tc on tc.id_tipoClase = c.id_tipoClase

where p.id_profesor = 1
GROUP BY(tc.id_tipoClase)
);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 2:   ESTA VISTA MUESTRA LA INFORMACIÓN DE LAS CLASES.
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE VIEW v_clases_info AS(

SELECT c.id_clase, h.hora, c.fecha_clase, s.nombre as nombre_sucursal, p.nombre as nombre_profesor, tc.nombre as tipo_clase

FROM clase c

INNER JOIN horario h ON c.id_horario = h.id_horario

INNER JOIN sucursal s ON c.id_sucursal = s.id_sucursal

INNER JOIN profesor p ON c.id_profesor = p.id_profesor

INNER JOIN tipo_clase tc ON c.id_tipoClase = tc.id_tipoClase);


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 3:  ESTA VISTA MUESTRA LAS CLASES QUE HICIERON LOS CLIENTES
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE VIEW v_clases_por_cliente AS(

SELECT c.id_cliente, CONCAT(c.nombre, ' ', c.apellido) as nombre_completo, COUNT(cl.id_clase) as total_clases

FROM cliente c

LEFT JOIN clase cl ON c.id_cliente = cl.id_cliente

GROUP BY c.id_cliente, nombre_completo);


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 4: ESTA VISTA MUESTRA LOS CUPOS LIBRES POR CLASE
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE VIEW v_cupos_horario_sucursal AS(

SELECT h.id_horario, h.hora, s.nombre as nombre_sucursal,

    h.cupos as total_cupos,

    h.cupos - COUNT(cl.id_clase) as cupos_disponibles

	FROM horario h

	INNER JOIN sucursal s ON h.id_sucursal = s.id_sucursal

	LEFT JOIN clase cl ON h.id_horario = cl.id_horario

	GROUP BY h.id_horario, h.hora, s.nombre, h.cupos
);


-- **************************************************************************************************************************************************************************
-- ***************************************************************************** FUNCIONES **********************************************************************************
-- **************************************************************************************************************************************************************************

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 1:  FUNCION QUE DEVUELVE CUAL ES EL NUMERO MAS GRANDE EN CASO DE IGUALDAD DEVUELVE IGUALES--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delimiter $$
CREATE FUNCTION mayor_numero(num1 int,num2 int) RETURNS varchar(50)
NO SQL
BEGIN
	declare mayor varchar(50);
	if (num1 > num2)     then
		set mayor = concat('el mayor numero es:',' ',CONVERT(num1, CHAR(20)));
	end if;    
    if (num2 > num1) then
				set mayor = concat('el mayor numero es:',' ',CONVERT(num2, CHAR(20)));
	end if;	
    if (num1 = num2) then   
		set mayor = concat("Los numeros son iguales!!!!");     
    end if;
   return mayor;
END$$

delimiter ;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 2:  FUNCION QUE DEVUELVE LA CANTIDAD DE PROFESORES QUE HACEN  MAS HORAS  QUE LAS INGRESADAS POR PARAMETRO FORMATO DE INGRESO 00:00--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delimiter $$

CREATE FUNCTION profesoresCantidadHoras ( p_horas time)  returns int
READS SQL DATA
BEGIN

	declare profesoresHoras int ;    
    set profesoresHoras = (select count(*) cantidadProfesores from profesor where horas_diarias >=p_horas);
    return profesoresHoras;
END$$

delimiter ;

-- **************************************************************************************************************************************************************************
-- ***************************************************************************** STORED PROCEDURE ***************************************************************************
-- **************************************************************************************************************************************************************************

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /* SP 1:  SE CREA STORE PRODEDURE QUE PERMITE ORDER LAS CLASE POR DISTINTOS TIPO Y DE MANERA ASCENTENTE Y DESCENDENTE 
  field : se debera agregar por que tipo de columna se desea ordenar 
  orden : ASC - DESC*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
delimiter $$
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

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 2: SE CREA STORE PRODEDURE QUE INGRESA UN NUEVO PROFESOR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cargarProfesor`(	in p_nombre varchar(50),
										in p_apellido varchar(50),
                                        in p_email varchar(70),
                                        in p_horas time)
BEGIN

INSERT INTO profesor()
values (null,p_nombre,p_apellido,p_email,p_horas);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ventaSubcripcion`(	in p_idUser int,
										in p_id_tipoCalse int,
                                        in p_id_tipoPlan int								
                                        )
BEGIN

	IF p_idUser <= 0 OR p_id_tipoCalse <= 0 OR p_id_tipoPlan <= 0  THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Todos los campos son requeridos';
	ELSE
		insert into  subcripcion_temporal(id_cliente,id_usuario,id_Plan)
		VALUES(p_idCliente,p_idUser,p_id_tipoPlan);        
	END IF;
    
END$$
DELIMITER ;









-- **************************************************************************************************************************************************************************
-- *****************************************************************************TRIGGERS ***********************************************************
-- **************************************************************************************************************************************************************************

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGER 1 - Se creo trigger que cuando se da de baja el usuario de manera logica lo guarda en el log
  
delimiter $$
use workshop_CesarPetit $$
CREATE TRIGGER tr_bajaUser 
AFTER UPDATE
ON cliente FOR EACH ROW
BEGIN
	IF (OLD.baja <> NEW.baja AND NEW.BAJA = 1) THEN	
		INSERT INTO log_bajaCLiente (id_cliente,fechaBaja)
		VALUES (NEW.id_cliente,NOW());
	END IF;

END $$
use workshop_CesarPetit $$

-- TRIGGER 2 - Se creo un trigger que al eliminar la clase del cliente lo guarda en el log

CREATE TRIGGER `workshop_CesarPetit`.`clase_BEFORE_DELETE` BEFORE DELETE ON `clase` FOR EACH ROW
BEGIN
INSERT INTO log_bajaClase
    VALUES(OLD.id_clase,OLD.id_horario,OLD.id_cliente,OLD.fecha_clase,OLD.id_tipoClase,OLD.id_profesor,OLD.id_sucursal); 
END$$ 
delimiter ;
