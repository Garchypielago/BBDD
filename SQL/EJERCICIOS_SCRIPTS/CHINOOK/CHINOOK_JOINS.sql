/*1. Sacar un informe con: título de la canción, título del álbum y nombre del artista para
canciones de género POP.*/
select tr.name, al.title, ar.name
    from track tr
    inner join album al on al.albumid=tr.albumid
    inner join artist ar on ar.artistid=al.artistid
    inner join genre ge on ge.genreid=tr.genreid
    where UPPER(ge.name) like ('POP');
    
/*2. Haz una consulta que saque canciones que empiezan por T, que pertenezcan a los
géneros de blues y pop y que se hayan vendido en Enero o Junio.*/
select tr.*, inv.invoicedate
    from track tr 
    inner join genre ge on ge.genreid=tr.genreid
    inner join invoiceline inl on inl.trackid=tr.trackid
    inner join invoice inv on inv.invoiceid=inl.invoiceid
    where tr.name like 'T%' and to_char(inv.invoicedate, 'mm') in ('01', '06') AND ge.name IN ('Blues','Pop');

/*3. Nombre y género (descripción) de todas las canciones que valgan menos de 1€*/
select tr.name, ge.name, tr.unitprice
    from track tr
    inner join genre ge on ge.genreid=tr.genreid
    where tr.unitprice<1;
    
select count(1)
    from track tr
    inner join genre ge on ge.genreid=tr.genreid
    where tr.unitprice<1;

/*4. Saca los distintos álbumes para los que se han vendido canciones a clientes de Estados
Unidos.*/
select DISTINCT al.title, inv.billingcountry
    from album al
    INNER JOIN TRACK TR ON tr.albumid=al.albumid
    INNER JOIN invoiceline INL ON inl.trackid=tr.trackid
    INNER JOIN invoice INV ON inv.invoiceid=inl.invoiceid
    WHERE inv.billingcountry IN ('USA');
    
select count(distinct al.albumid)
    from album al
    INNER JOIN TRACK TR ON tr.albumid=al.albumid
    INNER JOIN invoiceline INL ON inl.trackid=tr.trackid
    INNER JOIN invoice INV ON inv.invoiceid=inl.invoiceid
    WHERE inv.billingcountry IN ('USA');

/*5. Saca los distintos clientes y artistas en los que se cumpla que el cliente ha comprado
alguna canción del artista y el nombre del cliente (firstname) empieza por la misma letra
que el nombre del artista. Ordena la consulta por nombre del cliente y luego por
nombre del artista.*/
SELECT DISTINCT CU.FIRSTNAME, ar.name
    FROM CUSTOMER CU
    INNER JOIN INVOICE INV ON inv.customerid=cu.customerid
    INNER JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    INNER JOIN TRACK TR ON tr.trackid=inl.trackid
    INNER JOIN ALBUM AL ON al.albumid=tr.albumid
    INNER JOIN ARTIST AR ON ar.artistid=al.artistid
    WHERE SUBSTR(CU.FIRSTNAME,1,1) LIKE SUBSTR(ar.name,1,1)
    ORDER BY cu.firstname, AR.NAME;

/*6. Pedidos hechos en la 2ª quincena de cada mes por clientes residentes en Alemania.*/
SELECT INV.*
    FROM INVOICE INV
    INNER JOIN CUSTOMER CU ON cu.customerid=inv.customerid
    WHERE cu.country LIKE 'Germany' AND TO_NUMBER(TO_CHAR(INV.INVOICEDATE, 'DD'))>15 ;

/*7. Lista las distintas listas que contengan alguna canción cuyo género contenga una ‘O’.*/
SELECT DISTINCT PL.NAME
    FROM playlist PL
    INNER JOIN playlisttrack PLT ON pl.playlistid=plt.playlistid
    INNER JOIN TRACK TR ON tr.trackid=plt.trackid
    INNER JOIN GENRE GE ON ge.genreid=tr.genreid
    WHERE UPPER(ge.name) LIKE '%O%';

/*8. Haz un listado con el título de cada álbum, el título de cada canción y el nombre de los
artistas. El listado debe ordenarse por nombre del artista, título del álbum y título de la
canción.*/
SELECT AL.TITLE, TR.NAME, AR.NAME
    FROM TRACK TR
    INNER JOIN ALBUM AL ON al.albumid=tr.albumid
    INNER JOIN ARTIST AR ON ar.artistid=al.artistid
    ORDER BY ar.name, al.title, tr.name;

/*9. Haz un listado con las distintas canciones que han comprado clientes que tienen cuenta
de correo en hotmail.*/
SELECT CU.FIRSTNAME, tr.name, cu.email
    FROM CUSTOMER CU
    INNER JOIN INVOICE INV ON inv.customerid=cu.customerid
    INNER JOIN invoiceline INL ON inl.invoiceid=inv.invoiceid
    INNER JOIN TRACK TR ON tr.trackid=inl.trackid
    INNER JOIN ALBUM AL ON al.albumid=tr.albumid
    INNER JOIN ARTIST AR ON ar.artistid=al.artistid
    WHERE UPPER(cu.email) LIKE '%HOTMAIL%';

/*10. Haz un listado con el nombre del artista y el país donde ha vendido canciones (elimina
duplicados). Ordena el listado por el nombre del artista.*/
SELECT DISTINCT AR.NAME, INV.BILLINGCOUNTRY
    FROM artist AR
    INNER JOIN album AL ON al.artistid=ar.artistid
    INNER JOIN TRACK TR ON tr.albumid=al.albumid
    INNER JOIN invoiceline INL ON inl.trackid=tr.trackid
    INNER JOIN invoice INV ON inv.invoiceid=inl.invoiceid
    ORDER BY ar.name;

/*11. Haz una lista de las canciones que se llaman igual al álbum al que pertenecen.*/
SELECT TR.NAME, al.title
    FROM TRACK TR
    INNER JOIN ALBUM AL ON al.albumid=tr.albumid
    WHERE tr.name LIKE al.title;

/*12. Haz un listado con el nombre del artista y el título de la canción para las canciones que
haya vendido por más de 1€ (elimina duplicados).*/
SELECT DISTINCT AR.NAME, TR.NAME
    FROM TRACK TR
    INNER JOIN ALBUM AL ON al.albumid=tr.albumid
    INNER JOIN ARTIST AR ON ar.artistid=al.artistid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    WHERE inl.unitprice>1;


/*13. Haz una lista de las canciones, eliminando duplicados, dónde la descripción del género
al que pertenece la canción está incluída en el nombre de alguna playlist en la que esté
la canción*/
SELECT DISTINCT TR.NAME--, ge.name, pl.name
    FROM TRACK TR
    INNER JOIN GENRE GE ON ge.genreid=tr.genreid
    INNER JOIN playlisttrack PLT ON plt.trackid=tr.trackid
    INNER JOIN playlist PL ON pl.playlistid=plt.playlistid
    WHERE INSTR(UPPER(PL.NAME), UPPER(GE.NAME))>0;