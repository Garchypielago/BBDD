SET SERVEROUTPUT ON;
/*1. Crear un bloque PL que recorra un cursor con todos los clientes que vivan en España y
pinte el nombre del cliente, su teléfono y su ciudad.*/
SELECT * FROM CLIENTE;

DECLARE 
    CURSOR ESPA IS (SELECT CL.nombrecliente NOM, CL.telefono TEL, CL.ciudad CIU
                        FROM cliente CL
                        WHERE CL.pais = 'Spain');
BEGIN
    FOR I IN ESPA LOOP
        DBMS_OUTPUT.PUT_LINE(I.NOM||' - '||I.TEL||' - '||I.CIU);
    END LOOP;
END;

/*2. Crear un bloque PL que le pida al usuario un precio para que introduzca por teclado y
haga un cursor con todos los productos que valgan (precio venta) menos del precio
introducido. Sacar nombre del producto, precio de venta y dimensiones.*/
SELECT * FROM producto;

DECLARE 
    CURSOR PRO IS 
        (SELECT PR.nombre NOM, PR.precioventa PV, NVL(PR.dimensiones, 'NO DISPONIBLE') DIM
            FROM producto PR
            WHERE PR.precioventa<=&PRECIO);
BEGIN
    FOR I IN PRO LOOP
        DBMS_OUTPUT.PUT_LINE(I.NOM||' - '||I.PV||'€, Dimensiones: '||I.DIM);
    END LOOP;

END;

/*3. Escribir un bloque PL que reciba una cadena y visualice el apellido y el código de
empleado de todos los empleados cuyo apellido contenga la cadena especificada. Al
finalizar se visualizará el número de empleados mostrados.*/
SELECT * FROM empleado;

DECLARE 

    V_LETRAS VARCHAR2(15):=&LETRAS;

    CURSOR EMP IS (SELECT EM.apellido1 APE1, NVL(EM.apellido2, '-') APE2, EM.codempleado COD
                    FROM empleado EM
                    WHERE INSTR( UPPER(EM.APELLIDO1) ,UPPER(V_LETRAS))>0
                    OR INSTR( UPPER(EM.APELLIDO2) ,UPPER(V_LETRAS))>0
                    ) ORDER BY 1;
    V_CONT NUMBER:=0;
BEGIN
    FOR I IN EMP LOOP
        DBMS_OUTPUT.PUT_LINE(I.COD||' - '||I.APE1||', '||I.APE2);
        V_CONT:=V_CONT+1;
    END LOOP;
        DBMS_OUTPUT.PUT_LINE('TOTAL: '||V_CONT);
        --DBMS_OUTPUT.PUT_LINE('TOTAL2: '||EMP%ROWCOUNT);
END;

/*4. Crear un bloque PL que le pida al usuario un código de empleado y recorra los clientes
asociados a ese código de empleado. Por cada cliente contará el número de pedidos y
en función de estos le aumentará el límite de crédito.
    1. Si el cliente tiene entre 1 y 5 pedidos: Aumenta el límite de crédito en un 10%
    2. Si el cliente tiene entre 6 y 10 pedidos: Aumenta el límite de crédito en un 15%
    3. Si el cliente tiene más de 10 pedidos: Aumenta el límite de crédito en un 20%
    4. Si el cliente no tiene pedidos, no se actualiza el límite de crédito.
    Queremos ver en la salida el código de cliente, el número de pedidos que tiene y el
    límite de crédito antes y después de actualizarse.*/
SELECT * FROM EMPLEADO;
SELECT cl.codcliente,cl.codempleadoventas, COUNT(1)
    FROM CLIENTE CL
    LEFT JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
    GROUP BY cl.codcliente,cl.codempleadoventas
    ORDER BY 2;
//90-1 10
//8-2 10
//19-2 15 Y 20

DECLARE
    CURSOR EMP IS
        (SELECT cl.codcliente COD, cl.nombrecliente NOM, NVL(COUNT(1), 0) CONT, cl.limitecredito LIM
            FROM cliente CL
            LEFT JOIN pedido PE ON cl.codcliente=pe.codcliente
            WHERE cl.codempleadoventas = &CODIGOeMPLEADO
            GROUP BY cl.codcliente, cl.nombrecliente, cl.limitecredito
        ) ORDER BY 3;
    
    V_LIMI CLIENTE.limitecredito%TYPE;
BEGIN 
    FOR I IN EMP LOOP
        IF I.CONT=0 THEN 
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('No se le actualiza: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
        ELSIF I.CONT<6 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.10) WHERE cl.codcliente=I.COD;
            SELECT cl.limitecredito LIMI
            INTO V_LIMI
                FROM cliente CL
                WHERE cl.codcliente=I.COD;
            
            DBMS_OUTPUT.PUT_LINE('Despues (+10%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||V_LIMI||'€');
        
        ELSIF I.CONT<10 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.15) WHERE cl.codcliente=I.COD;
            SELECT cl.limitecredito LIMI
            INTO V_LIMI
                FROM cliente CL
                WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+15%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||V_LIMI||'€');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.20) WHERE cl.codcliente=I.COD;
            SELECT cl.limitecredito LIMI
            INTO V_LIMI
                FROM cliente CL
                WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+20%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||V_LIMI||'€');
                
        END IF;
    END LOOP;
