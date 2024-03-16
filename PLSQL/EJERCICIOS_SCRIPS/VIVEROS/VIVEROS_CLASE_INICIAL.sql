--SET SERVEROUTPUT ON;

DECLARE
    V_CODIGO_CLIENTE CLIENTE.CODCLIENTE%TYPE;
    V_PEDIDOS NUMBER:=0;
BEGIN 
    v_codigo_cliente:=&COD;

    SELECT COUNT(1)
    INTO V_PEDIDOS
    FROM pedido PE
    WHERE PE.codcliente=v_codigo_cliente;
    
    DBMS_OUTPUT.put_line('Pedidos de '|| v_codigo_cliente ||': '||v_PEDIDOS);
END;


DECLARE
    V_CLIENTE CLIENTE%ROWTYPE;
    V_CODIGO_CLIENTE CLIENTE.CODCLIENTE%TYPE:=&COD;
    V_PEDIDOS NUMBER:=0;
    
    /*PODEMOS DECLARAR LO QUE QUERAMOS 
    EL ROWTYPE DEVULEVE LOS TIPOS DE CADA COSA DE TODA LA FILA
    EL TYPE DEVUELVE EL TIPO DEL CONSULTADO*/
    
BEGIN 
    --v_codigo_cliente:=&COD;

    SELECT COUNT(1)
    INTO V_PEDIDOS
    FROM pedido PE
    WHERE PE.codcliente=v_codigo_cliente;
    
    SELECT *
    INTO V_CLIENTE
    FROM cliente CL
    WHERE CL.codcliente=v_codigo_cliente;
    
    IF v_pedidos >10 THEN
        DBMS_OUTPUT.put_line('HA COMPRADO MUCHO');
    ELSE
        DBMS_OUTPUT.put_line('HA COMPRADO POCO');
    END IF;
    
    DBMS_OUTPUT.put_line('Pedidos de '|| v_cliente.NOMBRECLIENTE ||': '||v_PEDIDOS);
END;


