/*1. Saca los distintos �lbumes para los que se han vendido canciones tanto a clientes de Estados
Unidos como a clientes que no son de Estados Unidos.*/
SELECT DISTINCT (al.title), 'USA' PAIS
    FROM ALBUM AL
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    JOIN invoice INV ON inv.invoiceid=inl.invoiceid
    JOIN customer CU ON cu.customerid=inv.customerid
    WHERE cu.country LIKE 'USA'
UNION
SELECT DISTINCT (al.title), 'NO USA' PAIS
    FROM ALBUM AL
    JOIN TRACK TR ON tr.albumid=al.albumid
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    JOIN invoice INV ON inv.invoiceid=inl.invoiceid
    JOIN customer CU ON cu.customerid=inv.customerid
    WHERE cu.country NOT LIKE 'USA'
ORDER BY 1;

/*2. Queremos una lista de todos los artistas (nombre) y si tienen �lbumes, de los t�tulos de estos
�lbumes.*/
SELECT ar.name, al.title
    FROM ARTIST AR
    LEFT JOIN ALBUM AL ON ar.artistid=al.artistid
    ORDER BY 1;

/*3. Queremos un informe con el nombre de las canciones, ordenado alfab�ticamente y un
contador con la siguiente l�gica: si la canci�n tiene pedidos, el n�mero de pedidos en el que
est� la canci�n. Si no ha tenido pedidos, el n�mero de listas de reproducci�n en el que est�.*/
SELECT DISTINCT tr.trackid ,tr.name, COUNT(inl.quantity)NUMERO, 'PEDIDOS' PEoLI
    FROM TRACK TR
    JOIN invoiceline INL ON inl.trackid=tr.trackid
    GROUP BY tr.trackid,TR.NAME
UNION ALL
SELECT DISTINCT tr.trackid, tr.name, COUNT(plt.playlistid) NUMERO, 'LISTAS' PEoLI
    FROM TRACK TR
    LEFT JOIN invoiceline INL ON inl.trackid=tr.trackid
    LEFT JOIN playlisttrack PLT ON plt.trackid=tr.trackid
    WHERE inl.quantity IS NULL
    GROUP BY tr.trackid,TR.NAME
ORDER BY 2;


/*4. Queremos un informe con el nombre de TODAS las listas y los g�neros que est�n inclu�dos
en esas listas en caso de que la lista tenga canciones.*/
SELECT  DISTINCT pl.name, ge.name
    FROM playlist PL
    LEFT JOIN playlisttrack PLT ON plt.playlistid=pl.playlistid
    LEFT JOIN TRACK TR ON tr.trackid=plt.trackid
    LEFT JOIN GENRE GE ON ge.genreid=tr.genreid
    ORDER BY pl.name;

/*5. Consulta 2 ( queremos una lista de todos los artistas (nombre) y si tienen �lbumes, de los
t�tulos de estos �lbumes) pero que el nombre del artista empiece por A.*/
SELECT ar.name, al.title
    FROM ARTIST AR
    LEFT JOIN ALBUM AL ON ar.artistid=al.artistid
    WHERE UPPER(SUBSTR(AR.NAME,1,1)) LIKE 'A';

/*6.Consulta 2 ( queremos una lista de todos los artistas (nombre) y si tienen �lbumes, de los
t�tulos de estos �lbumes) pero que el t�tulo del �lbum empiece por A.*/
SELECT DISTINCT ar.name, alB.title
    FROM ARTIST AR
    LEFT JOIN (SELECT al.artistid, al.title
                    FROM album AL
                    WHERE UPPER(SUBSTR(AL.TITLE,1,1)) LIKE 'A') ALB
                ON ALB.artistid=ar.artistid
    ORDER BY 1;

/*7. Queremos ver artistas que no tienen ninguna canci�n en las listas y listas que no tienen
ning�n artista*/
SELECT DISTINCT AR.NAME ARTISTA, pl.name PLAYLIST
    FROM ARTIST AR
    FULL OUTER JOIN album AL ON al.artistid=ar.artistid
    FULL OUTER JOIN TRACK TR ON tr.albumid=al.albumid
    FULL OUTER JOIN playlisttrack PLT ON plt.trackid=tr.trackid
    FULL OUTER JOIN playlist PL ON plt.playlistid=pl.playlistid
    WHERE pl.playlistid IS NULL
        OR ar.artistid IS NULL
    ORDER BY 1;
    
    
    
    
    
    
    