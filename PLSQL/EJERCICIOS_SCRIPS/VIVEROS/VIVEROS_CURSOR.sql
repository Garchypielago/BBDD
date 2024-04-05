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
BEGIN
    FOR I IN EMP LOOP
        DBMS_OUTPUT.PUT_LINE(I.COD||' - '||I.APE1||', '||I.APE2);
    END LOOP;
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
    JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
    GROUP BY cl.codcliente,cl.codempleadoventas
    ORDER BY 2;
//90-1 10
//8-2 10
//19-2 15 Y 20

DECLARE
    CURSOR EMP IS
        (SELECT cl.codcliente COD, cl.nombrecliente NOM, COUNT(1) CONT, cl.limitecredito LIM
            FROM cliente CL
            LEFT JOIN pedido PE ON cl.codcliente=pe.codcliente
            WHERE cl.codempleadoventas = &CODIGOeMPLEADO
            GROUP BY cl.codcliente, cl.nombrecliente, cl.limitecredito
        ) ORDER BY 3;
        
BEGIN 
    FOR I IN EMP LOOP
        IF I.CONT=0 THEN 
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('No se le actualiza: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
        ELSIF I.CONT<6 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.10) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+10%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
        
        ELSIF I.CONT<10 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.15) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+15%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.20) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+20%): '||I.COD||' - '||I.NOM||', Nºpedidos: '||I.CONT||', Limite crédito: '||I.LIM||'€');
                
        END IF;
    END LOOP;
END;

TERMINAR ESTE BN

/*5. Haz un informe que me dé por cada producto el nombre del producto, el nombre de
los clientes que han comprado el producto, el total de clientes que han comprado el
producto y si no hay pedidos, que indique que no hay pedidos.*/

/*6. Crea en la tabla de productos un campo llamado “Oferta” que admitirá valores (SI/NO)
(estaría bien que el valor por defecto sea NO). Haz un script con un cursor que recorra
los productos con stock de más de 100 unidades y para los que no haya pedidos. Para
estos pedidos se marcará el campo oferta con SI.
Asegúrate que nadie puede modificar los registros del cursor que estás recorriendo.*/

/*7. Crea una nueva tabla de productos descatalogados (misma estructura que la tabla de
productos). Haz un cursor que recorra los productos con stock de menos de 5 unidades
y para los que no haya pedidos. Estos productos hay que meterlos en la tabla de
productos descatalogados y borrarlos de la tabla de productos.*/
