/*1. Devuelve el total de canciones que no se han vendido ninguna vez.*/
SELECT COUNT (1)
 FROM TRACK TR
 WHERE TR.trackid NOT IN (SELECT INL.TRACKID
                            FROM invoiceline INL);

/*2. Devuelve el total de artistas que no han vendido ninguna canción*/
SELECT COUNT(AR2.ARTISTID)
FROM artist AR2
WHERE ar2.artistid NOT IN (SELECT DISTINCT ar.artistid
                            FROM ARTIST AR
                            JOIN ALBUM AL ON al.artistid=ar.artistid
                            JOIN TRACK TR ON tr.albumid=al.albumid
                            JOIN invoiceline INL ON inl.trackid=tr.trackid);

/*3. (difícil) Haz una consulta que saque para todos los artistas: su nombre, el nombre de la
canción más larga, el álbum al que pertenece la canción más larga, el total de canciones que
han vendido y el total de veces que han vendido la canción más larga.*/
SELECT ar.name, 
        (SELECT tr3.name
            FROM TRACK TR3
            JOIN ALBUM AL3 ON al3.albumid=tr3.albumid
            WHERE tr3.milliseconds=LARGA.DURACION AND aL3.artistid=ar.artistid) C_LARGA,
        (SELECT al4.title
            FROM TRACK TR4
            JOIN ALBUM AL4 ON al4.albumid=tr4.albumid
            WHERE tr4.milliseconds=LARGA.DURACION AND aL4.artistid=ar.artistid) A_LARGA,
        (SELECT COUNT(inl5.quantity)
            FROM TRACK TR5
            JOIN ALBUM AL5 ON al5.albumid=tr5.albumid
            JOIN INVOICELINE INL5 ON inl5.trackid=tr5.trackid
            WHERE tr5.milliseconds=LARGA.DURACION AND aL5.artistid=ar.artistid) VENDIDO_LARGA,
        (SELECT COUNT(inl6.quantity)
            FROM TRACK TR6
            JOIN ALBUM AL6 ON al6.albumid=tr6.albumid
            JOIN INVOICELINE INL6 ON inl6.trackid=tr6.trackid
            WHERE aL6.artistid=ar.artistid) VENDIDO_TOTAL
            
    FROM ARTIST AR
    JOIN (SELECT AR2.ARTISTID ID, MAX(tr2.milliseconds) DURACION
            FROM ARTIST AR2
            JOIN ALBUM AL2 ON al2.artistid=ar2.artistid
            JOIN TRACK TR2 ON tr2.albumid=al2.albumid
            GROUP BY AR2.ARTISTID) LARGA
        ON LARGA.id=ar.artistid;
    
    
/*4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.*/
SELECT pl.name, (SELECT COUNT (DISTINCT AR.ARTISTID)
                    FROM artist AR
                    JOIN album AL ON al.artistid=ar.artistid
                    JOIN TRACK TR ON tr.albumid=al.albumid
                    JOIN playlisttrack PLT ON plt.trackid=tr.trackid
                    WHERE plt.playlistid=pl.playlistid
                    ) nºARTISTAS
    FROM PLAYLIST PL;

/*5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
de ese género.*/
SELECT ge.name, CANCIONES.CONTEO_CANCIONES, LISTAS.CONTEO_LISTAS
    FROM GENRE GE
    JOIN (SELECT GE2.GENREID ID ,COUNT(1) CONTEO_CANCIONES
            FROM TRACK TR 
            JOIN genre GE2 ON ge2.genreid=tr.genreid
            GROUP BY GE2.GENREID) CANCIONES
        ON CANCIONES.id=ge.genreid
    JOIN (SELECT GE3.GENREID ID ,COUNT(DISTINCT plt.playlistid) CONTEO_LISTAS
            FROM playlisttrack PLT
            JOIN TRACK TR2 ON  tr2.trackid=plt.trackid
            JOIN genre GE3 ON ge3.genreid=tr2.genreid
            GROUP BY GE3.GENREID) LISTAS
        ON LISTAS.id = ge.genreid;

/*6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
estos clientes //para todos los clientes que han comprado canciones que pertenezcan a los
mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.*/
SELECT DISTINCT cu.firstname, cu.customerid, cu.countrY ,(SELECT COUNT(DISTINCT INV3.INVOICEID)
                                                            FROM INVOICE INV3
                                                            JOIN CUSTOMER CU3 ON CU3.CUSTOMERID=INV3.CUSTOMERID
                                                            WHERE CU3.CUSTOMERID=CU.CUSTOMERID) CONTEO
    FROM CUSTOMER CU
    JOIN INVOICE INV ON inv.customerid=cu.customerid
    JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    JOIN TRACK TR ON tr.trackid=inl.trackid
    JOIN ALBUM AL ON al.albumid=tr.albumid
    WHERE al.albumid IN (SELECT al2.albumid
                            FROM INVOICE INV2
                            JOIN invoiceline INL2 ON inl2.invoiceid=inv2.invoiceid
                            JOIN TRACK TR2 ON tr2.trackid=inl2.trackid
                            JOIN ALBUM AL2 ON al2.albumid=tr2.albumid
                            JOIN customer CU2 ON cu2.customerid=inv2.customerid
                            WHERE cu2.country LIKE 'Spain'); 
                            
                            
