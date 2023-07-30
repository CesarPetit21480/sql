CREATE DATABASE workshop_CesarPetit;

USE workshop_CesarPetit;

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.cliente(
id_cliente int auto_increment,
nombre varchar(50)  not null,
apellido varchar(50) not null,
fecha_nacimiento date not null,
fecha_alta date not null,
email varchar(100) not null,
baja tinyint not null default 0,
PRIMARY KEY (id_cliente),
INDEX nombre (nombre,apellido)
);

CREATE TABLE IF NOT EXISTS 	workshop_CesarPetit.sucursal
(
id_sucursal int auto_increment primary key,
nombre varchar(50) not null,
direccion varchar(50) not null,
email varchar(70) not null,
index nomSuc(nombre)
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.tipo_clase
(
	id_tipoClase int auto_increment primary key,
    nombre varchar(50) not null,
    descripcion mediumtext null
);


CREATE TABLE IF NOT EXISTS workshop_CesarPetit.ejercicios
(
	id_ejercicio int auto_increment primary key,
    nombre varchar(100) not null,
    descripcion varchar(800) null,
    id_tipoClase int not null,
    index nomEjercicio (nombre),    
	constraint fk_tipoClaseEjercicio FOREIGN KEY (id_tipoClase) REFERENCES tipo_clase(id_tipoClase) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS workshop_CesarPetit.horario(

	id_horario int auto_increment primary key,
    hora time not null,
    id_sucursal int not null,
    id_tipoclase int not null,
    cupos int not null,
	constraint fk_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal) ON DELETE RESTRICT ON UPDATE CASCADE,
	constraint fk_tipoClase FOREIGN KEY (id_tipoclase) REFERENCES tipo_clase(id_tipoClase) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor
(
	id_profesor int auto_increment primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null,   
    horas_diarias time   
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_tipoClase
(
	idProTipoClase int auto_increment primary key,
    id_tipoClase int not null,
    id_profesor int not null,
    constraint fk_tipoclaseRelacion foreign key(id_tipoClase) references tipo_clase(id_tipoClase) ON DELETE RESTRICT ON UPDATE CASCADE,
    constraint fk_Profesor foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_sucursal
(
	id int auto_increment primary key,
    id_sucursal int not null,
    id_profesor int not null,
    constraint fk_sucursalProfesor foreign key(id_sucursal) references sucursal(id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_ProfesorRelacion foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_horario
(
	id int auto_increment primary key,
    id_horario int not null,
    id_profesor int not null,
    constraint fk_horarioProfesor foreign key(id_horario) references horario(id_horario) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_ProfesorHorario foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.clase
(
	id_clase int auto_increment primary key,
    id_horario int not null,
    id_cliente int not null,
    fecha_clase date,
    id_tipoClase int not null,
    id_profesor int not null,
    id_sucursal int not null,
    constraint fk_horarioClase foreign key(id_horario) references horario(id_horario) ON DELETE CASCADE ON UPDATE CASCADE,
	constraint fk_clienteClase foreign key(id_cliente) references cliente(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_tipoDeClase foreign key(id_tipoClase) references tipo_clase(id_tipoClase) ON DELETE CASCADE ON UPDATE CASCADE,    
	constraint fk_profesorClase foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_sucursalClase foreign key(id_sucursal) references sucursal(id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.usuario
(
	id_usuario int auto_increment primary key,
    user varchar(20) not null,
    password varchar(100) not null,
    email varchar(60) not null   
);

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.usuario_sucursal
(
	id int auto_increment primary key,
	id_usuario int,
	id_sucursal int not null,  
    constraint fk_usuarioSucursal foreign key(id_sucursal) references sucursal(id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,  
	constraint fk_user foreign key(id_usuario) references usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE  
);


CREATE TABLE `precios_promocionales` (
  id_promocional int NOT NULL AUTO_INCREMENT,
  precio_diario decimal(10,2) DEFAULT NULL,
  precio_semanal decimal(10,2) DEFAULT NULL,
  precio_quincenal decimal(10,2) DEFAULT NULL,
  precio_mensual decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_promocional`)
);



CREATE TABLE workshop_CesarPetit.log_bajaCLiente (
	id int auto_increment primary key,
	id_cliente int,
    fechaBaja DATETIME
);

CREATE TABLE workshop_CesarPetit.log_bajaClase ( 
	id int auto_increment primary key,
	id_clase int,
    id_horario int,
    id_cliente int,
    fecha_clase date,
    id_tipoClase int,
    id_profesor int,
    id_sucursal int 
 );



-- **************************************************************************************************************************************************************************
-- *************************************************************************** INSERCIÓN DE DATOS ***************************************************************************
-- **************************************************************************************************************************************************************************

INSERT INTO workshop_CesarPetit.cliente (id_cliente, nombre, apellido, fecha_nacimiento, fecha_alta, email, baja)
VALUES
(1, 'CESAR', 'PETIT', '1980-04-21', '2020-01-01', 'cesar_petit@hotmail.com', 0),
(2, 'JUAN', 'GOMEZ', '1980-04-22', '2020-01-02', 'juan_gomez@hotmail.com', 0),
(3, 'ERNESTO', 'ROLDAN', '1980-04-23', '2020-01-03', 'ernesto_roldan@hotmail.com', 0),
(4, 'PEDRO', 'PEREZ', '1980-04-24', '2020-01-04', 'pedro_perez@hotmail.com', 0),
(5, 'JOAQUIN', 'LON', '1980-04-25', '2020-01-05', 'joaquin_lon@hotmail.com', 0),
(6, 'LUIS', 'CAPRI', '1980-04-26', '2020-01-06', 'luis_capri@hotmail.com', 0),
(7, 'GASTON', 'CORNIO', '1980-04-27', '2020-01-07', 'gaston_cornio@hotmail.com', 0),
(8, 'ENRIQUE', 'MENTS', '1980-04-28', '2020-01-08', 'enrique_ments@hotmail.com', 0),
(9, 'MARIANA', 'SOMAS', '1980-04-29', '2020-01-09', 'mariana_somas@hotmail.com', 0),
(10, 'ESTELA', 'OCHI', '1980-04-30', '2020-01-10', 'estela_ochi@hotmail.com', 0),
(11, 'CAROLA', 'CASTELO', '1980-05-01', '2020-01-11', 'carola_castelo@hotmail.com', 0),
(12, 'DELFINA', 'ARIAS', '1980-05-02', '2020-01-12', 'delfina_arias@hotmail.com', 0),
(13, 'CAROLINA', 'GARCIA', '1980-05-03', '2020-01-13', 'carolina_garcia@hotmail.com', 0),
(14, 'SILVIA', 'LUNA', '1980-05-04', '2020-01-14', 'silvia_luna@hotmail.com', 0),
(15, 'LUZ', 'APAGADA', '1980-05-05', '2020-01-15', 'luz_apagada@hotmail.com', 0);

INSERT INTO workshop_CesarPetit.sucursal (id_sucursal, nombre, direccion, email)
VALUES
(1, 'ALMAGRO', 'Av. Medrano 1234', 'almagro_sport@hotmail.com'),
(2, 'BALVANERA', 'Calle Bartolome Mitre 567', 'balvanera_sport@hotmail.com'),
(3, 'BARRACAS', 'Av. Montes de Oca 789', 'barracas_sport@hotmail.com'),
(4, 'RECOLETA', 'Calle Junin 4321', 'recoleta_sport@hotmail.com'),
(5, 'CABALLITO', 'Av. Rivadavia 1356', 'caballito_sport@hotmail.com'),
(6, 'COLEGIALES', 'Calle Federico Lacroze 2468', 'colegiales_sport@hotmail.com'),
(7, 'CHACARITA', 'Av. Corrientes 3546', 'chacarita_sport@hotmail.com'),
(8, 'VILLA ORTUZAR', 'Calle Tronador 789', 'villa ortuzar_sport@hotmail.com'),
(9, 'MONTSERRAT', 'Av. de Mayo 1023', 'montserrat_sport@hotmail.com'),
(10, 'PUERTO MADERO', 'Calle Juana Manso 5678', 'puerto madero_sport@hotmail.com'),
(11, 'SAAVEDRA', 'Av. García del Rio 9012', 'saavedra_sport@hotmail.com'),
(12, 'SAN CRISTOBAL', 'Calle Jujuy 345', 'san cristobal_sport@hotmail.com'),
(13, 'SAN NICOLAS', 'Av. Corrientes 6789', 'san nicolas_sport@hotmail.com'),
(14, 'PARQUE PATRICIOS', 'Calle Amancio Alcorta 123', 'parque patricios_sport@hotmail.com'),
(15, 'PARQUE CHACABUCO', 'Av. Asamblea 4567', 'parque chacabuco_sport@hotmail.com');

INSERT INTO workshop_CesarPetit.tipo_clase (id_tipoClase, nombre, descripcion)
VALUES
(1, 'CrossFit', 'Un enfoque de entrenamiento de alta intensidad que combina levantamiento de pesas, ejercicios cardiovasculares y movimientos funcionales.'),
(2, 'Funcional', 'Se centra en mejorar la fuerza, resistencia y movimientos necesarios para actividades diarias y deportes específicos.'),
(3, 'Spinning', 'Entrenamiento de intervalos de alta intensidad que combina ráfagas cortas de ejercicio intenso con periodos de descanso activo.'),
(4, 'oli', 'Entrenamiento de levantamiento.'),
(5, 'pilates', 'Un enfoque de entrenamiento que se centra en el control muscular, la postura y la respiración, combinando movimientos suaves y fluidos.'),
(6, 'HIIT', 'Entrenamiento de intervalos de alta intensidad que combina ráfagas cortas de ejercicio intenso con periodos de descanso activo.'),
(7, 'yoga', 'Una disciplina que combina posturas físicas, respiración y meditación para mejorar la fuerza, flexibilidad y equilibrio mental.');


INSERT INTO workshop_CesarPetit.ejercicios (id_ejercicio, nombre, descripcion, id_tipoClase)
VALUES
(1, 'Burpees', 'Ejercicio de cuerpo completo en el que te agachas, haces una flexión de brazos, saltas con las manos sobre la cabeza y luego vuelves a la posición inicial.', 1),
(2, 'Wall Balls', 'Consiste en lanzar una pelota medicinal contra una pared a una altura determinada y atraparla al volver.', 1),
(3, 'Box Jumps', 'Saltar sobre una caja o plataforma y luego bajar con seguridad.', 1),
(4, 'Kettlebell Swing', 'Balanceo de una pesa rusa (kettlebell) entre las piernas y luego proyectándola hacia adelante con un movimiento explosivo.', 1),
(5, 'Plancha', 'Posición en la que te apoyas sobre los antebrazos y los dedos de los pies, manteniendo el cuerpo recto y tenso durante un tiempo determinado.', 2),
(6, 'Mountain Climbers', 'Posición de plancha alterna en la que llevas las rodillas al pecho, simulando la acción de correr.', 2),
(7, 'Russian Twist', 'Sentado con las piernas levantadas, giras el torso de un lado a otro mientras sostienes un peso o pelota medicinal.', 2),
(8, 'Box Jumps', 'Saltar sobre una caja o plataforma y luego bajar con seguridad.', 2),
(9, 'Sprint en bicicleta estacionaria', 'Pedaleo intenso y rápido durante un corto periodo de tiempo para simular un sprint en una bicicleta estática.', 3),
(10, 'Climbing Hills', 'Ajustar la resistencia de la bicicleta para simular subir una colina empinada mientras pedaleas.', 3),
(11, 'Jumping Jacks', 'Salto lateral mientras pedaleas rápidamente en la bicicleta estática.', 4),
(12, 'Sprints en la cinta', 'Correr a alta velocidad en una cinta de correr durante un breve periodo de tiempo.', 6),
(13, 'Plank to Push-Up', 'Comenzar en posición de plancha y luego pasar a una posición de flexión de brazos (push-up), alternando los brazos.', 6),
(14, 'Thrusters', 'Combinación de una sentadilla frontal con una elevación de pesas sobre la cabeza.', 1),
(15, 'Assault Bike', 'Utilización de una bicicleta estática con manivelas para realizar un pedaleo intenso y rápido.', 3),
(16, 'Saludo al Sol (Surya Namaskar)', 'Es una secuencia fluida de movimientos que combina varias posturas, estiramientos y respiración consciente. Se realiza en secuencias repetitivas, coordinando la respiración con el movimiento. El Saludo al Sol ayuda a calentar el cuerpo, mejorar la flexibilidad, fortalecer los músculos y aumentar la concentración.', 7),
(17, 'Postura del Perro hacia Abajo (Adho Mukha Svanasana)', 'Es una postura clásica del yoga que se realiza a cuatro patas, formando una V invertida con el cuerpo. Las manos están separadas a la anchura de los hombros y los pies a la anchura de las caderas. La columna se estira, los talones intentan tocar el suelo y la cabeza se relaja entre los brazos. Esta postura ayuda a estirar y fortalecer los brazos, hombros, piernas y espalda, al tiempo que mejora la circulación sanguínea y alivia el estrés.', 7),
(18, 'Cien (The Hundred)', 'Es uno de los ejercicios más emblemáticos del método Pilates. Comienzas acostado boca arriba con las piernas levantadas y estiradas en un ángulo de 45 grados, los brazos a los lados y la cabeza y los hombros levantados del suelo. Desde esta posición, bombeas los brazos hacia arriba y abajo mientras respiras en un patrón rítmico. El objetivo es mantener la estabilidad del torso y fortalecer los músculos abdominales profundos, así como mejorar la respiración y la circulación.', 5),
(19, 'Puente (Bridge)', 'Este ejercicio se realiza acostado boca arriba con las rodillas flexionadas y los pies apoyados en el suelo, separados a la anchura de las caderas. Desde esta posición, levantas las caderas hacia arriba, formando una línea recta desde los hombros hasta las rodillas. Mantienes la posición durante unos segundos y luego bajas lentamente las caderas de nuevo al suelo. El puente fortalece los músculos de glúteos, abdominales y espalda baja, mientras mejora la estabilidad de la pelvis y la movilidad de la columna vertebral.', 5);

INSERT INTO workshop_CesarPetit.horario (id_horario, hora, id_sucursal, id_tipoclase, cupos)
VALUES
(1, '08:00:00', 1, 1, 20),
(2, '08:00:00', 1, 2, 20),
(3, '08:00:00', 2, 3, 10),
(4, '08:00:00', 2, 3, 10),
(5, '09:00:00', 3, 5, 20),
(6, '10:00:00', 4, 7, 15),
(7, '11:00:00', 6, 4, 20),
(8, '12:00:00', 8, 5, 20),
(9, '13:00:00', 4, 1, 15),
(10, '14:00:00', 5, 2, 15),
(11, '15:00:00', 3, 4, 10),
(12, '16:00:00', 2, 5, 10),
(13, '17:00:00', 1, 7, 20),
(14, '18:00:00', 3, 1, 20),
(15, '19:00:00', 15, 2, 20);

INSERT INTO workshop_CesarPetit.profesor (id_profesor, nombre, apellido, email, horas_diarias)
VALUES
(1, 'Juan', 'Perez', 'juan.perez@example.com', '08:00:00'),
(2, 'Maria', 'Gomez', 'maria.gomez@example.com', '06:30:00'),
(3, 'Carlos', 'Rodriguez', 'carlos.rodriguez@example.com', '07:45:00'),
(4, 'Ana', 'Lopez', 'ana.lopez@example.com', '05:15:00'),
(5, 'David', 'Martinez', 'david.martinez@example.com', '06:00:00'),
(6, 'Laura', 'Fernandez', 'laura.fernandez@example.com', '07:30:00'),
(7, 'Pablo', 'Gonzalez', 'pablo.gonzalez@example.com', '06:45:00'),
(8, 'Sofia', 'Sanchez', 'sofia.sanchez@example.com', '05:45:00'),
(9, 'Diego', 'Torres', 'diego.torres@example.com', '07:15:00'),
(10, 'Andrea', 'Ruiz', 'andrea.ruiz@example.com', '06:15:00'),
(11, 'Martin', 'Diaz', 'martin.diaz@example.com', '07:00:00'),
(12, 'Valentina', 'Pereira', 'valentina.pereira@example.com', '06:30:00'),
(13, 'Alejandro', 'Fernandez', 'alejandro.fernandez@example.com', '07:45:00'),
(14, 'Camila', 'Lopez', 'camila.lopez@example.com', '05:30:00'),
(15, 'Lucas', 'Garcia', 'lucas.garcia@example.com', '06:45:00');

INSERT INTO workshop_CesarPetit.profesor_tipoClase (idProTipoClase, id_tipoClase, id_profesor)
VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 3),
(5, 4, 4),
(6, 1, 2),
(7, 2, 2),
(8, 4, 5),
(9, 1, 6),
(10, 7, 8),
(11, 6, 10),
(12, 3, 2),
(13, 4, 2),
(14, 5, 11),
(15, 6, 15);


INSERT INTO workshop_CesarPetit.profesor_sucursal (id, id_sucursal, id_profesor)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 4, 6),
(7, 5, 1),
(8, 6, 8),
(9, 7, 8),
(10, 7, 9),
(11, 9, 10),
(12, 9, 11),
(13, 12, 14),
(14, 12, 15),
(15, 13, 12);

INSERT INTO workshop_CesarPetit.profesor_horario (id, id_horario, id_profesor)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 3, 3),
(5, 6, 1),
(6, 7, 2),
(7, 8, 3),
(8, 9, 1),
(9, 10, 10),
(10, 11, 13),
(11, 12, 5),
(12, 13, 5),
(13, 14, 6),
(14, 15, 7),
(15, 13, 9);

INSERT INTO workshop_CesarPetit.clase (id_clase, id_horario, id_cliente, fecha_clase, id_tipoClase, id_profesor, id_sucursal)
VALUES
(1, 1, 1, '2023-02-07', 1, 1, 1),
(2, 1, 2, '2023-02-07', 1, 2, 1),
(3, 1, 3, '2023-02-07', 1, 6, 2),
(4, 2, 4, '2023-02-07', 2, 2, 3),
(5, 2, 5, '2023-02-07', 2, 1, 1),
(6, 3, 6, '2023-02-07', 3, 2, 3),
(7, 1, 1, '2023-02-08', 1, 1, 1),
(8, 1, 2, '2023-02-08', 1, 2, 1),
(9, 1, 3, '2023-02-08', 1, 6, 2),
(10, 2, 4, '2023-02-08', 2, 2, 3),
(11, 2, 5, '2023-02-08', 2, 1, 1),
(12, 3, 6, '2023-02-08', 3, 2, 3);

INSERT INTO workshop_CesarPetit.usuario (id_usuario, user, password, email)
VALUES
(1, 'johndoe', '123456', 'john.doe@example.com'),
(2, 'sarahsmith', 'password123', 'sarah.smith@example.com'),
(3, 'mikebrown', 'abcdef', 'mike.brown@example.com'),
(4, 'emilyjones', 'qwerty', 'emily.jones@example.com'),
(5, 'davidwilson', '987654', 'david.wilson@example.com'),
(6, 'lisawilliams', 'p@ssw0rd', 'lisa.williams@example.com'),
(7, 'jasonlee', '777', 'jason.lee@example.com'),
(8, 'amycarter', 'mypass123', 'amy.carter@example.com'),
(9, 'robertsmith', 'abcd1234', 'robert.smith@example.com'),
(10, 'jennifergreen', 'green123', 'jennifer.green@example.com'),
(11, 'williamjones', '123abc', 'william.jones@example.com'),
(12, 'karenmiller', 'miller456', 'karen.miller@example.com'),
(13, 'chrisharris', 'passw0rd', 'chris.harris@example.com'),
(14, 'sandrabrown', 'brownsand', 'sandra.brown@example.com'),
(15, 'paulrobinson', 'robinsonpaul', 'paul.robinson@example.com');


INSERT INTO workshop_CesarPetit.usuario_sucursal (id, id_usuario, id_sucursal)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 1, 2),
(8, 2, 3),
(9, 3, 9),
(10, 3, 10),
(11, 4, 15),
(12, 10, 14),
(13, 9, 13),
(14, 8, 10),
(15, 1, 15);


insert into precios_promocionales()
values(null,300,1300,4000,7000);



-- **************************************************************************************************************************************************************************
-- ******************************************************************************* VISTAS ***********************************************************************************
-- **************************************************************************************************************************************************************************


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- VISTA 1:   ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use workshop_cesarpetit;
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

delimiter ;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- SP 2: SE CREA STORE PRODEDURE QUE INGRESA UN NUEVO PROFESOR
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
DELIMITER ;

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
