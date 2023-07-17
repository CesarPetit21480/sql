delimiter $$
use workshop_CesarPetit $$


insert into cliente()
values
(null,'CESAR','PETIT','1980-04-21','2020-01-01','cesar_petit@hotmail.com',0),
(null,'JUAN','GOMEZ','1980-04-22','2020-01-02','juan_gomez@hotmail.com',0),
(null,'ERNESTO','ROLDAN','1980-04-23','2020-01-03','ernesto_roldan@hotmail.com',0),
(null,'PEDRO','PEREZ','1980-04-24','2020-01-04','pedro_perez@hotmail.com',0),
(null,'JOAQUIN','LON','1980-04-25','2020-01-05','joaquin_lon@hotmail.com',0),
(null,'LUIS','CAPRI','1980-04-26','2020-01-06','luis_capri@hotmail.com',0),
(null,'GASTON','CORNIO','1980-04-27','2020-01-07','gaston_cornio@hotmail.com',0),
(null,'ENRIQUE','MENTS','1980-04-28','2020-01-08','enrique_ments@hotmail.com',0),
(null,'MARIANA','SOMAS','1980-04-29','2020-01-09','mariana_somas@hotmail.com',0),
(null,'ESTELA','OCHI','1980-04-30','2020-01-10','estela_ochi@hotmail.com',0),
(null,'CAROLA','CASTELO','1980-05-01','2020-01-11','carola_castelo@hotmail.com',0),
(null,'DELFINA','ARIAS','1980-05-02','2020-01-12','delfina_arias@hotmail.com',0),
(null,'CAROLINA','GARCIA','1980-05-03','2020-01-13','carolina_garcia@hotmail.com',0),
(null,'SILVIA','LUNA','1980-05-04','2020-01-14','silvia_luna@hotmail.com',0),
(null,'LUZ','APAGADA','1980-05-05','2020-01-15','luz_apagada@hotmail.com',0);

INSERT INTO sucursal ()
VALUES
(null,'ALMAGRO','Av. Medrano 1234','almagro_sport@hotmail.com'),
(null,'BALVANERA','Calle Bartolome Mitre 567','balvanera_sport@hotmail.com'),
(null,'BARRACAS','Av. Montes de Oca 789','barracas_sport@hotmail.com'),
(null,'RECOLETA','Calle Junin 4321','recoleta_sport@hotmail.com'),
(null,'CABALLITO','Av. Rivadavia 1356','caballito_sport@hotmail.com'),
(null,'COLEGIALES','Calle Federico Lacroze 2468','colegiales_sport@hotmail.com'),
(null,'CHACARITA','Av. Corrientes 3546','chacarita_sport@hotmail.com'),
(null,'VILLA ORTUZAR','Calle Tronador 789','villa ortuzar_sport@hotmail.com'),
(null,'MONTSERRAT','Av. de Mayo 1023','montserrat_sport@hotmail.com'),
(null,'PUERTO MADERO','Calle Juana Manso 5678','puerto madero_sport@hotmail.com'),
(null,'SAAVEDRA','Av. García del Rio 9012','saavedra_sport@hotmail.com'),
(null,'SAN CRISTOBAL','Calle Jujuy 345','san cristobal_sport@hotmail.com'),
(null,'SAN NICOLAS','Av. Corrientes 6789','san nicolas_sport@hotmail.com'),
(null,'PARQUE PATRICIOS','Calle Amancio Alcorta 123','parque patricios_sport@hotmail.com'),
(null,'PARQUE CHACABUCO','Av. Asamblea 4567','parque chacabuco_sport@hotmail.com');


INSERT INTO tipo_clase()
VALUES
(null,'CrossFit','Un enfoque de entrenamiento de alta intensidad que combina levantamiento de pesas ejercicios cardiovasculares y movimientos funcionales.'),
(null,'Funcional','Se centra en mejorar la fuerza resistencia y movimientos necesarios para actividades diarias y deportes especificos.'),
(null,'Spinning', 'Entrenamiento de intervalos de alta intensidad que combina rafagas cortas de ejercicio intenso con periodos de descanso activo.'),
(null,'oli','Entrenamiento levantamiento'),
(null,'pilates','Un enfoque de entrenamiento que se centra en el control muscular la postura y la respiracion- combinando movimientos suaves y fluidos.'),
(null,'HIIT' ,'Entrenamiento de intervalos de alta intensidad que combina rafagas cortas de ejercicio intenso con periodos de descanso activo.'),
(null,'yoga','Una disciplina que combina posturas fisicas -respiracion y meditacion para mejorar la fuerza - flexibilidad y equilibrio mental.');


