SET SERVEROUTPUT ON;
/*1. Crea la función f_calcular_precio_total_pedido para que dado un código de pedido
calcule la suma total del pedido. Ten en cuenta que un pedido puede contener varios
productos diferentes y varias cantidades de cada producto.*/
CREATE OR REPLACE FUNCTION f_calcular_precio_total_pedido
    (V_CODPE PEDIDO.CODPEDIDO%TYPE) RETURN NUMBER IS
    V_SUMPE NUMBER;
    
    E_NULO EXCEPTION;
    
BEGIN
    IF V_CODPE IS NULL THEN
        RAISE E_NULO;
    END IF;

    SELECT NVL(SUM(DE.preciounidad*DE.cantidad),0) SUMA
    INTO V_SUMPE
        FROM detalle_pedido DE
        WHERE DE.codpedido= V_CODPE;
    RETURN v_sumpe;
    
EXCEPTION
    WHEN E_NULO THEN
        RETURN -1;
        
END f_calcular_precio_total_pedido;



SELECT * FROM pEDIDO;
SELECT f_calcular_precio_total_pedido(PE.CODPEDIDO), PE.* FROM pedido PE;

/*2. Crea la función f_calcular_suma_pedidos_cliente que a partir de un código de cliente
calcule la suma total de todos los pedidos realizados por el cliente. Debes utilizar
función f_calcular_precio_total_pedido que has creado en el ejercicio anterior.*/
CREATE OR REPLACE FUNCTION f_calcular_suma_pedidos_cliente
    (V_CODCLI CLIENTE.CODCLIENTE%TYPE) RETURN NUMBER IS
    V_SUMPE NUMBER;
    
    E_ERRORFUNC EXCEPTION;
    
    E_NULO EXCEPTION;
    
BEGIN
    IF V_CODCLI IS NULL THEN
        RAISE E_NULO;
    END IF;
    
    SELECT NVL(SUM(f_calcular_precio_total_pedido(PE.CODPEDIDO)),0)
    INTO V_SUMPE
        FROM pedido PE
        WHERE PE.codcliente=V_CODCLI;
    
    IF V_SUMPE=-1 THEN
        RAISE E_ERRORFUNC;
    END IF;
        
    RETURN V_SUMPE;
    
EXCEPTION
    WHEN E_NULO THEN
        RETURN -1;
    WHEN E_ERRORFUNC THEN
        RETURN -1;

END f_calcular_suma_pedidos_cliente;

SELECT f_calcular_suma_pedidos_cliente(CL.codcliente), CL.* FROM CLIENTE CL;


/*3. Crea la función f_calcular_pagos_cliente que a partir de un código de cliente calcule la
suma total de los pagos realizados por ese cliente.*/
CREATE OR REPLACE FUNCTION f_calcular_pagos_cliente
    (V_CODCLI CLIENTE.CODCLIENTE%TYPE) RETURN NUMBER IS
    V_SUMPA NUMBER;
   
    E_NULO EXCEPTION;
    
BEGIN
    IF V_CODCLI IS NULL THEN
        RAISE E_NULO;
    END IF;
    
    SELECT NVL(SUM(PA.importetotal),0)
    INTO V_SUMPA
        FROM pago PA
        WHERE PA.codcliente = v_codcli;
    
    RETURN v_sumpa;

EXCEPTION
    WHEN E_NULO THEN
        RETURN -1;
    
END f_calcular_pagos_cliente;

SELECT f_calcular_pagos_cliente(CL.CODCLIENTE), CL.* FROM CLIENTE CL;
SELECT * FROM PAGO;

/*4. Crea un procedimiento almacenado que muestre un listado con el nombre del cliente y
el importe de sus pagos pendientes. Consideramos que los pagos pendientes de un
cliente es la diferencia entre el importe total de los pedidos y el importe total de los
pagos. Utiliza las funciones que has creado en los últimos 2 ejercicios.*/
CREATE OR REPLACE FUNCTION f_calcular_DEUDA
    (V_CODCLI CLIENTE.CODCLIENTE%TYPE) RETURN NUMBER IS
    V_DEUDA NUMBER;
    
    V_SUMPE NUMBER;
    V_PAGOS NUMBER;
    
    E_ERRORFUNC EXCEPTION;
    
    E_NULO EXCEPTION;
    
