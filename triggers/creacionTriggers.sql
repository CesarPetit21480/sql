delimiter $$
use workshop_CesarPetit $$
/* Se creo trigger que cuando se da de baja el usuario de manera logica lo guarda en el log */
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

/*Se creo un trigger que al eliminar la clase del cliente lo guarda en el log*/
CREATE TRIGGER `workshop_CesarPetit`.`clase_BEFORE_DELETE` BEFORE DELETE ON `clase` FOR EACH ROW
BEGIN
INSERT INTO log_bajaClase
    VALUES(OLD.id_clase,OLD.id_horario,OLD.id_cliente,OLD.fecha_clase,OLD.id_tipoClase,OLD.id_profesor,OLD.id_sucursal); 
END$$ 
delimiter ;