SELECT DISTINCT cu.firstname, cu.customerid, cu.countrY, CONTEO.conteo
    FROM CUSTOMER CU
    JOIN INVOICE INV ON inv.customerid=cu.customerid
    JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    JOIN TRACK TR ON tr.trackid=inl.trackid
    JOIN ALBUM AL ON al.albumid=tr.albumid
    JOIN (SELECT CU3.CUSTOMERID ID, COUNT(DISTINCT INV3.INVOICEID) CONTEO
                FROM INVOICE INV3
                JOIN CUSTOMER CU3 ON CU3.CUSTOMERID=INV3.CUSTOMERID
                GROUP BY CU3.CUSTOMERID) CONTEO
            ON CONTEO.id=cu.customerid
    WHERE al.albumid IN (SELECT al2.albumid
                            FROM INVOICE INV2
                            JOIN invoiceline INL2 ON inl2.invoiceid=inv2.invoiceid
                            JOIN TRACK TR2 ON tr2.trackid=inl2.trackid
                            JOIN ALBUM AL2 ON al2.albumid=tr2.albumid
                            JOIN customer CU2 ON cu2.customerid=inv2.customerid
                            WHERE cu2.country LIKE 'Spain'); 
    

/*7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
cuantas playlist hay canciones de ese álbum.*/
SELECT ar.name, al.title, 
        (SELECT COUNT(DISTINCT TR2.TRACKID)
            FROM track tr2
            where tr2.albumid=al.albumid) nºCANCIONES,
        (SELECT COUNT(DISTINCT plt.playlistid)
            FROM playlisttrack PLT
            JOIN TRACK TR3 ON tr3.trackid=plt.trackid
            where tr3.albumid=al.albumid) nºPLAYLIST
    FROM ARTIST AR
    JOIN album AL ON al.artistid=ar.artistid
    ORDER BY 1, 2;

/*MUY DIFICILES*/
/*8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
álbum.*/
SELECT AR.NAME NOMBRE, TABLA.ALNAME ALBUM
        ,CASE WHEN (SELECT COUNT(1)
                        FROM invoiceline INL
                        JOIN TRACK TR4 ON tr4.trackid=inl.trackid
                        JOIN ALBUM AL4 ON al4.albumid=tr4.albumid
                        WHERE al4.albumid=TABLA.alid)>0
            THEN 'SI' ELSE 'NO' END HA_VENDIDO
    FROM ARTIST AR
    JOIN (SELECT al2.artistid ARID, al2.title ALNAME, AL2.ALBUMID ALID, SUM(TR2.MILLISECONDS)DURACION
            FROM album AL2
            JOIN track TR2 ON tr2.albumid=al2.albumid
            GROUP BY al2.artistid, al2.title, AL2.ALBUMID
            HAVING SUM(TR2.MILLISECONDS) = (SELECT MAX(SUM(TR3.MILLISECONDS))MAXSUM
                                                FROM TRACK TR3
                                                JOIN ALBUM AL3 ON AL3.ALBUMID=TR3.ALBUMID
                                                WHERE AL2.ARTISTID=AL3.ARTISTID
                                                GROUP BY tr3.albumid)) TABLA
            ON TABLA.aRID=ar.artistid
    ORDER BY 1;
            
/*9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
álbum y número de canciones totales que tiene la lista.*/
SELECT pl.name PL_NOMBRE, ALB.alname AL_NOMBRE, ALB.alconteo nºCAN_AL,
        (SELECT COUNT(1)
            FROM playlisttrack PLT2
            WHERE plt2.playlistid = pl.playlistid) nºCAN_PL
    FROM playlist PL
    JOIN playlisttrack PLT ON plt.playlistid=pl.playlistid
    JOIN TRACK TR ON tr.trackid=plt.trackid
    JOIN (SELECT AL2.TITLE ALNAME ,AL2.ALBUMID ALID, COUNT(TR2.TRACKID) ALCONTEO
                            FROM album AL2
                            JOIN TRACK TR2 ON tr2.albumid=al2.albumid
                            GROUP BY al2.albumid, AL2.TITLE
                            HAVING COUNT(TR2.TRACKID)>10) ALB
            ON ALB.alid=tr.trackid
    WHERE ALB.ALID IN (SELECT al3.albumid
                            FROM ALBUM AL3
                            JOIN TRACK TR3 ON tr3.albumid=al3.albumid
                            JOIN playlisttrack PLT3 ON plt3.trackid=tr3.trackid
                            WHERE al3.albumid=ALB.ALID 
                            AND plt3.playlistid = pl.playlistid
                            AND tr3.trackid IN (SELECT plt4.trackid
                                                    FROM playlisttrack PLT4))
    ORDER BY 1, 2;

/*10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.*/
SELECT DISTINCT (ar.name) , ar.artistid, XAL2.titulo, XAL2.maxi
    FROM ARTIST AR
    JOIN (SELECT AL2.TITLE TITULO, MAX(XAL.SUMAS) MAXI, al2.artistid IDA
                FROM ALBUM AL2
                JOIN (SELECT tr3.albumid ID ,SUM(INL3.QUANTITY*INL3.UNITPRICE) SUMAS
                            FROM TRACK TR3
                            JOIN invoiceline INL3 ON tr3.trackid=inl3.trackid
                            GROUP BY tr3.albumid) XAL
                        ON XAL.ID = al2.albumid
                        GROUP BY AL2.TITLE, al2.artistid) XAL2
            ON ar.artistid= XAL2.idA
    ORDER BY 1;
            
            