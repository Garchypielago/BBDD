/*1. Selecciona las canciones (track) cuyo t�tulo (name) empieza por la misma letra que el nombre
de su compositor (composer)*/
SELECT M.NAME, M.COMPOSER FROM TRACK M WHERE SUBSTR(M.NAME,1,1) LIKE SUBSTR(M.COMPOSER,1,1) ;
/*2.Haz un listado de canciones. El listado tendr� una columna c�digo y el t�tulo (nombre). El
c�digo es un campo que vamos a generar nosotros y ser�n las 3 �ltimas posiciones de la
duraci�n de la canci�n y las 4 primeras del t�tulo en may�sculas.*/
SELECT (SUBSTR(M.MILLISECONDS,-3) ||(SUBSTR(M.NAME,1,4))) CODIGO, M.NAME FROM TRACK M;
/*3. Selecciona las playlist cuyo nombre contenga Music.*/
SELECT * FROM PLAYLIST WHERE NAME LIKE '%Music%';
/*4. Selecciona las canciones de g�neros Pop, Rock y Metal, cuya duraci�n sea superior a
300000 milisegundos y cuyo compositor empiece por la letra A o V.*/
SELECT M.* 
    FROM TRACK M
    INNER JOIN GENRE G ON M.GENREID = G.GENREID
    WHERE G.NAME IN ('Pop','Rock','Metal') AND M.MILLISECONDS>300000 AND SUBSTR(M.COMPOSER,1,1) IN ('A','V');
                                                                                //(M.COMPOSER LIKE ('A%') OR M.COMPOSER LIKE ('V%'))
/*5. Selecciona los clientes que sean una compa��a (el campo compa��a es no nulo). De cada
cliente veremos el nombre, el correo y generamos un campo password que ser�n los 4
primeros caracteres del apellido, en may�sculas, los 3 primeros del c�digo postal y los 3
primeros de la ciudad (en may�sculas)*/
SELECT C.FIRSTNAME, C.EMAIL, UPPER(SUBSTR(C.LASTNAME,1,4))||SUBSTR(C.POSTALCODE,1,3)||UPPER(SUBSTR(C.CITY,1,3)) PASSWORD 
    FROM CUSTOMER C WHERE COMPANY IS NOT NULL;
/*6. Muestra los artistas cuyo nombre tenga m�s de 10 caracteres.*/
SELECT * FROM ARTIST WHERE LENGTH(NAME)>10;
/*7. Saca un listado de �lbumes de Led Zeppelin e Iron Maiden cuyo t�tulo contenga un 1 o un 2.*/
SELECT A.TITLE
    FROM ALBUM A
    INNER JOIN ARTIST AR ON AR.ARTISTID = A.ARTISTID
    WHERE AR.NAME IN ('Led Zeppelin', 'Iron Maiden');
/*8. Saca un listado de facturas (INVOICE) emitidas en los 3 primeros meses de cualquier a�o y
cuyo pa�s sea USA.*/
SELECT * FROM INVOICE I WHERE TO_CHAR(INVOICEDATE, 'MM') IN (1,2,3) AND BILLINGCOUNTRY LIKE 'USA';
/*9. Saca un listado de facturas (INVOICE) emitidas entre el 1 de enero de 2011 y el 30 de junio de 2013 y cuyo pa�s sea Espa�a.*/
SELECT * FROM INVOICE WHERE INVOICEDATE BETWEEN '1,1,2011' AND '30,06,2013' AND BILLINGCOUNTRY LIKE 'Spain';
/*10. Saca un listado de los distintos pa�ses que hayan tenido alguna factura de m�s de 5�.*/
SELECT DISTINCT BILLINGCOUNTRY FROM INVOICE WHERE TOTAL>5;
/*11. Saca un listado de los distintos pa�ses y las distintas ciudades que hayan tenido alguna
factura. El listado debe salir ordenado por pa�s de forma descendente y por ciudad de forma
ascendente.*/
SELECT DISTINCT BILLINGCITY, BILLINGCOUNTRY FROM INVOICE ORDER BY BILLINGCOUNTRY DESC, BILLINGCITY ASC;
/*12. Saca una lista de las canciones cuya direcci�n es un n�mero par.*/
SELECT * FROM TRACK T WHERE MOD(MILLISECONDS,2)=0;
/*13. Saca un listado de facturas para las que entre hoy y la fecha de factura hayan pasado m�s
de 150 meses.*/
SELECT * FROM INVOICE WHERE MONTHS_BETWEEN(SYSDATE, INVOICEDATE)>150;
/*14. Saca una lista de las facturas que se hacen en la 2� quincena de cada mes. Ordenalas por
importe descendente y por ciudad ascendente.*/
SELECT * FROM INVOICE I WHERE TO_CHAR(INVOICEDATE,'DD')>=15 ORDER BY TOTAL DESC, BILLINGCITY ASC;
/*15. Saca una lista de los �lbumes cuyo t�tulo tenga un n�mero impar de letras.*/
SELECT * FROM ALBUM A WHERE MOD(LENGTH(A.TITLE),2)!=0;
/*16. Saca una lista de los �lbumes de Metallica cuyo nombre contenga la palabra All o la palabra
Load.*/
SELECT M.* 
    FROM ALBUM M
    INNER JOIN ARTIST A ON M.ARTISTID = A.ARTISTID
    WHERE A.NAME LIKE ('Metallica') AND (M.TITLE LIKE '%All%' OR M.TITLE LIKE '%Load%');
