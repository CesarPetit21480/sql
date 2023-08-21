

-- **************************************************************************************************************************************************************************
-- ******************************************************************************* VISTAS ***********************************************************************************
-- **************************************************************************************************************************************************************************
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 1:   ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE workshop_CesarPetit;
CREATE VIEW vistaCantTipoClase AS (

  /* ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)*/  
	SELECT CONCAT(p.nombre,' ',p.apellido) 'nombre Profesor', tc.nombre, count(*) 'Cantidad Clase' FROM clase c
	INNER JOIN profesor p ON p.id_profesor = c.id_profesor
	INNER JOIN tipo_clase tc ON tc.id_tipoClase = c.id_tipoClase
	WHERE p.id_profesor = 1
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
	INNER JOIN tipo_clase tc ON c.id_tipoClase = tc.id_tipoClase
);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 3:  ESTA VISTA MUESTRA LAS CLASES QUE HICIERON LOS CLIENTES
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW v_clases_por_cliente AS(

	SELECT c.id_cliente, CONCAT(c.nombre, ' ', c.apellido) as nombre_completo, COUNT(cl.id_clase) as total_clases
	FROM cliente c
	LEFT JOIN clase cl ON c.id_cliente = cl.id_cliente
	GROUP BY c.id_cliente, nombre_completo
);

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

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 5: NOS PERMITE VER LA VISTA TOTAL GENERAL ORDENADA POR NRO FACTURACION
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW `facturacion_total` AS (
    SELECT 
        `fc`.`id_factura` AS `id_factura`,
        `fc`.`subtotal` AS `subtotal`,
        `fc`.`fecha_facturacion` AS `fecha_facturacion`,
        `fc`.`total_factura` AS `total_factura`,
        COUNT(`ifs`.`id_tipoClase`) AS `Cantidad_Items`,
        CONCAT(`c`.`nombre`, ' ', `c`.`apellido`) AS `Cliente`
    FROM
        ((((`factura` `fc`
        JOIN `itemfacturables` `ifs` ON ((`ifs`.`id_factura` = `fc`.`id_factura`)))
        JOIN `tipo_clase` `tc` ON ((`tc`.`id_tipoClase` = `ifs`.`id_tipoClase`)))
        JOIN `cliente` `c` ON ((`c`.`id_cliente` = `fc`.`id_cliente`)))
        JOIN `planes_disponibles` `pd` ON ((`pd`.`id_plan` = `ifs`.`id_tipoPlan`)))
    GROUP BY `fc`.`id_factura`
);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 6: NOS PERMITE VER LA VISTA TOTAL GENERAL ORDENADA POR NRO FACTURACION INDICANDO LAS CLASES SELECCIONADOS
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  VIEW `facturacion_total_con_items` AS (
    SELECT 
        `fc`.`id_factura` AS `id_factura`,
        `fc`.`subtotal` AS `subtotal`,
        `fc`.`fecha_facturacion` AS `fecha_facturacion`,
        CONCAT(`c`.`nombre`, ' ', `c`.`apellido`) AS `CLIENTE`,
        `tc`.`nombre` AS `NOMBRE_CLASE`,
        `pd`.`nombre` AS `NOMBRE_PLAN`,
        `fc`.`total_factura` AS `total_factura`
    FROM
        ((((`factura` `fc`
        JOIN `itemfacturables` `ifs` ON ((`ifs`.`id_factura` = `fc`.`id_factura`)))
        JOIN `tipo_clase` `tc` ON ((`tc`.`id_tipoClase` = `ifs`.`id_tipoClase`)))
        JOIN `cliente` `c` ON ((`c`.`id_cliente` = `fc`.`id_cliente`)))
        JOIN `planes_disponibles` `pd` ON ((`pd`.`id_plan` = `ifs`.`id_tipoPlan`)))
    ORDER BY `fc`.`id_factura`

);

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 7: NOS PERMITE SABER LA CANTIDAD DE TIPOS DE CLASES QUE EXISTEN EN LAS CLASES
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE  VIEW `conttipoclases` AS (
    SELECT 
        COUNT(`c`.`id_tipoClase`) AS `Cantidad Clases`,
        `tc`.`nombre` AS `nombre`
    FROM
        (`clase` `c`
        JOIN `tipo_clase` `tc` ON ((`tc`.`id_tipoClase` = `c`.`id_tipoClase`)))
    GROUP BY `c`.`id_tipoClase`

)
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
	DECLARE mayor VARCHAR(50);
	IF (num1 > num2) THEN
		SET mayor = concat('el mayor numero es:',' ',CONVERT(num1, CHAR(20)));
	END IF;   
    IF (num2 > num1) THEN
				SET mayor = concat('el mayor numero es:',' ',CONVERT(num2, CHAR(20)));
	END IF; 
    IF (num1 = num2) THEN   
		set mayor = concat("Los numeros son iguales!!!!");     
   END IF;
   RETURN mayor;
