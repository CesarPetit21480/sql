CREATE DATABASE workshop_CesarPetit;

USE workshop_CesarPetit;


-- TABLA 1  TABLA DE CLIENTES 
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

-- TABLA 2  SUCURSALES DISPONIBLES
CREATE TABLE IF NOT EXISTS 	workshop_CesarPetit.sucursal
(
id_sucursal int auto_increment primary key,
nombre varchar(50) not null,
direccion varchar(50) not null,
email varchar(70) not null,
index nomSuc(nombre)
);

-- TABLA 3 TIPO DE CLASE QUE SE OFRECEN
CREATE TABLE IF NOT EXISTS workshop_CesarPetit.tipo_clase
(
	id_tipoClase int auto_increment primary key,
    nombre varchar(50) not null,
    descripcion mediumtext null
);


-- TABLA 4 EJERCICIOS DISPONIBLES EN CADA TIPO DE CLASE

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.ejercicios
(
	id_ejercicio int auto_increment primary key,
    nombre varchar(100) not null,
    descripcion varchar(800) null,
    id_tipoClase int not null,
    index nomEjercicio (nombre),    
	constraint fk_tipoClaseEjercicio FOREIGN KEY (id_tipoClase) REFERENCES tipo_clase(id_tipoClase) ON DELETE CASCADE ON UPDATE CASCADE
);


-- TABLA 5 HORARIOS DISPONIBLES POR CLASE

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.horario(

	id_horario int auto_increment primary key,
    hora time not null,
    id_sucursal int not null,
    id_tipoclase int not null,
    cupos int not null,
	constraint fk_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal) ON DELETE RESTRICT ON UPDATE CASCADE,
	constraint fk_tipoClase FOREIGN KEY (id_tipoclase) REFERENCES tipo_clase(id_tipoClase) ON DELETE CASCADE ON UPDATE CASCADE
);


-- TABLA 6 STAFF DE PROFESORES APTOS PARA LAS CLASES

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor
(
	id_profesor int auto_increment primary key,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    email varchar(100) not null,   
    horas_diarias time   
);

-- TABLA 7 TIPO DE CLASES QUE DISPONE LA CADENA

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_tipoClase
(
	idProTipoClase int auto_increment primary key,
    id_tipoClase int not null,
    id_profesor int not null,
    constraint fk_tipoclaseRelacion foreign key(id_tipoClase) references tipo_clase(id_tipoClase) ON DELETE RESTRICT ON UPDATE CASCADE,
    constraint fk_Profesor foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA 8 PROFESORES DISPONIBLES EN LAS SUCURSALES

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_sucursal
(
	id int auto_increment primary key,
    id_sucursal int not null,
    id_profesor int not null,
    constraint fk_sucursalProfesor foreign key(id_sucursal) references sucursal(id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_ProfesorRelacion foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA 9 CARGA HORARIO PROFESOR

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.profesor_horario
(
	id int auto_increment primary key,
    id_horario int not null,
    id_profesor int not null,
    constraint fk_horarioProfesor foreign key(id_horario) references horario(id_horario) ON DELETE CASCADE ON UPDATE CASCADE,
    constraint fk_ProfesorHorario foreign key(id_profesor) references profesor(id_profesor) ON DELETE CASCADE ON UPDATE CASCADE
);


-- TABLA 10 CLASE DIARIAS PARA CADA ACTIVIDAD Y SUCURSAL

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

-- TABLA 11 USUARIOS QUE TRABAJAN EN DICHA CADENA

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.usuario
(
	id_usuario int auto_increment primary key,
    user varchar(20) not null,
    password varchar(100) not null,
    email varchar(60) not null   
);


-- TABLA 12 USUARIO DISPONIBLES EN CADA SUCURSAL

CREATE TABLE IF NOT EXISTS workshop_CesarPetit.usuario_sucursal
(
	id int auto_increment primary key,
	id_usuario int,
	id_sucursal int not null,  
    constraint fk_usuarioSucursal foreign key(id_sucursal) references sucursal(id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,  
	constraint fk_user foreign key(id_usuario) references usuario(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE  
);

-- TABLA 13 PLANES DISPONIBLES EN LA CADENA

CREATE TABLE `planes_disponibles` (
  `id_plan` int NOT NULL AUTO_INCREMENT,
  `precio_diario` decimal(10,2) DEFAULT NULL,
  `precio_semanal` decimal(10,2) DEFAULT NULL,
  `precio_quincenal` decimal(10,2) DEFAULT NULL,
  `precio_mensual` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_plan`)
);

-- TABLA 14 TIPOS DE PAGO HABILITADOS
CREATE TABLE tipo_pago(

	id_tipoPago INT AUTO_INCREMENT,
    descripcion VARCHAR(50),
	PRIMARY KEY (id_tipoPago)
);

-- TABLA 15 TABLA FACTURAS
CREATE TABLE `factura` (
  `id_factura` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `total_factura` decimal(9,2) DEFAULT NULL,
  `fecha_facturacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_tipoPago` int DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  KEY `fk_tipo_pagoFactura` (`id_tipoPago`),
  CONSTRAINT `fk_tipo_pagoFactura` FOREIGN KEY (`id_tipoPago`) REFERENCES `tipo_pago` (`id_tipoPago`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA 16 ITEM FACTURABLES 
CREATE TABLE `itemfacturables` (
  `id_item` int NOT NULL AUTO_INCREMENT,
  `id_Usuario` int DEFAULT NULL,
  `id_Factura` int DEFAULT NULL,
  `id_tipoClase` int DEFAULT NULL,
  `id_tipoPlan` int DEFAULT NULL,
  PRIMARY KEY (`id_item`),
  KEY `fk_usuarioItemsFacturables` (`id_Usuario`),
  KEY `fk_facturaItemsFacturables` (`id_Factura`),
  KEY `fk_tipoPlanitemsFacturables` (`id_tipoPlan`),
  KEY `fk_tipoClaseItemsFacturables_idx` (`id_tipoClase`),
  CONSTRAINT `fk_facturaItemsFacturables` FOREIGN KEY (`id_Factura`) REFERENCES `factura` (`id_factura`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tipoClaseItemsFacturables` FOREIGN KEY (`id_tipoClase`) REFERENCES `tipo_clase` (`id_tipoClase`),
  CONSTRAINT `fk_tipoPlanitemsFacturables` FOREIGN KEY (`id_tipoPlan`) REFERENCES `planes_disponibles` (`id_plan`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_usuarioItemsFacturables` FOREIGN KEY (`id_Usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ;

-- TABLA 17 LOS BAJA CLIENTES
CREATE TABLE workshop_CesarPetit.log_bajaCLiente (
	id int auto_increment primary key,
	id_cliente int,
    fechaBaja DATETIME
);
-- TABLA 18 LOG BAJA CLASE

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
 -- TABLA 19 para generar los item temporales de la factura
 CREATE TABLE subcripcion_temporal(

	id INT AUTO_INCREMENT NOT NULL,
    id_usuario INT NOT NULL,
    id_tipoClase INT NOT NULL,
    id_Plan INT NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_isUserSubscripcion FOREIGN  KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
	CONSTRAINT fk_tipoClaseSubscripcion FOREIGN  KEY (id_tipoClase) REFERENCES tipo_clase(id_tipoClase) ON UPDATE CASCADE,
	CONSTRAINT fk_planSubscripcion FOREIGN  KEY (id_Plan) REFERENCES planes_disponibles(id_plan) ON UPDATE CASCADE
);
