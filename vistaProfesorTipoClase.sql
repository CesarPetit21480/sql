use workshop_cesarpetit;
CREATE VIEW vistaCantTipoClase AS (  

  /* ESTA VISTA PERMITE SABER QUE CANTIDAD DE CLASE TIENE EL PROFESOR CON ID = 1)*/

select CONCAT(p.nombre,' ',p.apellido) 'nombre Profesor', tc.nombre, count(*) 'Cantidad Clase' from clase c
inner join profesor p on p.id_profesor = c.id_profesor
inner join tipo_clase tc on tc.id_tipoClase = c.id_tipoClase
where p.id_profesor = 1
GROUP BY(tc.id_tipoClase)
);