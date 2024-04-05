SET SERVEROUTPUT ON;
/*1. Crear un bloque PL que recorra un cursor con todos los clientes que vivan en Espa�a y
pinte el nombre del cliente, su tel�fono y su ciudad.*/
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
        DBMS_OUTPUT.PUT_LINE(I.NOM||' - '||I.PV||'�, Dimensiones: '||I.DIM);
    END LOOP;

END;

/*3. Escribir un bloque PL que reciba una cadena y visualice el apellido y el c�digo de
empleado de todos los empleados cuyo apellido contenga la cadena especificada. Al
finalizar se visualizar� el n�mero de empleados mostrados.*/
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

/*4. Crear un bloque PL que le pida al usuario un c�digo de empleado y recorra los clientes
asociados a ese c�digo de empleado. Por cada cliente contar� el n�mero de pedidos y
en funci�n de estos le aumentar� el l�mite de cr�dito.
    1. Si el cliente tiene entre 1 y 5 pedidos: Aumenta el l�mite de cr�dito en un 10%
    2. Si el cliente tiene entre 6 y 10 pedidos: Aumenta el l�mite de cr�dito en un 15%
    3. Si el cliente tiene m�s de 10 pedidos: Aumenta el l�mite de cr�dito en un 20%
    4. Si el cliente no tiene pedidos, no se actualiza el l�mite de cr�dito.
    Queremos ver en la salida el c�digo de cliente, el n�mero de pedidos que tiene y el
    l�mite de cr�dito antes y despu�s de actualizarse.*/
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
            DBMS_OUTPUT.PUT_LINE('No se le actualiza: '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
            
        ELSIF I.CONT<6 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.10) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+10%): '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
        
        ELSIF I.CONT<10 THEN
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.15) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+15%): '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE(' ');
            DBMS_OUTPUT.PUT_LINE('Antes: '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
            
            UPDATE cliente CL SET cl.limitecredito=cl.limitecredito*(1.20) WHERE cl.codcliente=I.COD;
            DBMS_OUTPUT.PUT_LINE('Despues (+20%): '||I.COD||' - '||I.NOM||', N�pedidos: '||I.CONT||', Limite cr�dito: '||I.LIM||'�');
                
        END IF;
    END LOOP;
END;

TERMINAR ESTE BN

/*5. Haz un informe que me d� por cada producto el nombre del producto, el nombre de
los clientes que han comprado el producto, el total de clientes que han comprado el
producto y si no hay pedidos, que indique que no hay pedidos.*/

/*6. Crea en la tabla de productos un campo llamado �Oferta� que admitir� valores (SI/NO)
(estar�a bien que el valor por defecto sea NO). Haz un script con un cursor que recorra
los productos con stock de m�s de 100 unidades y para los que no haya pedidos. Para
estos pedidos se marcar� el campo oferta con SI.
Aseg�rate que nadie puede modificar los registros del cursor que est�s recorriendo.*/

/*7. Crea una nueva tabla de productos descatalogados (misma estructura que la tabla de
productos). Haz un cursor que recorra los productos con stock de menos de 5 unidades
y para los que no haya pedidos. Estos productos hay que meterlos en la tabla de
productos descatalogados y borrarlos de la tabla de productos.*/
