

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


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 3:  FUNCION QUE DEVUELVE EL IVA DEL IMPORTE FACTURADO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Funcion para calcular el impuesto discriminado de cualquier monto, actualmente estipulado en 21% para todos los productos
DELIMITER $$

CREATE FUNCTION calcular_iva(importe DECIMAL(11,2) )
RETURNS DECIMAL(11,2)
NO SQL
BEGIN
	DECLARE impuestoActual DECIMAL(9,2) DEFAULT 21.00;
    DECLARE resultado DECIMAL(9,2);  
    
    -- ****************************si se modificar el impuesto utilizar esta linea***********************************
	 -- set ImpuestoActual = -- porcentaje que quiero incrementar
     
     set resultado = importe *(impuestoActual/100);
     return resultado;
END $$


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 4:  FUNCION QUE DEVUELVE EL SALDO TOTAL 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Funcion que calculo el total del saldo

CREATE FUNCTION calcular_importe(importe DECIMAL(11,2), id_tipoPago int)
RETURNS DECIMAL(11,2)
NO SQL
BEGIN
   DECLARE resultado DECIMAL(9,2) default 0.0;   
   
   # si tipo de pago es 1 Efectivo le aplico un descuento
   
	IF (id_tipoPago = 1) THEN    
		SET resultado = (importe + calcular_iva(importe)) - calcular_descuento(importe);
	ELSE
    	SET resultado = importe + calcular_iva(importe);
	END IF;
    RETURN resultado;
END $$


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 5:  FUNCION QUE DEVUELVE EL DESCUENTO A APLICAR SI PAGA EN EFECTIVO 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE FUNCTION calcular_descuento(importe DECIMAL(11,2) )
RETURNS DECIMAL(11,2)
NO SQL
BEGIN
	DECLARE impuestoActual DECIMAL(9,2) DEFAULT 21.00;
    DECLARE resultado DECIMAL(9,2);  
	DECLARE descuento DECIMAL(11,2) DEFAULT 15.00;   
    
    -- ****************************si se modificar el impuesto utilizar esta linea***********************************
	 -- set ImpuestoActual = -- porcentaje que quiero incrementar
     
         -- ****************************si se modificar el descuento utilizar esta linea***********************************
	 -- set descuento = -- porcentaje que quiero descontar
     
     set resultado = importe *(descuento/100);
     return resultado;
END $$

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
										in p_id_tipoClase int,
                                        in p_id_tipoPlan int								
                                        )
BEGIN

DECLARE v_item INT DEFAULT NULL;

	IF p_idUser <= 0 OR p_id_tipoClase <= 0 OR p_id_tipoPlan <= 0  THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Todos los campos son requeridos';
	ELSE
    
		-- VALIDO SI YA CARGUE EL TIPO DE CLASE, SI ES ASI ACTUALIZAO SOLO EL TIPO DE PLAN
		SET v_item = (SELECT COUNT(*) FROM subcripcion_temporal WHERE p_idUser = id_usuario AND id_tipoClase = p_id_tipoClase );
        
        IF	v_item > 0 THEN
			UPDATE subcripcion_temporal SET id_plan = p_id_tipoPlan WHERE p_idUser = id_usuario AND id_tipoClase = p_id_tipoClase;
		ELSE
			insert into  subcripcion_temporal(id_usuario,id_tipoClase,id_Plan)
			VALUES(p_idUser,p_id_tipoClase,p_id_tipoPlan);        
		END IF;
    END IF;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_generarFacturacion`(in p_id_cliente int,in p_id_usuario int, in p_tipo_pago int )
BEGIN
	DECLARE v_idFactura INT DEFAULT 0;
    DECLARE subtotal, iva,total DECIMAL(11,2);
	DECLARE rb BOOL DEFAULT FALSE;
    DECLARE msg TEXT DEFAULT 'Error desconocido';
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET rb := TRUE;
    
    IF p_id_usuario <= 0 OR p_id_cliente <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Todos los campos son requeridos';
	ELSE
		START TRANSACTION;
			INSERT INTO factura
            VALUES(null,p_id_cliente,NULL,NULL,NULL,NULL,p_id_usuario,NULL);
            set @v_idFactura =  LAST_INSERT_ID();
			
			IF @v_idFactura = 0 THEN
				SET rb := TRUE;
				SET msg := 'No se genero una nueva factura';
			END IF;
            
            INSERT INTO itemfacturables(id_usuario,id_factura,id_tipoClase,id_tipoPlan)
            SELECT
				id_usuario,
                v_idFactura,
                id_tipoClase,
                id_Plan
			FROM subcripcion_temporal
			WHERE id_usuario = p_id_usuario;
            
            -- borro lo registros tabla temporal por usuario y inicializo el increment
			DELETE FROM subcripcion_temporal WHERE id_usuario = p_id_usuario;
            ALTER TABLE subcripcion_temporal AUTO_INCREMENT = 1;
            
     /*       
			# CTE (Common Table Expression) que es una FUNCION VENTANA
			WITH tabla_temporal_1 AS (
						select ifs.id_factura, sum(pd.valor) AS importe_total from itemfacturables ifs
						inner join planes_disponibles pd on pd.id_plan  = ifs.id_tipoPlan
						where id_factura = 1
						GROUP BY id_factura
			)
			
			SELECT importe_total
			INTO @subtotal
			FROM tabla_temporal_1;  
            
            
                 IF @subtotal = 0 THEN
					SET rb := TRUE;
					SET msg := 'El total es de 0 pesos';
				END IF;
			
			UPDATE factura
			SET subtotal = @subtotal, iva = calcular_iva(@subtotal), total = calcular_importe(@subtotal,tipo_pago), id_tipoPago = p_tipo_pago
			WHERE id = v_idFactura;
            
            IF rb THEN
				ROLLBACK;
                SELECT CONCAT('Error: ', msg) AS 'Error';
			ELSE
				COMMIT;
			END IF;
                        
		COMMIT;
    
    */
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
