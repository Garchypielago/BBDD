SET SERVEROUTPUT ON;
--1 
CREATE OR REPLACE FUNCTION F_PROD_PEDIDOS
    (V_PRO PRODUCTOS.IDPRODUCTO%TYPE) RETURN NUMBER IS
    
    V_PEDIDOS NUMBER;
    E_NULO EXCEPTION;
    
BEGIN
    IF ( V_PRO IS NULL) THEN
        RAISE E_NULO;
    END IF;
    
    SELECT DISTINCT(COUNT(1)) --POR SI HAY EM UM PEDIDO DIFERENTES DECUENTOS O ALGO ASI
    INTO V_PEDIDOS
        FROM detalle_pedidos DE
        WHERE DE.idproducto = V_PRO;
    
    RETURN v_pedidos;
EXCEPTION
    WHEN E_NULO THEN 
        dbms_output.PUT_LINE('ERROR: NULO');
        RETURN -1;
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
        RETURN -1;
END;


--2
CREATE OR REPLACE PROCEDURE P_LISTAR_PROV_PROD IS

    CURSOR C_PROVE IS (SELECT PRO.idproveedor ID, PRO.nombre NOM, PRO.ciudad CIU
                        FROM proveedores PRO);
    
    CURSOR C_PROD(V_PROVE PROVEEDORES.IDPROVEEDOR%TYPE) IS 
        (SELECT PR.idproducto ID, PR.nombre NOM , f_prod_pedidos(PR.idproducto) FUN
            FROM productos PR
            WHERE PR.idproveedor = V_PROVE);
            
    E_FUNCION EXCEPTION;
BEGIN
    FOR I IN C_PROVE LOOP
        dbms_output.PUT_LINE('-Proveedor: '||I.ID||', '||I.NOM||', '||I.CIU);
        FOR J IN C_PROD(I.ID) LOOP
            dbms_output.PUT_LINE('   -Producto: '||J.ID||', '||J.NOM||', pedidosTotales: '||J.FUN);
        END LOOP;
    END LOOP;

EXCEPTION
    WHEN E_FUNCION THEN
        dbms_output.PUT_LINE('ERROR: FUNCION');
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

CALL p_listar_prov_prod();

--3
CREATE OR REPLACE PROCEDURE P_FECHA_MAYOR
    (V_FECHA PEDIDOS.FECHAPEDIDO%TYPE) IS

    CURSOR C_PEDIDO (V_FECHA PEDIDOS.FECHAPEDIDO%TYPE) IS
        (SELECT pe.idpedido ID, cl.nombre NOM, co.nombre COM, pe.ciudaddest CIU, pe.fechaentrega ENT
            FROM PEDIDOS PE
            LEFT JOIN clientes CL ON cl.idcliente = pe.idcliente
            LEFT JOIN comp_envio CO ON co.idcompania = pe.compenvio
            WHERE PE.fechaentrega > V_FECHA);

    E_NULO EXCEPTION;
BEGIN
    IF ( V_FECHA IS NULL) THEN
        RAISE E_NULO;
    END IF;
    
    FOR I IN C_PEDIDO(V_FECHA) LOOP
        dbms_output.PUT_LINE('- '||I.ID||', '||I.NOM||', '||I.COM||', '||I.CIU||', '||I.ENT);
    END LOOP;
EXCEPTION
    WHEN E_NULO THEN 
        dbms_output.PUT_LINE('ERROR: NULO');
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

SELECT * FROM pedidos;

CALL p_fecha_mayor('06/05/97');

--4
ALTER TABLE CLIENTES ADD DESCUENTO_ACUMULADO NUMBER(10,2) DEFAULT 0 NOT NULL;

CREATE OR REPLACE TRIGGER T_DESC_ACUM
    AFTER INSERT ON PEDIDOS
    FOR EACH ROW
BEGIN
    UPDATE clientes CL 
        SET cl.descuento_acumulado = cl.descuento_acumulado + (:NEW.CARGO * 0.05)  --SUPONGO QUE SI SE LE ACUMULA, NO SE RESETEA EN CADA PEDIDO
        WHERE cl.idcliente = :NEW.IDCLIENTE;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