END;

/*5. Haz un informe que me dé por cada producto el nombre del producto, el nombre de
los clientes que han comprado el producto, el total de clientes que han comprado el
producto y si no hay pedidos, que indique que no hay pedidos.*/
DECLARE
    CURSOR PROD IS (SELECT pr.codproducto COD, pr.nombre NOMPR
                        FROM PRODUCTO PR);
                        
    CURSOR CLIEN (V_CODPR PRODUCTO.CODPRODUCTO%TYPE) IS 
        (SELECT cl.nombrecliente NOMCL
            FROM PRODUCTO PR
            LEFT JOIN detalle_pedido DE ON de.codproducto=pr.codproducto
            LEFT JOIN pedido PE ON pe.codpedido=de.codpedido
            LEFT JOIN cliente CL ON cl.codcliente=pe.codcliente
            WHERE pr.codproducto = V_CODPR
        );
        
    V_CONT NUMBER;
BEGIN
    FOR I IN PROD LOOP
        DBMS_OUTPUT.PUT_LINE('Producto: '||I.NOMPR);
        V_CONT:=0;
        FOR J IN CLIEN(I.COD) LOOP
            IF J.NOMCL IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('  No hay pedidos');
            ELSE 
                DBMS_OUTPUT.PUT_LINE('  Cliente: '||J.NOMCL);
                V_CONT:=V_CONT+1;
            END IF;
        END LOOP;
        
        IF V_CONT>0 THEN
            DBMS_OUTPUT.PUT_LINE(' Total clientes: '||V_CONT);
        END IF;
            DBMS_OUTPUT.PUT_LINE(' ');
    END LOOP;
END;

/*6. Crea en la tabla de productos un campo llamado “Oferta” que admitirá valores (SI/NO)
(estaría bien que el valor por defecto sea NO). Haz un script con un cursor que recorra
los productos con stock de más de 100 unidades y para los que no haya pedidos. Para
estos pedidos se marcará el campo oferta con SI.
Asegúrate que nadie puede modificar los registros del cursor que estás recorriendo.*/
    ALTER TABLE PRODUCTO ADD Oferta VARCHAR(2) DEFAULT 'NO' NOT NULL ; 
    
    SELECT pr.codproducto COD, COUNT(de.codproducto) CONT, pr.oferta
                        FROM PRODUCTO PR
                        LEFT JOIN detalle_pedido DE ON de.codproducto=pr.codproducto
                        WHERE pr.stock>100
                        GROUP BY pr.codproducto, pr.oferta
                        HAVING COUNT(de.codproducto)<1;
DECLARE
    CURSOR PROD IS (SELECT pr.codproducto COD, COUNT(de.codproducto) CONT
                        FROM PRODUCTO PR
                        LEFT JOIN detalle_pedido DE ON de.codproducto=pr.codproducto
                        WHERE pr.stock>100
                        GROUP BY pr.codproducto);
BEGIN
    FOR I IN PROD LOOP
        IF I.CONT<1 THEN
            UPDATE PRODUCTO PR SET pr.oferta='SI' WHERE pr.codproducto=I.COD;
        END IF;
    END LOOP;
END;

/*7. Crea una nueva tabla de productos descatalogados (misma estructura que la tabla de
productos). Haz un cursor que recorra los productos con stock de menos de 5 unidades
y para los que no haya pedidos. Estos productos hay que meterlos en la tabla de
productos descatalogados y borrarlos de la tabla de productos.*/
    
CREATE TABLE DESCATALOGADOS AS SELECT * FROM PRODUCTO WHERE 1 = 0;
    
DECLARE
    CURSOR DESCA IS (SELECT pr.codproducto COD, COUNT(de.codproducto) CONT
                        FROM PRODUCTO PR
                        LEFT JOIN detalle_pedido DE ON de.codproducto=pr.codproducto
                        WHERE pr.stock<5
                        GROUP BY pr.codproducto
                        HAVING COUNT(de.codproducto)=0);
                        
    V_DESCAPROD PRODUCTO%ROWTYPE;
BEGIN

    FOR I IN DESCA LOOP
        SELECT *
        INTO V_DESCAPROD
            FROM PRODUCTO PR
            WHERE pr.codproducto=I.COD;
        
        INSERT INTO DESCATALOGADOS DESCA VALUES v_descaprod;
        
        DELETE FROM PRODUCTO PR WHERE pr.codproducto=I.COD;
        
    END LOOP;
    
END;

SELECT * FROM descatalogados;
SELECT * FROM PRODUCTO PR WHERE pr.codproducto IN ('OR-233','OR-212','OR-235') 