/*17. Saca una lista de las canciones. Saca el nombre y el precio en euros y en d�lares (cambio
1,04). Pon alias a los campos. Saca s�lo aquellas canciones cuyo mediatype es MPEG audio file.*/

SELECT T.NAME NOMBRE, I.UNITPRICE EUROS, (I.UNITPRICE*1.04) DOLLARS, M.NAME
    FROM TRACK T
    INNER JOIN INVOICELINE I ON T.TRACKID=I.TRACKID
    INNER JOIN MEDIATYPE M ON T.MEDIATYPEID=M.MEDIATYPEID
    WHERE M.NAME LIKE '%MPEG%';
    
/*18. Saca una lista de los distintos compositores cuyo formato de canci�n es MPEG audio file y
cuyo g�nero es Latin.*/
SELECT DISTINCT T.COMPOSER 
    FROM TRACK T
    INNER JOIN GENRE G ON T.GENREID=G.GENREID
    INNER JOIN MEDIATYPE M ON T.MEDIATYPEID=M.MEDIATYPEID
    WHERE G.NAME LIKE 'Latin' AND M.NAME LIKE '%MPEG%';
/*19. Haz una lista de canciones que ocupen entre 4.000.000 y 6.000.000 Kb y cuyo
compositor contenga en el nombre las letras A y O pero no sean la letra por la que empieza su
nombre.*/
SELECT T.* 
     FROM TRACK T WHERE T.BYTES BETWEEN 4000000 AND 6000000 AND (INSTR(UPPER(T.COMPOSER),'A')>1 AND INSTR(UPPER(T.COMPOSER),'O')>1);
/*20. Saca una lista de los distintos compositores, junto con la longitud de su nombre, que tienen
una canci�n que contiene la palabra Love.*/
SELECT T.COMPOSER NOMBRE, LENGTH(T.COMPOSER) LONGITUD, T.NAME
    FROM TRACK T WHERE UPPER(T.NAME) LIKE '%LOVE%';
/*21. Saca una lista de canciones. Queremos ver su nombre y al lado un campo que ponga
LARGO (nombre de la canci�n m�s de 20 caracteres) o corto (otro caso). (Investiga y usa la
cl�usula CASE en las Selects en Oracle)*/

/*22. Haz una lista de las facturas sacando la fecha, el importe y al lado un campo que las
cualifique en CARAS (m�s de 8�), NORMALES (entre 4� y 8�) y BARATAS (menos de 4�). S�lo
para facturas en USA y Canada.*/
/*23. Haz una lista de empleados con 3 columnas: nombre del empleado, d�as que han pasado
desde que naci� hasta que le contrataron y d�as que han pasado desde que le contrataron
hasta ahora.*/
/*24. Haz una lista de clientes con nombre, apellidos y la compa��a. Si la compa��a es nula, que
ponga �Cliente Persona F�sica�. No se puede utilizar el CASE.*/
/*25. Haz una lista de clientes con nombre, apellidos. El nombre lo queremos relleno con * por la
derecha hasta 50 posiciones y el apellido con & hasta 30 posiciones por la izquierda*/

