INSERT INTO ejercicios()
VALUES
(null,'Burpees','Ejercicio de cuerpo completo en el que te agachas - haces una flexion de brazos - saltas con las manos sobre la cabeza y luego vuelves a la posicion inicial.',1),
(null,'Wall Balls','Consiste en lanzar una pelota medicinal contra una pared a una altura determinada- y atraparla al volver.',1),
(null,'Box Jumps','Saltar sobre una caja o plataforma y luego bajar con seguridad.',1),
(null,'Kettlebell Swing','Balanceo de una pesa rusa (kettlebell) entre las piernas y luego proyectandola hacia adelante con un movimiento explosivo.',1),
(null,'Plancha','Posicion en la que te apoyas sobre los antebrazos y los dedos de los pies - manteniendo el cuerpo recto y tenso durante un tiempo determinado.',2),
(null,'Mountain Climbers','Posicion de plancha alterna en la que llevas las rodillas al pecho- simulando la accion de correr.',2),
(null,'Russian Twist','Sentado con las piernas levantadas - giras el torso de un lado a otro mientras sostienes un peso o pelota medicinal.',2),
(null,'Box Jumps','Saltar sobre una caja o plataforma y luego bajar con seguridad.',2),
(null,'Sprint en bicicleta estacionaria', 'Pedaleo intenso y rapido durante un corto periodo de tiempo para simular un sprint en una bicicleta estatica.',3),
(null,'Climbing Hills','Ajustar la resistencia de la bicicleta para simular subir una colina empinada mientras pedaleas.',3),
(null,'Jumping Jacks','Salto lateral mientras pedaleas rapidamente en la bicicleta estatica.',4),
(null,'Sprints en la cinta','Correr a alta velocidad en una cinta de correr durante un breve periodo de tiempo.',6),
(null,'Plank to Push-Up','Comenzar en posicion de plancha y luego pasar a una posicion de flexion de brazos (push-up)- alternando los brazos.',6),
(null,'Thrusters','Combinacion de una sentadilla frontal con una elevacion de pesas sobre la cabeza.',1),
(null,'Assault Bike','Utilizacion de una bicicleta estatica con manivelas para realizar un pedaleo intenso y rapido.',3),
(null,'Saludo al Sol (Surya Namaskar)', 'Es una secuencia fluida de movimientos que combina varias posturas - estiramientos y respiracion consciente. Se realiza en secuencias repetitivas- coordinando la respiracion con el movimiento. El Saludo al Sol ayuda a calentar el cuerpo mejorar la flexibilidad- fortalecer los musculos y aumentar la concentracion.',7),
(null,'Postura del Perro hacia Abajo (Adho Mukha Svanasana)', 'Es una postura clasica del yoga que se realiza a cuatro patas- formando una V invertida con el cuerpo. Las manos estan separadas a la anchura de los hombros y los pies a la anchura de las caderas. La columna se estira- los talones intentan tocar el suelo y la cabeza se relaja entre los brazos. Esta postura ayuda a estirar y fortalecer los brazos- hombros, piernas y espalda- al tiempo que mejora la circulacion sanguinea y alivia el estres.',7),
(null,'Cien (The Hundred)', 'Es uno de los ejercicios mas emblematicos del metodo Pilates. Comienzas acostado boca arriba con las piernas levantadas y estiradas en un angulo de 45 grados- los brazos a los lados y la cabeza y los hombros levantados del suelo. Desde esta posicion- bombeas los brazos hacia arriba y abajo mientras respiras en un patron ritmico. El objetivo es mantener la estabilidad del torso y fortalecer los musculos abdominales profundos- asi como mejorar la respiracion y la circulacion.',5),
(null,'Puente (Bridge)', 'Este ejercicio se realiza acostado boca arriba con las rodillas flexionadas y los pies apoyados en el suelo- separados a la anchura de las caderas. Desde esta posicion, levantas las caderas hacia arriba- formando una linea recta desde los hombros hasta las rodillas. Mantienes la posicion durante unos segundos y luego bajas lentamente las caderas de nuevo al suelo. El puente fortalece los musculos de gluteos- abdominales y espalda baja, mientras mejora la estabilidad de la pelvis y la movilidad de la columna vertebral.',5);

INSERT INTO horario ()
VALUES
(null,'08:00',1,1,20),
(null,'08:00',1,2,20),
(null,'08:00',2,3,10),
(null,'08:00',2,3,10),
(null,'09:00',3,5,20),
(null,'10:00',4,7,15),
(null,'11:00',6,4,20),
(null,'12:00',8,5,20),
(null,'13:00',4,1,15),
(null,'14:00',5,2,15),
(null,'15:00',3,4,10),
(null,'16:00',2,5,10),
(null,'17:00',1,7,20),
(null,'18:00',3,1,20),
(null,'19:00',15,2,20);




