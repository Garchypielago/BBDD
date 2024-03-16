/*1. Devuelve las multas cuyo importe sea mayor que la multa más alta en CASTELLANA.*/
SELECT * 
    FROM MULTAS MU
    WHERE MU.importe>(SELECT MAX(MU2.IMPORTE)
                        FROM MULTAS MU2
                        WHERE MU2.lugar LIKE '%CASTELLANA%');
                        
SELECT * 
    FROM MULTAS MU
    JOIN (SELECT MAX(MU2.IMPORTE) MAX_IMPORTE
                FROM MULTAS MU2
                WHERE MU2.lugar LIKE '%CASTELLANA%') TABLA
            ON TABLA.max_importe < mu.importe;


/*2. Devuelve nombre de la persona, matrícula del coche y lugar de la multa para la multa más
alta.*/
SELECT PE.NOMBRE, MA.MATRICULA, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    WHERE mu.importe = (SELECT MAX(MU2.IMPORTE)
                            FROM multas MU2);
                            
SELECT PE.NOMBRE, MA.MATRICULA, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    JOIN (SELECT MAX(MU2.IMPORTE) MAX_IMPORTE
                FROM multas MU2) TABLA
            ON TABLA.max_importe=mu.importe;

/*3. Devuelve nombre de la persona, matrícula del coche y lugar de la multa para la multa más
baja.*/
SELECT PE.NOMBRE, MA.MATRICULA, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    WHERE mu.importe = (SELECT MIN(MU2.IMPORTE)
                            FROM multas MU2);
                            
SELECT PE.NOMBRE, MA.MATRICULA, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    JOIN (SELECT MIN(MU2.IMPORTE) MIN_IMPORTE
                FROM multas MU2) TABLA ON TABLA.MIN_IMPORTE=mu.importe;

/*4. Devuelve nombre de la persona, matrícula del coche y lugar de la multa para todas las
multas por encima de la media de importe de las multas.*/
SELECT PE.NOMBRE, MA.MATRICULA, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    WHERE mu.importe > (SELECT AVG(MU2.IMPORTE)
                            FROM multas MU2);

/*5. Devuelve las personas y el número de multas que ha tenido cada persona (incluyendo
también las personas que no han tenido multas)*/
SELECT PE.*, (SELECT COUNT(MU.REF)
                FROM MULTAS MU
                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                WHERE PE.DNI=PE2.DNI) MULTAS
    FROM PERSONAS PE ;
    
SELECT PE.*, (SELECT COUNT(MU.REF)
                FROM MULTAS MU
                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                WHERE PE.DNI=PE2.DNI) CANT_MULTAS
                ,
                CASE WHEN   (SELECT SUM(MU.REF)
                                FROM MULTAS MU
                                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                                WHERE PE.DNI=PE2.DNI) 
                IS NULL THEN 0 
                ELSE        (SELECT SUM(MU.REF)
                                FROM MULTAS MU
                                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                                WHERE PE.DNI=PE2.DNI)
                END SUM_MULTAS
    FROM PERSONAS PE ;
    

/*6. Devuelve para cada persona la multa más alta que tenga, el coche (matrícula) con el que se
la han puesto y el lugar donde se la han puesto.*/
SELECT PE.DNI, mu.importe, ma.matricula, mu.lugar
    FROM personas PE
    JOIN MATRICULAS MA ON ma.dni=pe.dni
    JOIN MULTAS MU ON mu.matricula=ma.matricula
    JOIN (SELECT PE2.DNI DNI, MAX(mu2.importe) ALTO
                FROM personas PE2
                JOIN MATRICULAS MA2 ON ma2.dni=pe2.dni
                JOIN MULTAS MU2 ON mu2.matricula=ma2.matricula
                GROUP BY PE2.DNI) ALTA ON ALTA.dni=PE.DNI
    WHERE mu.importe=ALTA.ALTO;
    
SELECT PE.DNI, mu.importe, ma.matricula, mu.lugar
    FROM personas PE
    JOIN MATRICULAS MA ON ma.dni=pe.dni
    JOIN MULTAS MU ON mu.matricula=ma.matricula
    WHERE mu.importe=(SELECT MAX(mu2.importe)
                            FROM personas PE2
                            JOIN MATRICULAS MA2 ON ma2.dni=pe2.dni
                            JOIN MULTAS MU2 ON mu2.matricula=ma2.matricula
                            WHERE PE.DNI=PE2.DNI);

/*7. Consulta persona, matrícula, importe de la multa y lugar para todas las multas cuyo importe
coincida con el importe de alguna multa puesta en la calle VELAZQUEZ.*/
SELECT PE.DNI, PE.NOMBRE, MA.MATRICULA, MU.IMPORTE, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    WHERE MU.importe IN (SELECT MU2.IMPORTE
                        FROM MULTAS MU2
                        WHERE MU2.lugar LIKE '%VELAZQUEZ%');

SELECT PE.DNI, PE.NOMBRE, MA.MATRICULA, MU.IMPORTE, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    JOIN (SELECT MU2.IMPORTE IMPORTE
                FROM MULTAS MU2
                WHERE MU2.lugar LIKE '%VELAZQUEZ%') TABLA 
                ON TABLA.importe=mu.importe;

/*8. Consulta persona, matrícula, importe de la multa y lugar para todas las multas de personas
que tengan más de 1 multa*/
SELECT PE.DNI, PE.NOMBRE, MA.MATRICULA, MU.IMPORTE, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    WHERE (SELECT COUNT(MU.REF)
                FROM MULTAS MU
                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                WHERE PE.DNI=PE2.DNI)>1;
                
SELECT PE.DNI, PE.NOMBRE, MA.MATRICULA, MU.IMPORTE, MU.LUGAR
    FROM MULTAS MU
    JOIN MATRICULAS MA ON ma.matricula=mu.matricula
    JOIN PERSONAS PE ON pe.dni=ma.dni
    JOIN (SELECT PE2.DNI DNI, COUNT(MU.REF) CONTEO
                FROM MULTAS MU
                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                GROUP BY PE2.DNI
                HAVING COUNT(MU.REF)>1) TABLA 
                ON TABLA.dni=pe.dni;

/*9. Consulta las personas que NO han tenido multas. Si puedes, hazlo de 2 formas distintas.*/
SELECT *
    FROM PERSONAS PE
    WHERE pe.dni NOT IN (SELECT PE2.DNI
                                FROM PERSONAS PE2
                                JOIN MATRICULAS MA ON MA.DNI=PE2.DNI
                                JOIN MULTAS MU ON MU.MATRICULA=MA.MATRICULA);

SELECT PE.DNI
    FROM PERSONAS PE
    WHERE (SELECT COUNT(MU.REF)
                FROM MULTAS MU
                JOIN MATRICULAS MA ON ma.matricula=mu.matricula
                JOIN PERSONAS PE2 ON PE2.DNI=ma.dni
                WHERE PE.DNI=PE2.DNI) = 0;

/*10. Devuelve la suma de todas las multas agrupadas por el primer caracter de la matrícula
siempre que para ese primer caracter de la matrícula exista una multa que supere la media de
importes de las multas.*/
SELECT SUBSTR(mu.matricula,1,1), SUM(mu.importe), MAX(mu.importe)
    FROM MULTAS MU
    GROUP BY SUBSTR(mu.matricula,1,1)
    HAVING MAX(MU.IMPORTE) > (SELECT AVG(MU2.IMPORTE)
                            FROM MULTAS MU2);
    

    
    
    
    
    
    
    
