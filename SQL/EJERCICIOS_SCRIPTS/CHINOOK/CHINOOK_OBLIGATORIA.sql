/*1. Inserta al artista Manolo Escobar*/
SELECT * FROM ARTIST; 
INSERT INTO artist VALUES (900, 'Manolo Escobar');

/*2. Inserta 1 album para Manolo Escobar, llamado “Coplas de oro”*/
SELECT * FROM ALBUM;
INSERT INTO album VALUES (900, 'Coplas de oro', 900);

/*3. Inserta 2 canciones para este álbum, Mi carro y La minifalda. Asocialas al género Rock.*/
SELECT * FROM TRACK;
SELECT * FROM GENRE;
INSERT INTO TRACK VALUES (9000, 'Mi carro', 900, 1, 1, 'Manolo Escobar', 900000, 900000, '9,99');
INSERT INTO TRACK VALUES (9009, 'Mi carro', 900, 1, 1, 'La minifalda', 900000, 900000, '9,99');

/*4. Crea un nuevo género llamado Copla. Asocia, con una única sentencia, todas las
canciones de Manolo Escobar al género Copla.*/
INSERT INTO genre VALUES (99, 'Copla');

UPDATE TRACK TR SET genreid=99 
WHERE albumid IN (SELECT AL.ALBUMID
                    FROM album AL
                    WHERE AL.artistid=900);
                    
/*5. Crea un nuevo campo en la tabla de canciones (track) que sea numero_listas.*/
ALTER TABLE TRACK ADD NUMERO_LISTA NUMBER(4)DEFAULT 0 NOT NULL;

/*6. Actualiza para todas las canciones el número de distintas listas en el que está cada
canción.*/
UPDATE TRACK TR SET numero_lista = (SELECT DISTINCT(COUNT(1))
                                    FROM playlisttrack PLT
                                    WHERE plt.trackid=tr.trackid); //3.505

/*7. Borra las listas que no tengan canciones.*/
SELECT * FROM playlist;
DELETE playlist WHERE playlistid NOT IN (SELECT DISTINCT(PLT.playlistid)
                                            FROM playlisttrack PLT); //4

/*8. Crea una vista con el nombre vista_total_pedidos_pais que tenga las siguientes
columnas: país del cliente, número total de pedidos hechos por clientes de ese país y
la suma de los importes de los pedidos de ese país (sumar campo total de Invoice).*/
CREATE OR REPLACE VIEW vista_total_pedidos_pais AS 
SELECT cu.country PAIS, COUNT(INV.INVOICEID) CANTIDAD_PEDIDOS, SUM(INV.TOTAL) SUMA_PEDIDOS
    FROM customer CU
    LEFT JOIN invoice INV ON inv.customerid=cu.customerid
    GROUP BY cu.country;

/*9. Crea una vista con el nombre vista_artistas_totales que tenga a todos los artistas y que
contenga los siguientes campos: id del artista, nombre del artista, total de álbumes del
artista y total canciones del artista.*/
CREATE OR REPLACE VIEW vista_artistas_totales AS 
SELECT ar.artistid ID_ART, ar.name NOMBRE_ART, COUNT(DISTINCT (al.albumid)) TOTAL_ALBUM, COUNT(DISTINCT (tr.trackid)) TOTAL_TRACK
    FROM artist AR
    LEFT JOIN album AL ON al.artistid=ar.artistid
    LEFT JOIN track TR ON tr.albumid=al.albumid
    GROUP BY ar.artistid, ar.name;

/*10. Crea un nuevo campo en la tabla de clientes que sea PEDIDOS (un carácter de 1
posición donde guardaremos S o N).*/
ALTER TABLE CUSTOMER ADD PEDIDOS VARCHAR2(1) DEFAULT 'N' NOT NULL;

/*11. Actualiza el campo anterior. Si el cliente tiene algún pedido, pondremos S, si el cliente
no tiene ningún pedido, pondremos N.*/
UPDATE customer CU SET PEDIDOS='S' 
    WHERE cu.customerid IN (SELECT DISTINCT(inv.customerid)
                                FROM invoice INV); //59
                                
SELECT * FROM CUSTOMER;