BEGIN
    IF V_CODCLI IS NULL THEN
        RAISE E_NULO;
    END IF;    
    
    SELECT SUM(f_calcular_suma_pedidos_cliente(CL.codcliente)) SUMPE, f_calcular_pagos_cliente(CL.codcliente) PAGOS
    INTO V_SUMPE, V_PAGOS
        FROM cliente CL
        WHERE CL.codcliente = V_CODCLI;
    
    IF V_SUMPE =-1 OR V_PAGOS=-1 THEN
        RAISE E_ERRORFUNC;
    END IF;
    
    V_DEUDA := ROUND(V_SUMPE-V_PAGOS,2);
        
    RETURN v_deuda;
EXCEPTION
    WHEN E_NULO THEN
        RETURN -1;
    WHEN E_ERRORFUNC THEN
        RETURN -1;
    WHEN OTHERS THEN 
        RETURN -1;
    

END f_calcular_DEUDA;

SELECT F_calcular_deuda(CL.CODCLIENTE), CL.* FROM CLIENTE CL;

CREATE OR REPLACE PROCEDURE P_calcular_DEUDA
    (V_CODCLI CLIENTE.CODCLIENTE%TYPE,
    V_DEUDA OUT NUMBER) IS
    
    V_SUMPE NUMBER;
    V_PAGOS NUMBER;
    
    E_ERRORFUNC EXCEPTION;
    
    E_NULO EXCEPTION;
    
BEGIN
    IF V_CODCLI IS NULL THEN
        RAISE E_NULO;
    END IF;
    
    SELECT SUM(f_calcular_suma_pedidos_cliente(CL.codcliente)) SUMPE, f_calcular_pagos_cliente(CL.codcliente) PAGOS
    INTO V_SUMPE, V_PAGOS
        FROM cliente CL
        WHERE CL.codcliente = V_CODCLI;
    IF V_SUMPE =-1 OR V_PAGOS=-1 THEN
        RAISE E_ERRORFUNC;
    END IF;
    
    V_DEUDA := ROUND(V_SUMPE-V_PAGOS,2);
EXCEPTION
    WHEN E_NULO THEN
    dbms_output.PUT_LINE('ERROR: ENTRADA NULO');
        V_DEUDA := -1;
    WHEN E_ERRORFUNC THEN
    dbms_output.PUT_LINE('ERROR: FUNCION FALLIDA');
        V_DEUDA := -1;
    WHEN OTHERS THEN 
    dbms_output.PUT_LINE('ERROR: GENERAL');
        V_DEUDA := -1;

END P_calcular_DEUDA;

DECLARE
    DEUDA NUMBER;
BEGIN
    P_calcular_deuda(&CODCLI, DEUDA);
    dbms_output.put_line(DEUDA);
END;

/*5. Crea un procedimiento que reciba un empleado y haga un cursor con los clientes a los
que está asociado el empleado. Por cada cliente asociado deberá llamar al
procedimiento del ejercicio anterior para que vaya “pintando” si tiene pagos
pendientes.*/
CREATE OR REPLACE PROCEDURE P_EMP_CLIDEUDAS
    (V_CODEMP CLIENTE.CODEMPLEADOVENTAS%TYPE) IS
    
    CURSOR EMPLEADO IS
        (SELECT CL.codcliente COD
            FROM cliente CL
            WHERE CL.codempleadoventas = V_CODEMP);
    
    DEUDA NUMBER;
    
    E_NULO EXCEPTION;
    E_PROCERROR EXCEPTION;