SELECT * FROM clientes;
--ALFKI	Alfreds Futterkiste	Maria Anders	Representante de ventas	Obere Str. 57	Berlin		12209	Alemania	030-0074321	030-0076545	0
SELECT * FROM pedidos;
INSERT INTO PEDIDOS VALUES (1,	'ALFKI',NULL,NULL,NULL,NULL,NULL,100,NULL,NULL,NULL,NULL,NULL,NULL);
--ALFKI	Alfreds Futterkiste	Maria Anders	Representante de ventas	Obere Str. 57	Berlin		12209	Alemania	030-0074321	030-0076545	5

--5
CREATE TABLE CLIENTE_MES(
ID_CLIENTE VARCHAR2(5) NOT NULL,
ANIO NUMBER(4) NOT NULL,
MES NUMBER(2) NOT NULL,
TOTAL_GASTADO NUMBER(20,2) NOT NULL,
CONSTRAINT F_CLI
FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES(IDCLIENTE),
PRIMARY KEY (ANIO, MES)
);


CREATE OR REPLACE PROCEDURE P_CLI_DELMES_PORANIO 
    (V_ANIO NUMBER) IS
    
    CURSOR C_MES (V_ANIO NUMBER) IS 
        (SELECT pe.idcliente CLI, TO_CHAR(pe.fechapedido, 'YYYY') AN, TO_CHAR(pe.fechapedido, 'mm') MES, SUM(pe.cargo) TOTAL
            FROM pedidos PE 
            WHERE TO_CHAR(pe.fechapedido, 'YYYY') = V_ANIO
            GROUP BY  pe.idcliente, TO_CHAR(pe.fechapedido, 'YYYY'), TO_CHAR(pe.fechapedido, 'mm'))
            ORDER BY 3, 4 DESC;
            
    V_CONTADOR NUMBER:=1;

    E_NULO EXCEPTION;
BEGIN
    IF ( V_ANIO IS NULL) THEN
        RAISE E_NULO;
    END IF;
    
    FOR I IN C_MES(V_ANIO) LOOP
        IF (I.MES=V_CONTADOR) THEN
            INSERT INTO cliente_mes VALUES (I.CLI, I.AN, I.MES, I.TOTAL);
            V_CONTADOR := V_CONTADOR+1;
        END IF;
    END LOOP;
EXCEPTION
    WHEN E_NULO THEN 
        dbms_output.PUT_LINE('ERROR: NULO');
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

DELETE FROM CLIENTE_MES;
CALL p_cli_delmes_poranio(1997);
SELECT * FROM cliente_mes;


--5 V2 PREFIERO ESTA VERSION, MAS LIMPIA
CREATE OR REPLACE PROCEDURE P_CLI_DELMES_PORANIO_V2
    (V_ANIO NUMBER) IS
    
    CURSOR C_MES (V_ANIO NUMBER, V_MES NUMBER) IS 
        (SELECT pe.idcliente CLI, SUM(pe.cargo) TOTAL
            FROM pedidos PE 
            WHERE TO_CHAR(pe.fechapedido, 'YYYY') = V_ANIO AND TO_CHAR(pe.fechapedido, 'mm') = V_MES
            GROUP BY  pe.idcliente)
            ORDER BY 2 DESC;

    E_NULO EXCEPTION;
BEGIN
    IF ( V_ANIO IS NULL) THEN
        RAISE E_NULO;
    END IF;
    
    FOR J IN 1..12 LOOP
        FOR I IN C_MES(V_ANIO, J) LOOP
            INSERT INTO cliente_mes VALUES (I.CLI, V_ANIO, J, I.TOTAL);
            EXIT;
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN E_NULO THEN 
        dbms_output.PUT_LINE('ERROR: NULO');
    WHEN OTHERS THEN
        dbms_output.PUT_LINE(SQLERRM);
END;

DELETE FROM CLIENTE_MES;
CALL p_cli_delmes_poranio_V2(1997);
SELECT * FROM cliente_mes;



