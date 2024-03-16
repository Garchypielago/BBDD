/*1. Haz una consulta que saque las listas de música que hayan vendido canciones por más de
500€.*/
SELECT pl.name, SUM(INL.QUANTITY*INL.UNITPRICE)
    FROM playlist PL
    JOIN playlisttrack PLT ON pl.playlistid=plt.playlistid
    JOIN TRACK TR ON tr.trackid=plt.trackid
    JOIN invoiceline INL ON tr.trackid=inl.trackid
    GROUP BY pl.name
    HAVING SUM(INL.QUANTITY*INL.UNITPRICE)>500;
    

/*2. Para los países en los que se han pedido más de 50 canciones distintas, nombre del país,
total de canciones distintas que se han pedido y la fecha del último pedido.*/
SELECT inv.billingcountry, COUNT(DISTINCT INL.TRACKID), MAX(INV.INVOICEDATE)
    FROM INVOICE INV
    JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    GROUP BY inv.billingcountry
    HAVING COUNT(DISTINCT INL.TRACKID)>50;


/*3. Para todos los artistas con más de 30 canciones queremos ver su nombre, el número de
canciones que tenemos y la media de duración de sus canciones (redondeada a 1 decimal).*/
SELECT ar.name, ROUND(AVG(tr.milliseconds/1000/60),1),COUNT(tr.trackid) //tabla de cruce 1 a n, pero podria ser n a m[distitnc]
    FROM ARTIST AR
    JOIN ALBUM AL ON al.artistid=ar.artistid
    JOIN track TR ON tr.albumid=al.albumid
    GROUP BY ar.name
    HAVING COUNT(TR.TRACKID)>30;


/*4. Cuenta el nº de canciones que tiene la lista de nombre: 'Grunge'.*/
SELECT COUNT(1)
    FROM TRACK TR
    JOIN playlisttrack PLT ON plt.trackid=tr.trackid
    JOIN playlist PL ON pl.playlistid=plt.playlistid
    WHERE pl.name LIKE 'Grunge';


/*5. Informe de las listas (nombre) con menos de 30 canciones y el número de canciones que
tienen.*/
SELECT pl.name, COUNT(plt.trackid)
    FROM playlisttrack PLT
    JOIN playlist PL ON pl.playlistid=plt.playlistid
    GROUP BY pl.NAME
    HAVING COUNT(PLT.TRACKID)<30;


/*6. Queremos un informe que por país y ciudad me diga el gasto que se ha hecho en pedidos
(cantidad x coste unitario) y el número de pedidos que se han hecho. Sólo para ciudades
que hayan gastado más de 38€.Ordena la consulta por gasto de mayor a menor, luego por país 
y luego por ciudad.*/
SELECT inv.billingcity, inv.billingcountry, SUM(INL.UNITPRICE*INL.QUANTITY),  COUNT(distinct inv.invoiceid)/*distinct por que se estan haciendo cartesiano con cada producto*/
    FROM INVOICE INV
    JOIN invoiceline INL ON inv.invoiceid=inl.invoiceid
    GROUP BY inv.billingcity, inv.billingcountry
    HAVING SUM(INL.UNITPRICE*INL.QUANTITY)>38
    ORDER BY SUM(INL.UNITPRICE*INL.QUANTITY) DESC, inv.billingcountry DESC, inv.billingcity DESC;
    
SELECT inv.billingcity, inv.billingcountry, sum(inv.total),  COUNT(inv.invoiceid)
    FROM INVOICE INV
    GROUP BY inv.billingcity, inv.billingcountry
    HAVING SUM(total)>38
    ORDER BY SUM(inv.total) DESC, inv.billingcountry DESC, inv.billingcity DESC;
    

/*7. Saca un informe con la descripción de los géneros y el número de artistas que tienen
canciones en cada género.*/
SELECT ge.name, COUNT(DISTINCT ar.artistid)
    FROM GENRE GE
    JOIN TRACK TR ON tr.genreid=ge.genreid
    JOIN ALBUM AL ON al.albumid=tr.albumid
    JOIN ARTIST AR ON ar.artistid=al.artistid
    GROUP BY ge.name
    order by 1;
    


/*8. Para el género de Rock dime los artistas que tienen 40 o más canciones. Ordena la
consulta por el número de canciones.*/
SELECT ar.name, COUNT(TR.TRACKID)
    FROM GENRE GE
    JOIN TRACK TR ON tr.genreid=ge.genreid
    JOIN ALBUM AL ON al.albumid=tr.albumid
    JOIN ARTIST AR ON ar.artistid=al.artistid
    WHERE ge.name LIKE 'Rock'
    GROUP BY ar.name
    HAVING COUNT(TR.TRACKID)>=40
    ORDER BY  COUNT(TR.TRACKID) DESC;


/*9. Saca las listas de música y su duración en minutos.*/
SELECT pl.name, ROUND(SUM(tr.milliseconds/1000/60),2)
    FROM playlist PL
    JOIN playlisttrack PLT ON plt.playlistid = pl.playlistid
    JOIN TRACK TR ON tr.trackid=plt.trackid
    GROUP BY pl.name;
    
    