END$$


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- FUNCIÓN 2:  FUNCION QUE DEVUELVE LA CANTIDAD DE PROFESORES QUE HACEN  MAS HORAS  QUE LAS INGRESADAS POR PARAMETRO FORMATO DE INGRESO 00:00--
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION profesoresCantidadHoras ( p_horas time)  returns int
READS SQL DATA
BEGIN
	DECLARE profesoresHoras INT ;    
    SET profesoresHoras = (SELECT count(*) cantidadProfesores FROM profesor WHERE horas_diarias >=p_horas);
    RETURN profesoresHoras;
END$$

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 3:  FUNCION QUE DEVUELVE EL IVA DEL IMPORTE FACTURADO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Funcion para calcular el impuesto discriminado de cualquier monto, actualmente estipulado en 21% para todos los productos

CREATE FUNCTION calcular_iva(importe DECIMAL(11,2) )
RETURNS DECIMAL(11,2)
NO SQL
BEGIN
	DECLARE impuestoActual DECIMAL(9,2) DEFAULT 21.00;
    DECLARE resultado DECIMAL(9,2);    
    -- ****************************si se modificar el impuesto utilizar esta linea***********************************
	 -- set ImpuestoActual = -- porcentaje que quiero incrementar     
     SET resultado = importe *(impuestoActual/100);
     RETURN resultado;
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
	 DECLARE importeInicial DECIMAL(9,2) default 0.0; 
   # si tipo de pago es 1 Efectivo le aplico un descuento
   
	SET @importeInicial = importe + calcular_iva(importe);
   
	IF (id_tipoPago = 1) THEN    
		SET resultado =@importeInicial  - calcular_descuento(@importeInicial);
	ELSE
    	SET resultado = @importeInicial;
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
    DECLARE resultado DECIMAL(9,2);  
	DECLARE descuento DECIMAL(11,2) DEFAULT 15.00;   
     
         -- ****************************si se modificar el descuento utilizar esta linea***********************************
	 -- set descuento = -- porcentaje que quiero descontar     
     SET resultado = importe *(descuento/100);
     RETURN resultado;
END $$

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 6:  FUNCION QUE DEVUELVE CONCATENADO Y SEPARADOS POR - LAS CLASES FACTURADAS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE DEFINER=`root`@`localhost` FUNCTION `tipoClaseConcatenados`( p_idFactura int) RETURNS varchar(100)
    NO SQL
BEGIN

	DECLARE tipoClasesConcat VARCHAR(100);

	SET tipoClasesConcat =  (	SELECT GROUP_CONCAT(upper(tc.nombre) SEPARATOR ' - ') 
								FROM
									((((`workshop_cesarpetit`.`factura` `fc`
									JOIN `workshop_cesarpetit`.`itemfacturables` `ifs` ON ((`ifs`.`id_factura` = `fc`.`id_factura`)))
									JOIN `workshop_cesarpetit`.`tipo_clase` `tc` ON ((`tc`.`id_tipoClase` = `ifs`.`id_tipoClase`)))
									JOIN `workshop_cesarpetit`.`cliente` `c` ON ((`c`.`id_cliente` = `fc`.`id_cliente`)))
									JOIN `workshop_cesarpetit`.`planes_disponibles` `pd` ON ((`pd`.`id_plan` = `ifs`.`id_tipoPlan`)))
									WHERE fc.id_factura = p_idFactura);
	RETURN tipoClasesConcat;

