/*1. Devuelve el listado con el nombre de las personas y la matrícula de los coches que
tienen.*/
SELECT P.NOMBRE, M.MATRICULA 
    FROM PERSONAS P
    INNER JOIN MATRICULAS M ON M.DNI = P.DNI;

SELECT P.NOMBRE, M.MATRICULA 
    FROM PERSONAS P
    NATURAL JOIN MATRICULAS M;
    
SELECT P.NOMBRE, MA.MATRICULA FROM  MATRICULAS MA, PERSONAS P WHERE MA.DNI = P.DNI;

/*2. Devuelve el listado con el nombre de las personas y la matrícula de los coches que
tienen. Ordena el resultado por el nombre de la persona de forma ascendente y luego
por la matrícula de forma descendente.*/
SELECT P.NOMBRE, M.MATRICULA 
    FROM PERSONAS P
    INNER JOIN MATRICULAS M ON M.DNI = P.DNI
    ORDER BY P.NOMBRE ASC, M.MATRICULA DESC;

SELECT P.NOMBRE, M.MATRICULA 
    FROM PERSONAS P
    NATURAL JOIN MATRICULAS M
    ORDER BY P.NOMBRE ASC, M.MATRICULA DESC;
    
SELECT P.NOMBRE, MA.MATRICULA FROM  MATRICULAS MA, PERSONAS P WHERE MA.DNI = P.DNI ORDER BY P.NOMBRE ASC, MA.MATRICULA DESC;

/*3. Devuelve un listado de todas las multas. En el listado queremos ver el DNI de la
persona, la matrícula, el importe y el lugar de la multa. Ordenaremos por DNI de forma
ascendente y luego por lugar de forma descendente.*/
SELECT M.DNI, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA = MU.MATRICULA
    ORDER BY M.DNI ASC, MU.LUGAR DESC;
    
SELECT *
    FROM MULTAS 
    NATURAL JOIN MATRICULAS 
    ORDER BY DNI ASC, LUGAR DESC;  //NO DEJA USAR ALIAS 
    
SELECT * FROM MULTAS MU , MATRICULAS MA WHERE MU.MATRICULA=MA.MATRICULA ORDER BY M.DNI ASC, MU.LUGAR DESC;
    
