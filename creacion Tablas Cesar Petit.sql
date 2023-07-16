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
    nombre varchar(50) not null,
    descripcion mediumtext null,
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

