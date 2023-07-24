-- CREO 2 USUARIOS
create user 'testCesar1'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';
create user 'testCesar2'@'localhost'  IDENTIFIED WITH mysql_native_password BY '1234';

-- creo permiso de lectura sobre todas las tablas 
GRANT SELECT ON workshop_cesarpetit.* TO 'testCesar1'@'localhost' ;

-- creo permiso de lectura, inseccion y modificacion sobre todas las tablas 
GRANT SELECT,INSERT,UPDATE ON workshop_cesarpetit.* TO 'testCesar2'@'localhost' ;



-- QUITO TODOS LOS PERMISOS
REVOKE ALL ON *.* FROM 'testCesar1'@'localhost';
REVOKE ALL ON *.* FROM 'testCesar2'@'localhost';

-- VERIFICO PERMISOS
show grants for 'testCesar1'@'localhost';
show grants for 'testCesar2'@'localhost';


