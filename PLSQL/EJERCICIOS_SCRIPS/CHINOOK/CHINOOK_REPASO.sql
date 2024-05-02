SET SERVEROUTPUT ON;
/*1. Haz un procedimiento que reciba un artista y vaya listando todos los álbumes y por
cada álbum todas sus canciones.*/
CREATE OR REPLACE PROCEDURE P_ALBUMS_CANCIONES
    (ARTID ARTIST.ARTISTID%TYPE) IS
    
    CURSOR ALB (ARTID ARTIST.ARTISTID%TYPE) IS
        (SELECT AL.TITLE NOM, AL.albumid ID
            FROM ALBUM AL
            WHERE AL.artistid = ARTID);
    
    CURSOR TRA (ALBID ALBUM.ALBUMID%TYPE) IS
        (SELECT TR.name NOM
            FROM TRACK TR
            WHERE TR.albumid = ALBID);
    
    E_NULO EXCEPTION;
BEGIN
    IF (ARTID IS NULL) THEN
        RAISE E_NULO;
    END IF;
    
    FOR I IN ALB(ARTID) LOOP
        DBMS_OUTPUT.PUT_LINE('-ALBUM: '||I.NOM);
        FOR J IN TRA(I.ID) LOOP
            DBMS_OUTPUT.PUT_LINE('  -TRACK: '||J.NOM);
        END LOOP;
    END LOOP; 
EXCEPTION
    WHEN E_NULO THEN
        RAISE_APPLICATION_ERROR(-20010, 'ERROR: ENTRADA NULA');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

SELECT * FROM ARTIST;
CALL p_albums_canciones(260);

/*2. Haz una función que reciba una lista y devuelva el total de canciones que tiene la
lista.*/
CREATE OR REPLACE FUNCTION F_CONT_TRACK
    (V_PLIST PLAYLIST.PLAYLISTID%TYPE) 
    RETURN NUMBER IS 
    V_CONTEO NUMBER:=0;
    
    E_NULO EXCEPTION;
BEGIN
    IF V_PLIST IS NULL THEN
        RAISE E_NULO;
    END IF;
    
    SELECT COUNT(1)
    INTO V_CONTEO
        FROM playlisttrack PLT
        WHERE PLT.playlistid = V_PLIST;
    
    RETURN V_CONTEO;
EXCEPTION
    WHEN E_NULO THEN
        RAISE_APPLICATION_ERROR(-20010, 'ERROR: ENTRADA NULA');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN -1;
END;

SELECT PL.NAME, f_cont_track(PL.PLAYLISTID) FROM playlist PL;

/*3. Haz un procedimiento que recorra las listas y vaya pintando un informe con nombre
de la lista y total de canciones de la lista. Debe utilizar la función del punto anterior.*/
CREATE OR REPLACE PROCEDURE P_LISTA_NOM_CONT IS
    CURSOR LISTA IS (SELECT PL.name NOM, PL.playlistid ID
                        FROM playlist PL);
BEGIN
    FOR I IN LISTA LOOP
        DBMS_OUTPUT.PUT_LINE(I.NOM||'  -> '|| f_cont_track(I.ID));
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CALL p_lista_nom_cont();

/*4. Crea un tabla llamada Mejor_cliente_ciudad que debe tener, al menos, los
siguientes campos
    a. Ciudad
    b. Cliente
    c. Importe
Crea un procedimiento que rellene esta tabla con el mejor cliente de cada ciudad. Se
entiende que el mejor cliente será aquel cuya suma de sus facturas (la suma del
campo total de invoice) sea mayor.
En caso de que para una ciudad haya dos clientes con el mismo importe, meteremos
el más antiguo (código de cliente menor).*/
CREATE TABLE MEJOR_CLIENTE(
CUSTOMERID NUMBER(10) NOT NULL,
CITY VARCHAR2(50) NOT NULL,
IMPORTE NUMBER(10,2),
CONSTRAINT F_CUS_ID
FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMER(CUSTOMERID),
PRIMARY KEY (CUSTOMERID)
);

DROP TABLE MEJOR_CLIENTE;

CREATE OR REPLACE PROCEDURE P_MEJOR_CLIENTE_CIUDAD IS
    CURSOR CIUDAD IS (SELECT DISTINCT(CU.CITY) NOM
                        FROM CUSTOMER CU);
    V_CLIENTE CUSTOMER.CUSTOMERID%TYPE;
    V_IMPORTE NUMBER(10,2);
BEGIN
    DELETE FROM MEJOR_CLIENTE;

    FOR I IN CIUDAD LOOP
        SELECT * 
        INTO V_CLIENTE, V_IMPORTE 
            FROM ( SELECT CU.customerid ID, SUM(inv.total) TOTAL
                        FROM CUSTOMER CU
                        JOIN invoice INV ON inv.customerid = cu.customerid
                        WHERE CU.CITY = I.NOM
                        GROUP BY  CU.customerid
                        ORDER BY 2 DESC,1 ASC) TABLA
            WHERE ROWNUM=1;
        INSERT INTO MEJOR_CLIENTE VALUES (V_CLIENTE, I.NOM, V_IMPORTE);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CALL p_mejor_cliente_ciudad();
SELECT * FROM MEJOR_CLIENTE;

/*5. Crea un campo en la tabla employees de fecha de despido (firedate) que admite
nulos y que se rellenará cuando se despide a un empleado con la fecha de despido.
Crea un trigger en esta tabla sobre este campo. Si se despide a un empleado y este
tiene asociados clientes, no puede ser despedido y debe dar error.*/
ALTER TABLE EMPLOYEE ADD firedate DATE;

CREATE OR REPLACE TRIGGER T_DESPIDO
    before UPDATE OF FIREDATE ON EMPLOYEE
    FOR EACH ROW
