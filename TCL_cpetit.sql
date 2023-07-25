START TRANSACTION;
		INSERT INTO sucursal ()
		VALUES (NULL, 'Palermo', 'Dirección 1, Palermo, Buenos Aires', 'email1@example.com');
		
        INSERT INTO sucursal ()
		VALUES (NULL, 'Recoleta', 'Dirección 2, Recoleta, Buenos Aires', 'email2@example.com');  

		INSERT INTO sucursal ()
		VALUES  (NULL, 'Belgrano', 'Dirección 3, Belgrano, Buenos Aires', 'email3@example.com');

		INSERT INTO sucursal ()
		VALUES (NULL, 'San Telmo', 'Dirección 4, San Telmo, Buenos Aires', 'email4@example.com');

		SAVEPOINT lote_4;
		
        INSERT INTO sucursal ()
		VALUES (NULL, 'Colegiales', 'Dirección 5, Colegiales, Buenos Aires', 'email5@example.com');

		INSERT INTO sucursal ()
		VALUES (NULL, 'Villa Crespo', 'Dirección 6, Villa Crespo, Buenos Aires', 'email6@example.com');
 
		INSERT INTO sucursal ()
		VALUES (NULL, 'Núñez', 'Dirección 7, Núñez, Buenos Aires', 'email7@example.com');

		INSERT INTO sucursal ()
		VALUES (NULL, 'Caballito', 'Dirección 8, Caballito, Buenos Aires', 'email8@example.com');
        
        SAVEPOINT lote_5;
        
       -- ROLLBACK TO lote_4;

		 COMMIT;




