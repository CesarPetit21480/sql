delimiter $$
use workshop_cesarpetit$$

/* FUNCION QUE DEVUELVE CUAL ES EL NUMERO MAS GRANDE EN CASO DE IGUALDAD DEVUELVE IGUALES */
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

/* FUNCION QUE DEVUELVE LA CANTIDAD DE PROFESORES QUE HACEN  MAS HORAS  QUE LAS INGRESADAS POR PARAMETRO FORMATO DE INGRESO 00:00*/
CREATE FUNCTION profesoresCantidadHoras ( p_horas time)  returns int
READS SQL DATA
BEGIN

	declare profesoresHoras int ;    
    set profesoresHoras = (select count(*) cantidadProfesores from profesor where horas_diarias >=p_horas);
    return profesoresHoras;
END$$

delimiter ;