DECLARE
    E_CLIENTES EXCEPTION;
    V_CLIENTE NUMBER;
BEGIN
    SELECT COUNT(1)
    INTO V_CLIENTE
        FROM CUSTOMER CU
        WHERE cu.supportrepid = :OLD.EMPLOYEEID;
    
    IF (V_CLIENTE >0) THEN
        RAISE E_CLIENTES;
    END IF;
EXCEPTION
    WHEN E_CLIENTES THEN
        RAISE_APPLICATION_ERROR(-20008, 'ERROR: EMPLEADOC ON CLINETES A CARGO');
        RETURN;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;

select *  from customer;

update employee set firedate = sysdate where employeeid = 3;

/*6. Haz un procedimiento o bloque anónimo que me vaya mostrando todas las listas y
por cada lista, las 3 canciones más largas.*/
create or replace procedure P_TRACKS_LARGAS IS
    
    CURSOR LISTAS IS (SELECT PLS.NAME NOM, PLS.PLAYLISTID ID FROM playlist PLS);
    
    CURSOR CANCIONES (PLTID PLAYLIST.PLAYLISTID%TYPE) IS 
            SELECT TR.NAME NOM, tr.milliseconds DUR
                FROM TRACK TR
                JOIN playlisttrack PLT ON plt.trackid = tr.trackid
                WHERE plt.playlistid = PLTID
                ORDER BY 2 DESC;
    V_CONTADOR NUMBER := 0;
BEGIN
    FOR I IN LISTAS LOOP
    DBMS_OUTPUT.PUT_LINE('-lISTA: '||I.NOM);
    V_CONTADOR := 0;
        FOR J IN CANCIONES(I.ID) LOOP
            DBMS_OUTPUT.PUT_LINE('  -CANCION: '||J.NOM);
            v_contador := v_contador + 1;
            IF(V_CONTADOR = 3) THEN
                EXIT;
            END IF;
        END LOOP;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CALL p_tracks_largas();
/*7. Crea una función que reciba una canción y devuelva el número de veces que se ha
vendido la canción.*/
CREATE OR REPLACE FUNCTION F_VENDIDO
    (V_TID TRACK.TRACKID%TYPE) RETURN
    NUMBER IS
    
    V_VENDIDO NUMBER;
    
    E_NULO EXCEPTION;
BEGIN
    IF V_TID IS NULL THEN 
        RAISE E_NULO;
    END IF;
    
    SELECT NVL(SUM(inv.quantity), 0) CONT
    INTO V_VENDIDO
        FROM invoiceline INV
        WHERE inv.trackid = V_TID;
        
    RETURN V_VENDIDO;

EXCEPTION
    WHEN E_NULO THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: INSERCION NULA');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN -1;
END;

SELECT TR.TRACKID, f_vendido(TR.TRACKID) FROM TRACK TR ORDER BY 2 DESC;

/*8. Crea un campo en la tabla de TRACK llamado “num_ventas” cuyo valor defecto será
un 0. Crea un procedimiento que “rellene” este campo con el número de veces que
se ha vendido cada canción. Debes utilizar la función anterior.*/
ALTER TABLE TRACK ADD NUM_VENTAS NUMBER(10);
ALTER TABLE TRACK MODIFY NUM_VENTAS NUMBER(10) DEFAULT 0;
UPDATE TRACK TR SET NUM_VENTAS = 0;

CREATE OR REPLACE PROCEDURE P_RELLENAR_VENTA IS
    
    CURSOR CANCIONES IS (SELECT TR.TRACKID ID
                            FROM TRACK TR
                            JOIN INVOICELINE INL ON tr.trackid=inl.trackid);
BEGIN
    FOR I IN CANCIONES LOOP
        UPDATE TRACK TR SET NUM_VENTAS = f_vendido(I.ID) WHERE TR.TRACKID = I.ID;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

SELECT * FROM TRACK TR ORDER BY tr.num_ventas DESC;
CALL p_rellenar_venta();

/*9. Crea un trigger que cada vez que se inserta un registro en invoiceline, actualice el
campo “num_ventas” de la canción que se ha vendido.*/
CREATE OR REPLACE TRIGGER T_INV_ACTUALIZARVENTAS
    AFTER INSERT ON INVOICELINE
    FOR EACH ROW
BEGIN
    UPDATE TRACK TR SET NUM_VENTAS = f_vendido(:NEW.TRACKID) WHERE TR.TRACKID = :NEW.TRACKID;
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/*10. Crea un procedimiento que me haga un listado de los artistas y las 3 canciones más
vendidas de cada artista. Utiliza el campo creado en los ejercicios anteriores.*/
CREATE OR REPLACE PROCEDURE P_ART_MASVENDIDAS IS

    CURSOR ART IS (SELECT AR.NAME NOM, AR.ARTISTID ID
                        FROM ARTIST AR);
                        
    CURSOR TRACK (V_ARTID ARTIST.ARTISTID%TYPE) IS 
        SELECT TR.NAME NOM, tr.num_ventas VEN
            FROM TRACK TR 
            JOIN ALBUM AL ON al.albumid = tr.albumid
            WHERE al.artistid = V_ARTID
            ORDER BY 2;   
            
    V_CONTADOR NUMBER := 0;
BEGIN
    FOR I IN ART LOOP
    DBMS_OUTPUT.PUT_LINE('-ARTISTA: '||I.NOM);
    V_CONTADOR := 0;
        FOR J IN TRACK(I.ID) LOOP
            DBMS_OUTPUT.PUT_LINE('  -CANCION: '||J.NOM);
            v_contador := v_contador + 1;
            IF(V_CONTADOR = 3) THEN
                EXIT;
            END IF;
        END LOOP;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CALL p_art_masvendidas();