/*4. Devuelve un listado de todas las multas. En el listado queremos ver el nombre de la
persona, el DNI de la persona, la matrícula, el importe y el lugar de la multa.
Ordenaremos por nombre de forma descendente y luego por importe de forma
descendente.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA = MU.MATRICULA
    INNER JOIN PERSONAS P ON M.DNI = P.DNI
    ORDER BY P.NOMBRE DESC, MU.IMPORTE DESC;
    
SELECT P.*, MU.*
    FROM MULTAS MU
    NATURAL JOIN MATRICULAS MA
    NATURAL JOIN PERSONAS P
    ORDER BY P.NOMBRE DESC, MU.IMPORTE DESC;
    
SELECT * FROM MULTAS MU , MATRICULAS MA, PERSONAS P WHERE MU.MATRICULA=MA.MATRICULA AND MA.DNI = P.DNI;

/*5. Devuelve un listado de las multas de más de 100€. En el listado queremos ver el
nombre de la persona, el DNI de la persona, la matrícula, el importe y el lugar de la
multa. Ordenaremos por nombre de forma descendente y luego por importe de forma
descendente.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE>100
    ORDER BY P.NOMBRE DESC, MU.IMPORTE DESC;
    
SELECT P.*, MU.*
    FROM MULTAS MU, MATRICULAS M, PERSONAS P WHERE M.MATRICULA=MU.MATRICULA AND P.DNI=M.DNI AND MU.IMPORTE>100 ORDER BY P.NOMBRE DESC, MU.IMPORTE DESC;

/*6. Devuelve un listado de las multas de menos de 100€ y para las personas cuyo nombre
empiece por C. En el listado queremos ver el nombre de la persona, el DNI de la
persona, la matrícula, el importe y el lugar de la multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE<100 AND P.NOMBRE LIKE ('%, C%');
    
SELECT P.*, MU.*
    FROM MULTAS MU, MATRICULAS M, PERSONAS P WHERE P.DNI=M.DNI AND M.MATRICULA=MU.MATRICULA
    AND MU.IMPORTE<100 AND P.NOMBRE LIKE ('%, C%');
/*7. Devuelve un listado de las multas de entre 50 y 100€ y para las personas cuyo nombre
empiece por C y cuyo DNI contenga un 8 . En el listado queremos ver el nombre de la
persona, el DNI de la persona, la matrícula, el importe y el lugar de la multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE BETWEEN 50 AND 100 AND P.NOMBRE LIKE ('C%') AND P.DNI LIKE ('%8%');
    
SELECT P.*, MU.*
    FROM MULTAS MU, MATRICULAS M, PERSONAS P WHERE P.DNI=M.DNI AND M.MATRICULA=MU.MATRICULA
    AND MU.IMPORTE BETWEEN 50 AND 100 AND P.NOMBRE LIKE ('C%') AND P.DNI LIKE ('%8%');
    
/*8. Devuelve un listado de las multas de 50€, las de 100€ y las que se hayan producido
en la calle Alcalá. En el listado queremos ver el nombre de la persona, el DNI de la
persona, la matrícula, el importe y el lugar de la multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE = 50 OR MU.IMPORTE=100 OR UPPER(MU.LUGAR) LIKE ('%ALCALA%');
    
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE in (50,100) OR UPPER(MU.LUGAR) LIKE ('%ALCALA%');
    
/*9. Devuelve un listado de las multas de 50€ y las de 100€ que se hayan producido en la
calle Alcalá. En el listado queremos ver el nombre de la persona, el DNI de la persona,
la matrícula, el importe y el lugar de la multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE = 50 OR MU.IMPORTE=100 AND UPPER(MU.LUGAR) LIKE ('%ALCALA%');
   
/*10. Devuelve un listado de las multas de 50€ y 100€ que se hayan producido en la calle
Alcalá. En el listado queremos ver el nombre de la persona, el DNI de la persona, la
matrícula, el importe y el lugar de la multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MU.IMPORTE BETWEEN 50 AND 100 AND UPPER(MU.LUGAR) LIKE ('%ALCALA%');
    
/*11. Devuelve un listado con las distintas personas (el nombre) de aquellas personas que
han tenido multas en lugares que contengan una A.*/
SELECT DISTINCT P.NOMBRE
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE UPPER(MU.LUGAR) LIKE ('%A%');

/*12. Devuelve un listado con las distintas personas (el nombre) y las distintas matrículas de
aquellas personas que han tenido multas en lugares que contengan una A.*/
SELECT DISTINCT P.NOMBRE, M.MATRICULA
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE UPPER(MU.LUGAR) LIKE ('%A%');
    
/*13. Devuelve un listado de las multas en las que el nombre de la persona empieza por la
misma letra que el lugar donde han les han puesto la multa. En el listado queremos ver
el nombre de la persona, el DNI de la persona, la matrícula, el importe y el lugar de la
multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE SUBSTR(UPPER(MU.LUGAR),1,1) LIKE SUBSTR(UPPER(P.NOMBRE),1,1);

/*14. Devuelve un listado de las multas en las que la parte numérica del DNI es divisible por
el importe de la multa (el resto de esa división es 0). En el listado queremos ver el
nombre de la persona, el DNI de la persona, la matrícula, el importe y el lugar de la
multa.*/
SELECT P.*, MU.*
    FROM MULTAS MU
    INNER JOIN MATRICULAS M ON M.MATRICULA=MU.MATRICULA
    INNER JOIN PERSONAS P ON P.DNI=M.DNI
    WHERE MOD(SUBSTR(P.DNI,1,9),MU.IMPORTE)=0;

/*15. Devuelve un listado de las personas cuyo nombre contiene la letra de su DNI*/
SELECT P.*, INSTR(P.NOMBRE,SUBSTR(P.DNI,-1)) POSICION  FROM PERSONAS P WHERE INSTR(P.NOMBRE,SUBSTR(P.DNI,-1))>0;