/*10. Saca un listado con los artistas cuyo nombre contenga la secuencia de letras “AC” (en
mayúsculas y minúsculas) y aquellos discos de estos artistas cuyo precio sea superior a
10€ (suponemos que el precio de un álbum es la suma del precio de todas sus canciones).*/
SELECT ar.name, al.title, SUM(TR.UNITPRICE)
    FROM ARTIST AR
    JOIN ALBUM AL ON al.artistid=ar.artistid
    JOIN TRACK TR ON tr.albumid=al.albumid
    WHERE UPPER(AR.NAME) LIKE '%AC%'
    GROUP BY al.title, ar.name
    HAVING SUM(TR.UNITPRICE)>10;
    


/*11. Devuelve el total de clientes que han comprado canciones de AC/DC.*/
SELECT count(DISTINCT cu.customerid )
    FROM customer CU 
    JOIN invoice INV ON inv.customerid=cu.customerid
    JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    JOIN TRACK TR ON tr.trackid=inl.trackid
    JOIN album AL ON al.albumid=tr.albumid
    JOIN artist AR ON ar.artistid=al.artistid
    WHERE ar.name LIKE 'AC/DC'
    --GROUP BY cu.customerid
    ;

/*12. ¿Cual es el artista que más canciones ha vendido?*/
SELECT * FROM (SELECT ar.name, SUM(inl.quantity)
                    FROM ARTIST AR 
                    JOIN ALBUM AL ON al.artistid=ar.artistid
                    JOIN TRACK TR ON tr.albumid=al.albumid
                    JOIN invoiceline INL ON inl.trackid=tr.trackid
                    GROUP BY ar.name
                    ORDER BY 2 DESC)
    WHERE ROWNUM<2;
    
SELECT ar.name, SUM(inl.quantity)
    FROM ARTIST AR 
    JOIN ALBUM AL ON al.artistid=ar.artistid
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY ar.name
    HAVING SUM(inl.quantity) = (SELECT MAX(SUM(inl.quantity))
    FROM ARTIST AR 
    JOIN ALBUM AL ON al.artistid=ar.artistid
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY ar.name);


/*13. ¿Y el disco que más dinero ha recaudado?*/
SELECT AL.TITLE, SUM(inl.quantity*INL.UNITPRICE)
    FROM ALBUM AL 
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY AL.TITLE
    ORDER BY 2 DESC;
    
SELECT AL.TITLE, SUM(inl.quantity*INL.UNITPRICE)
    FROM ALBUM AL 
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY AL.TITLE
    HAVING SUM(inl.quantity*INL.UNITPRICE)=(SELECT MAX(SUM(inl.quantity*INL.UNITPRICE))
    FROM ALBUM AL 
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY AL.TITLE);


/*14. Cuál es el principio (3 primeras letras) más repetido en el título de las canciones y cuantas
veces se repite. ¿Y con 5 letras?*/
SELECT SUBSTR(tr.name,1,3), COUNT(SUBSTR(tr.name,1,3))
    FROM TRACK TR
    GROUP BY SUBSTR(tr.name,1,3)
    HAVING COUNT(SUBSTR(tr.name,1,3))=(SELECT MAX(COUNT(SUBSTR(tr.name,1,3)))
    FROM TRACK TR
    GROUP BY SUBSTR(tr.name,1,3)
    );
    
SELECT SUBSTR(tr.name,1,5), COUNT(SUBSTR(tr.name,1,5))
    FROM TRACK TR
    GROUP BY SUBSTR(tr.name,1,5)
    HAVING COUNT(SUBSTR(tr.name,1,5))=(SELECT MAX(COUNT(SUBSTR(tr.name,1,5)))
    FROM TRACK TR
    GROUP BY SUBSTR(tr.name,1,5)
    );
    


/*15. Saca el nombre de las listas de música en las que todas las canciones son del mismo
género.*/
SELECT pl.name, count(distinct ge.genreid)
    FROM playlist PL 
    JOIN playlisttrack PLT ON plt.playlistid=pl.playlistid
    JOIN TRACK TR ON tr.trackid=plt.trackid
    JOIN GENRE GE ON ge.genreid =tr.genreid
    GROUP BY pl.name
    HAVING count(distinct ge.genreid)=1;
    
select distinct pl2.name, ge2.name 
    from playlist pl2
    join playlisttrack plt2 on plt2.playlistid=pl2.playlistid
    join track tr2 on tr2.trackid=plt2.trackid
    join genre ge2 on ge2.genreid=tr2.genreid
    join (select pl.playlistid lista
                from playlist pl
                join playlisttrack plt on plt.playlistid=pl.playlistid
                join track tr on tr.trackid=plt.trackid
                join genre ge on ge.genreid=tr.genreid
                group by pl.playlistid
                having count(DISTINCT ge.genreid)=1) tabla
            on tabla.lista = pl2.playlistid;
    