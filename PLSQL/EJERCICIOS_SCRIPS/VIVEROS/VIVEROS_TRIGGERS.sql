SET SERVEROUTPUT ON;
/*1. Crea un trigger de tabla que impida cambiar el precio de venta si este es menor que
el precio de proveedor.*/
CREATE OR REPLACE TRIGGER T_PRECIO_MENOR
    BEFORE INSERT OR UPDATE  OF PRECIOVENTA ON PRODUCTO
    FOR EACH ROW
DECLARE
    E_PRECIO_MENOR EXCEPTION;
    E_PRECIO_IGUAL EXCEPTION;
BEGIN
    IF (:NEW.PRECIOVENTA<:NEW.PRECIOPROVEEDOR) THEN
        RAISE E_PRECIO_MENOR;
    END IF;
    IF (:NEW.PRECIOVENTA=:NEW.PRECIOPROVEEDOR) THEN
        RAISE E_PRECIO_IGUAL;
    END IF;

EXCEPTION
    WHEN E_PRECIO_MENOR THEN
        RAISE_APPLICATION_ERROR(-20003,'PRECIO MENOR AL DE PROOVEDOR, PERDIDA SUSTANCIAL');
        RETURN;
    WHEN E_PRECIO_IGUAL THEN
        DBMS_OUTPUT.PUT_LINE('AVISO: GANANCIA NULA, MISMO PRECIO QUE PROVEEDOR');
        RETURN;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;

SELECT * FROM PRODUCTO;

UPDATE PRODUCTO SET precioventa=5 WHERE codproducto='FR-41';--MENOR
UPDATE PRODUCTO SET precioventa=6 WHERE codproducto='FR-41';--IGUAL
UPDATE PRODUCTO SET precioventa=8 WHERE codproducto='FR-41';--INICIAL
    

/*2. Crear un trigger que cuando se cambie el estado de un pedido a “Entregado”, rellene
automáticamente la fecha de entrega con el día.*/
CREATE OR REPLACE TRIGGER T_ENTREGA
    BEFORE UPDATE OF ESTADO ON PEDIDO
    FOR EACH ROW
BEGIN
    IF (:NEW.ESTADO = 'Entregado') THEN
        :NEW.fechaentrega := SYSDATE;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;

UPDATE PEDIDO SET ESTADO = 'Entregado' WHERE codpedido=4;

SELECT * FROM PEDIDO;

ROLLBACK;


/*3. Crea un trigger que cuando se inserte un pago, aumente el límite de crédito del
cliente en la misma cantidad que el pago realizado.*/
CREATE OR REPLACE TRIGGER T_PAGO_AUMENTO
    AFTER INSERT ON PAGO
    FOR EACH ROW
BEGIN
    UPDATE CLIENTE CL SET CL.LIMITECREDITO = CL.LIMITECREDITO + :NEW.IMPORTETOTAL WHERE CL.codcliente = :NEW.CODCLIENTE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;

SELECT CL.CODCLIENTE, cl.limitecredito
    FROM CLIENTE CL;-- 4320 <- TRAS EL INSERT -> 5321

INSERT INTO PAGO VALUES (1, 'PRUEBA', 'PRUEBA', SYSDATE, 1001);

/*4. Crea un trigger que cuando cambie de tienda a un empleado haga las siguientes
acciones:
a. Si el empleado no tiene jefe, no deja hacer el cambio.
b. Si el empleado tiene jefe, pone a este como Empleado de ventas de todos
         los clientes que tuviera el empleado al que han cambiado de tienda.
c. Pone a nulo el campo de jefe del empleado al que están moviendo de tienda.*/

CREATE OR REPLACE TRIGGER T_CAMBIO_TIENDAEMP
    BEFORE UPDATE OF CODTIENDA ON EMPLEADO
    FOR EACH ROW
DECLARE
    E_SINJEFE EXCEPTION;
BEGIN
    IF (:OLD.CODJEFE IS NULL) THEN
        RAISE E_SINJEFE;
    END IF;
    
    UPDATE CLIENTE SET CODEMPLEADOVENTAS = :OLD.CODJEFE WHERE CODEMPLEADOVENTAS = :OLD.CODEMPLEADO;
    
    :NEW.CODJEFE := NULL;

EXCEPTION
    WHEN E_SINJEFE THEN
        RAISE_APPLICATION_ERROR(-20006,'ERROR: EMPLEADO SIN JEFE');
        RETURN;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;
/*
            5	            3	    VAL-ES	        16
            5	            3	    VAL-ES	        30          */
SELECT em.codempleado, em.codjefe, em.codtienda, cl.codcliente
    FROM EMPLEADO EM
    JOIN CLIENTE CL ON cl.codempleadoventas=em.codempleado;
/*          3	            2	    VAL-ES	        16
            3	            2	    VAL-ES	        30          */

UPDATE EMPLEADO SET empleado.codtienda = 'MAD-ES' WHERE empleado.codempleado = 5;

SELECT * FROM EMPLEADO WHERE empleado.codempleado=5; --JEFE = NULL, TIENDA=MAD-ES


/*5. Crea un trigger que si ponemos a 0 el límite de crédito de un cliente, marque como
rechazados todos los pedidos que tuviera pendientes.*/

CREATE OR REPLACE TRIGGER T_0CREDITO
    AFTER UPDATE OF LIMITECREDITO ON CLIENTE
    FOR EACH ROW
BEGIN
    IF (:NEW.LIMITECREDITO = 0) THEN
        UPDATE PEDIDO PE SET pe.estado = 'Rechazado' WHERE pe.estado = 'Pendiente' AND pe.codcliente = :NEW.CODCLIENTE;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN;
END;

SELECT * FROM PEDIDO;

UPDATE CLIENTE SET LIMITECREDITO=0 WHERE CODCLIENTE=3;

ROLLBACK;






