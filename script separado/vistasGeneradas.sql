use workshop_cesarpetit;
CREATE VIEW vistaCantTipoClase AS (

  /* ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)*/
select CONCAT(p.nombre,' ',p.apellido) 'nombre Profesor', tc.nombre, count(*) 'Cantidad Clase' from clase c

inner join profesor p on p.id_profesor = c.id_profesor

inner join tipo_clase tc on tc.id_tipoClase = c.id_tipoClase

where p.id_profesor = 1
GROUP BY(tc.id_tipoClase)
);

CREATE VIEW v_clases_info AS(

SELECT c.id_clase, h.hora, c.fecha_clase, s.nombre as nombre_sucursal, p.nombre as nombre_profesor, tc.nombre as tipo_clase

FROM clase c

INNER JOIN horario h ON c.id_horario = h.id_horario

INNER JOIN sucursal s ON c.id_sucursal = s.id_sucursal

INNER JOIN profesor p ON c.id_profesor = p.id_profesor

INNER JOIN tipo_clase tc ON c.id_tipoClase = tc.id_tipoClase);


CREATE VIEW v_clases_por_cliente AS(

SELECT c.id_cliente, CONCAT(c.nombre, ' ', c.apellido) as nombre_completo, COUNT(cl.id_clase) as total_clases

FROM cliente c

LEFT JOIN clase cl ON c.id_cliente = cl.id_cliente

GROUP BY c.id_cliente, nombre_completo);


CREATE VIEW v_cupos_horario_sucursal AS(

SELECT h.id_horario, h.hora, s.nombre as nombre_sucursal,

    h.cupos as total_cupos,

    h.cupos - COUNT(cl.id_clase) as cupos_disponibles

	FROM horario h

	INNER JOIN sucursal s ON h.id_sucursal = s.id_sucursal

	LEFT JOIN clase cl ON h.id_horario = cl.id_horario

	GROUP BY h.id_horario, h.hora, s.nombre, h.cupos
);