END$$


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- FUNCIÓN 7:  FUNCION QUE DEVUELVE CONCATENADO Y SEPARADOS POR - LAS PLANES FACTURADOS
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE FUNCTION `tipoPlanesConcatenados`(p_idFactura int) RETURNS varchar(100) CHARSET utf8mb4
    NO SQL
BEGIN

DECLARE tipoPlanConcat VARCHAR(100);

SET tipoPlanConcat =  (SELECT GROUP_CONCAT(upper(pd.nombre) SEPARATOR ' - ') 
						FROM
							((((`workshop_cesarpetit`.`factura` `fc`
							JOIN `workshop_cesarpetit`.`itemfacturables` `ifs` ON ((`ifs`.`id_factura` = `fc`.`id_factura`)))
							JOIN `workshop_cesarpetit`.`tipo_clase` `tc` ON ((`tc`.`id_tipoClase` = `ifs`.`id_tipoClase`)))
							JOIN `workshop_cesarpetit`.`cliente` `c` ON ((`c`.`id_cliente` = `fc`.`id_cliente`)))
							JOIN `workshop_cesarpetit`.`planes_disponibles` `pd` ON ((`pd`.`id_plan` = `ifs`.`id_tipoPlan`)))
							WHERE fc.id_factura = p_idFactura);
                            
RETURN tipoPlanConcat;                     

END$$