BEGIN
    IF V_CODEMP IS NULL THEN 
        RAISE E_NULO;
    END IF;

    dbms_output.put_line('EMPLEADO '||V_CODEMP);
    FOR I IN EMPLEADO LOOP
        P_calcular_DEUDA(I.COD,DEUDA);
        IF DEUDA = -1 THEN 
            RAISE E_PROCERROR;
        END IF;
        dbms_output.put_line(I.COD||' TIENE '||DEUDA||'€ DE DEUDA');
    END LOOP;
EXCEPTION
    WHEN E_NULO THEN
    dbms_output.PUT_LINE('ERROR: ENTRADA NULO');
    WHEN E_PROCERROR THEN
    dbms_output.PUT_LINE('ERROR: PROCEDIMIENTO FALLIDO');
    WHEN OTHERS THEN 
    dbms_output.PUT_LINE('ERROR: GENERAL');

END P_EMP_CLIDEUDAS;


CALL P_EMP_CLIDEUDAS(5);

SELECT * FROM empleado;


/*6. Crea una función que reciba como parámetro el codTienda y devuelva su dirección de
email. La dirección de email se formará concatenando el codTienda y la ciudad, y el
dominio ‘@viverosdelmundo.org’. Ejemplo: si tenemos la tienda 'BCN-ES' que está en
Barcelona, su email quedará 'BCN-ES_Barcelona@viverosdelmundo.org'*/
CREATE OR REPLACE FUNCTION F_CREAR_EMAIL
    (V_CODTI TIENDA.CODTIENDA%TYPE) RETURN VARCHAR2 IS
    V_EMAIL VARCHAR2(50);
    
    E_TIENDAOBLIGATORIA EXCEPTION;

BEGIN
    IF V_CODTI IS NULL THEN
        RAISE E_TIENDAOBLIGATORIA;
    END IF;

    DBMS_OUTPUT.PUT_LINE('ESTOY AQUI');
    
    SELECT (TRIM(TI.codtienda)||'_'||TRIM(TI.ciudad)||'@viverosdelmundo.org')
    INTO V_EMAIL
        FROM TIENDA TI
        WHERE TI.CODTIENDA = V_CODTI;
        --OR TI.codtienda = 'BCN-ES';
    
    RETURN V_EMAIL;
    
exception
    WHEN NO_DATA_FOUND THEN 
        --RAISE_APPLICATION_ERROR(-20001,'LA TIENDA NO EXISTE');
        RETURN 'NO EXISTE';
    when E_TIENDAOBLIGATORIA THEN
        RETURN 'TIENDA OBLIGATORIA';
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN 'ERROR GENERAL';
        
END F_CREAR_EMAIL;

SELECT f_crear_email(TI.CODTIENDA), TI.* FROM TIENDA TI;
SELECT f_crear_email(NULL) FROM dual;
SELECT f_crear_email('PEPE') FROM dual;



/*7. Crea una tabla tienda_email con las columnas:
            codTienda
            email
Crea un procedimiento almacenado que inserte los codTienda y su email utilizando la
función creada en el ejercicio anterior*/
CREATE TABLE TIENDA_EMAIL(
    CODTIENDA VARCHAR2(10) NOT NULL PRIMARY KEY,
    EMAIL VARCHAR2(50) NOT NULL,
    CONSTRAINT FK_CODTIENDA
    FOREIGN KEY (CODTIENDA) REFERENCES Tienda(CODTIENDA)
);

DROP TABLE TIENDA_EMAIL;

CREATE OR REPLACE PROCEDURE P_RELLENAR_EMAILS IS

    CURSOR C1 IS (SELECT TI.codtienda COD
                    FROM TIENDA TI);
            
    E_FUNCERROR EXCEPTION;
BEGIN
    FOR I IN C1 LOOP
        INSERT INTO TIENDA_EMAIL VALUES (I.COD, f_crear_email(I.COD));
    END LOOP;
END P_RELLENAR_EMAILS;

CALL P_RELLENAR_EMAILS();

CALL p_rellenar_email('BCN-ES');
SELECT * FROM TIENDA;
SELECT * FROM tienda_email;




