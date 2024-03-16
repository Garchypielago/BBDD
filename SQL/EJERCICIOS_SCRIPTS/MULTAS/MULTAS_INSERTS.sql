/*1. Crea un nueva persona indicando con DNI �123456789D� y Nombre �Alumno
Aprendiendo�*/
INSERT INTO personas VALUES ('123456789D', 'Alumno Aprendiendo');

/*2. Inserta 2 coches asociados a esta persona con matr�culas '3344-PPP' y '2221-JJJ',*/
INSERT INTO matriculas VALUES ('2221-JJJ','123456789D');
INSERT INTO matriculas VALUES ('3344-PPP','123456789D');

/*3. Crea una multa en la CALLE PADRE CLARET de 150� para el coche con matr�cula
'2221-JJJ' y otra de 100� en CALLE CORAZON DE MARIA para el coche con matr�cula
'3344-PPP'.*/
INSERT INTO MULTAS(lugar,importe,matricula,ref) VALUES ('CALLE PADRE CLARET',150,'2221-JJJ','031');
INSERT INTO MULTAS(lugar,importe,matricula,ref) VALUES ('CALLE CORAZON DE MARIA',100,'3344-PPP','032');

SELECT * FROM MULTAS WHERE ref IN ('032','031');

/*4. Modifica esta �ltima multa y ponla de 200�.*/
UPDATE MULTAS SET importe=200 WHERE ref='032';

SELECT * FROM MULTAS WHERE ref IN ('032','031');

/*5. Crea una vista con el nombre vista_personas_total_multas que tenga las siguientes
columnas: DNI de la persona, nombre de la persona e importe total de multas que
tiene considerando todos los coches/matr�culas que tenga esa persona.*/
CREATE OR REPLACE VIEW vista_personas_total_multas AS
SELECT pe.dni DNI, pe.nombre NOM, nvl(SUM(mu.importe),0) IMP_TOTAL
    FROM personas PE
    LEFT JOIN matriculas MA ON ma.dni=pe.dni
    LEFT JOIN multas MU ON mu.matricula=ma.matricula
    GROUP BY pe.dni, pe.nombre;
    
select * from vista_personas_total_multas;

/*6. Elimina la persona 222549765B. �Es posible eliminarlo? �Por qu�? Si no pudiste, �qu�
cambios deber�as realizar para que fuese posible borrarlo?*/
DELETE personas WHERE DNI LIKE '222549765B';
//DELETE personas WHERE DNI LIKE '222549765B'  Informe de error -ORA-02292: restricci�n de integridad (MULTAS.FKMATRICULAS) violada - registro secundario encontrado
//NO ME DEJA POR QUE ES UNA FOREING KEY EN MATRICULAS Y TIENE DATOS ASOCIADOS
//PODRIA BORRAR EN CASCADA O ELIMINAR PRIMERO LOS VALORES DE MULTAS Y MATRICULAS 
//O UNIR TABLAS DE ALGUN MODO ej: DELETE personas matriculas multas WHERE DNI LIKE '222549765B';


/*7. Elimina la persona 147956320S �Es posible eliminarlo?�Por qu�?Si no pudiste, �qu�
cambios deber�as realizar para que se pudiera borrar?*/
DELETE personas WHERE DNI LIKE '147956320S';
//SI HE PODIDO, SUPONGO QUE LA PERSONA N TENIA ASOCIADA NINGUNA MATRICULA, ES DECIR NO ERA FOREING KEY

/*8. Actualiza el DNI de la persona con DNI 452103687F y as�gnale el valor 452103687D. �Es
posible actualizarlo? Si no es posible, �qu� cambios deber�as realizar para que se
pudiera actualizar?*/
UPDATE personas SET DNI='452103687D' WHERE DNI='452103687F';
//SI HE PODIDO 

/*9. Actualiza el DNI de la persona 203254778N y as�gnale el valor 203254778H. �Es posible
actualizarlo? Si no es posible, �qu� cambios deber�as realizar para que fuese posible
actualizarlo?*/
UPDATE personas SET DNI='203254778H' WHERE DNI='203254778N';
//NO HE PODIDO POR UN ERROR DE FK EN MULTAS.FKMATRICULAS

/*10. Crea una nueva columna en la tabla de multas que indique si la multa est� pagado. El
nombre de la columna ser� �PAGADO�, ser� de 1 s�lo car�cter y el valor para todos los
campos debe ser N*/
SAVEPOINT ANTES10;

ALTER TABLE MULTAS
    ADD PAGADO VARCHAR2(1) DEFAULT 'N' NOT NULL;

/*11. Crea una nueva columna en la tabla de multas que sea �DESC_PUNTOS�. Tambi�n es
un car�cter de una �nica posici�n y se debe rellenar con la siguiente l�gica.
    1. Para las multas de 200� o menos => Se rellena con N
    2. Para las multas de m�s de 200� => Se rellena con S   */
ALTER TABLE MULTAS
    ADD DESC_PUNTOS VARCHAR2(1) DEFAULT 'N' NOT NULL;
    
UPDATE MULTAS SET DESC_PUNTOS='S' WHERE IMPORTE>200;

SELECT * 
    FROM multas;

/*12. Elimina todas las multas de importe menor a 10�*/ //HAY UNA DE 2�
DELETE multas WHERE multas.importe<10;

SELECT * 
    FROM multas;