-- **************************************************************************************************************************************************************************
-- ***************************************************************************** STORED PROCEDURE ***************************************************************************
-- **************************************************************************************************************************************************************************

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /* SP 1:  SE CREA STORE PRODEDURE QUE PERMITE ORDER LAS CLASE POR DISTINTOS TIPO Y DE MANERA ASCENTENTE Y DESCENDENTE 
  field : se debera agregar por que tipo de columna se desea ordenar 
  orden : ASC - DESC*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_ordenar_clase (IN field VARCHAR(20), IN orden VARCHAR(20) )
BEGIN
	IF field <> '' THEN
		SET @order_clase =  concat('ORDER BY',' ',field ,' ', orden);    
    ELSE
    	set @order_clase = '';    
    END IF; 
    SET @clausula = concat('select * from clase ', @order_clase);
	PREPARE runSQL FROM @clausula;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL; 
END$$

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 2: SE CREA STORE PRODEDURE QUE INGRESA UN NUEVO PROFESOR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_agregar_profesor(IN p_nombre VARCHAR(50), IN p_apellido VARCHAR(50), IN p_email VARCHAR(100), IN p_horasDiarias TIME)
BEGIN
	INSERT INTO profesor(nombre,apellido,email,horas_diarias)
    VALUES(p_nombre,p_apellido,p_email,p_horasDiarias);
END$$

-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 3: SE CREA STORE PRODEDURE  QUE QUITA PROFESOR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE `sp_quitarProfesor`(IN p_id INT)
BEGIN
	DELETE FROM profesor WHERE id_profesor = p_id;
END$$

-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 4: SE CREA STORE PRODEDURE  QUE APLICA TRANSACCIONES SI EXISTE O NO PROFESOR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transaccion`()
BEGIN
	DECLARE registros INT DEFAULT 0;
	START TRANSACTION;
		SET @registros = (SELECT count(*) FROM profesor);	
    
		IF (@registros > 0) THEN
			 CALL sp_quitarProfesor(1);			
		ELSE
			CALL sp_cargarProfesor('Carlos','Sand','carlos@gmail.com','9:00');  
		END IF ;
COMMIT;
-- ROLLBACK;

END$$
-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 5: SE CREA STORE PRODEDURE QUE AGREGA PROFESOR TRANSACCION
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE `sp_cargarProfesor`(	IN p_nombre VARCHAR(50),
										IN p_apellido VARCHAR(50),
                                        IN p_email VARCHAR(70),
                                        IN p_horas TIME)
BEGIN
	INSERT INTO profesor()
	VALUES (null,p_nombre,p_apellido,p_email,p_horas);
END$$


-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 6: SE CREA STORE PRODEDURE QUE GENERA ITEMS PARA FACTURAR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE `sp_ventaSubcripcion`(	in p_idUser int,
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


-------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 7: SE CREA STORE PRODEDURE QUE GENERA LA FACTURA AL CLIENTE
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE `sp_generarFacturacion`(IN p_id_cliente INT,IN p_id_usuario INT, IN p_tipo_pago INT )
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
            SET @v_idFactura =  LAST_INSERT_ID();
			
			IF @v_idFactura = 0 THEN
				SET rb := TRUE;
				SET msg := 'No se genero una nueva factura';
			END IF;
            
            INSERT INTO itemfacturables(id_usuario,id_factura,id_tipoClase,id_tipoPlan)
            SELECT
				id_usuario,
                @v_idFactura,
                id_tipoClase,
                id_Plan
			FROM subcripcion_temporal
			WHERE id_usuario = p_id_usuario;
            
            -- borro lo registros tabla temporal por usuario y inicializo el increment
			DELETE FROM subcripcion_temporal WHERE id_usuario = p_id_usuario;
            ALTER TABLE subcripcion_temporal AUTO_INCREMENT = 1;
            
       
			# CTE (Common Table Expression) que es una FUNCION VENTANA
			WITH tabla_temporal_1 AS (
						SELECT ifs.id_factura, sum(pd.valor) AS importe_total FROM itemfacturables ifs
						INNER JOIN planes_disponibles pd on pd.id_plan  = ifs.id_tipoPlan
						WHERE id_factura = @v_idFactura
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
			SET subtotal = @subtotal, iva = calcular_iva(@subtotal),  total_factura = calcular_importe(@subtotal,p_tipo_pago), id_tipoPago = p_tipo_pago ,fecha_facturacion = now()
			WHERE id_factura = @v_idFactura;
            
            IF rb THEN
				ROLLBACK;
                SELECT CONCAT('Error: ', msg) AS 'Error';
			ELSE
				COMMIT;
			END IF;       
    END IF;

END$$

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- SP 8: SE CREA STORE PRODEDURE MUESTRA DATOS DE LA FACTURA POR ID
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getFactura`(IN p_idFactura INT)
BEGIN

	DECLARE clases_factura varchar(50) DEFAULT NULL;
	DECLARE planes_factura varchar(50) DEFAULT NULL;

	SET @clases_factura = tipoClaseConcatenados(p_idFactura);
	SET @planes_factura = tipoPlanesConcatenados(p_idFactura);

	SELECT 	fc.id_factura, 
			CONCAT(c.nombre,' ',c.apellido) nombre_cliente,
            fc.subtotal,fc.fecha_facturacion,
            fc.total_factura,
            count(ifs.id_tipoClase) AS cantidad_items, 
            @clases_factura AS clases_facturadas ,
            @planes_factura AS planes_seleccionados 
            FROM workshop_cesarpetit.factura fc
	INNER JOIN itemfacturables ifs ON ifs.id_factura = fc.id_factura
	INNER JOIN tipo_clase tc ON tc.id_tipoClase = ifs.id_tipoClase
	INNER JOIN cliente c ON c.id_cliente = fc.id_cliente
	INNER JOIN planes_disponibles pd ON pd.id_plan = ifs.id_tipoPlan
	WHERE fc.id_factura = p_idFactura
	GROUP BY (fc.id_factura);
END$$


-- **************************************************************************************************************************************************************************
-- *****************************************************************************TRIGGERS ***********************************************************
-- **************************************************************************************************************************************************************************

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGER 1 - Se creo trigger que cuando se da de baja el usuario de manera logica lo guarda en el log
  

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
