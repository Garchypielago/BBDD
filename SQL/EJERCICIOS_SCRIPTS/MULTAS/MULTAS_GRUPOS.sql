/*1. Calcula el n�mero total de Personas que hay en la tabla Producto.*/
SELECT COUNT (1) FROM PERSONAS;

/*2. Calcula el n�mero total de Multas que hay en la tabla Proveedor*/
SELECT COUNT (1) FROM MULTAS;

/*3. Calcula la media de las multas*/
SELECT ROUND(AVG(IMPORTE),2) FROM MULTAS;

/*4. Calcula la multa m�s alta.*/
SELECT MAX(IMPORTE) FROM MULTAS;

/*5. Calcula la multa m�s baja.*/
SELECT MIN(IMPORTE) FROM MULTAS;

/*6. Calcula la suma de todas las multas.*/
SELECT SUM(IMPORTE) FROM MULTAS;


/*7. Calcula la multa m�s alta, la m�s baja, la media de multas y la suma de multas para los
coches cuya matr�cula empieza por 6.*/
SELECT MAX(IMPORTE), MIN(IMPORTE), AVG(importe), SUM(importe) 
    FROM MULTAS
    WHERE matricula LIKE '6%';

/*8. Calcula la multa m�s alta, la m�s baja, la media de multas, la suma de multas y el n�mero
total de multas para los coches cuyo DNI empieza por 1.*/
SELECT MAX(IMPORTE), MIN(IMPORTE), AVG(importe), SUM(importe), COUNT(1)
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    WHERE ma.DNI LIKE '1%';

/*9. Muestra el n�mero total de multas que tiene cada persona. Se mostrar� en dos columnas,
una con el nombre de la persona y otra con el n�mero de multas. Debe estar ordenado por el
n�mero total de multas descendente*/
SELECT pe.nombre, COUNT (1)
    FROM multas MU
    JOIN matriculas MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    GROUP BY pe.nombre;

/*10. Muestra la multa m�s alta y m�s baja que tiene cada persona. Se mostrar� en dos
columnas, una con el nombre de la persona y otra con el n�mero de multas.*/
SELECT pe.nombre, MAX(mu.importe), MIN(mu.importe)
    FROM multas MU
    JOIN matriculas MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    GROUP BY pe.nombre;

/*11. Calcula el n�mero total de multas que tienen un importe mayor a 50�.*/
SELECT COUNT (1)
    FROM multas
    WHERE IMPORTE>50;

/*12. Calcula el n�mero de personas que tienen una multa con importe superior a 50�.*/
SELECT COUNT (DISTINCT pe.dni)
    FROM PERSONAS PE
    JOIN MATRICULAS ma ON ma.dni=pe.dni
    JOIN MULTAS MU ON mu.matricula=ma.matricula
    WHERE mu.importe>50;

/*13. Lista los nombres de las personas que tengan 2 o m�s multas.*/
SELECT pe.nombre, COUNT (1)
    FROM multas MU
    JOIN matriculas MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    GROUP BY pe.nombre
    HAVING COUNT(1)>1;

/*14. Lista los nombres de las personas que tengan m�s de 100� en multas*/
SELECT pe.nombre, SUM(mu.importe)
    FROM multas MU
    JOIN matriculas MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    GROUP BY pe.nombre
    HAVING SUM(MU.IMPORTE)>100;

/*15. Devuelve un listado con el total de multas y el promedio de estas agrupando por la primera
letra del apellido.*/
SELECT SUBSTR(pe.nombre,1,1), COUNT (1), ROUND(AVG(MU.IMPORTE),2)
    FROM multas MU
    JOIN matriculas MA ON ma.matricula=mu.matricula
    JOIN personas PE ON pe.dni=ma.dni
    GROUP BY SUBSTR(pe.nombre,1,1);

/*16. Devuelve un listado con el total de multas y el promedio de estas, la multa m�s alta y la
m�s baja agrupando por el primer car�cter de la matr�cula. Saca en el listado s�lo los registros
en los que haya m�s de 3 multas para el primer car�cter de la matr�cula.*/
SELECT SUBSTR(ma.matricula,1,1), COUNT(1), MAX(IMPORTE), MIN(IMPORTE), AVG(importe), SUM(importe)
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN personas PE ON pe.dni=ma.dni
    GROUP BY SUBSTR(ma.matricula,1,1)
    HAVING COUNT(1)>3;