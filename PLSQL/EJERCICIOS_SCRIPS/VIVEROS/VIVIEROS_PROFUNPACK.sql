/*1. Crea la funci�n f_calcular_precio_total_pedido para que dado un c�digo de pedido
calcule la suma total del pedido. Ten en cuenta que un pedido puede contener varios
productos diferentes y varias cantidades de cada producto.*/
CREATE OR REPLACE FUNCTION f_calcular_precio_total_pedido
    (V_CODPE PEDIDO.CODPEDIDO%TYPE) RETURN NUMBER IS
    V_SUMPE NUMBER;
    
BEGIN
    SELECT SUM(DE.preciounidad*DE.cantidad) SUMA
    INTO V_SUMPE
        FROM detalle_pedido DE
        WHERE DE.codpedido= V_CODPE;
    RETURN v_sumpe;
END f_calcular_precio_total_pedido;

SELECT * FROM pEDIDO;
SELECT f_calcular_precio_total_pedido(PE.CODPEDIDO), PE.* FROM pedido PE;

/*2. Crea la funci�n f_calcular_suma_pedidos_cliente que a partir de un c�digo de cliente
calcule la suma total de todos los pedidos realizados por el cliente. Debes utilizar
funci�n f_calcular_precio_total_pedido que has creado en el ejercicio anterior.*/
CREATE OR REPLACE FUNCTION f_calcular_suma_pedidos_cliente
    (V_CODCLI CLIENTE.CODCLIENTE%TYPE) RETURN NUMBER IS
    V_CONTPE NUMBER;
BEGIN
    
    
END f_calcular_suma_pedidos_cliente;


/*3. Crea la funci�n f_calcular_pagos_cliente que a partir de un c�digo de cliente calcule la
suma total de los pagos realizados por ese cliente.*/

/*4. Crea un procedimiento almacenado que muestre un listado con el nombre del cliente y
el importe de sus pagos pendientes. Consideramos que los pagos pendientes de un
cliente es la diferencia entre el importe total de los pedidos y el importe total de los
pagos. Utiliza las funciones que has creado en los �ltimos 2 ejercicios.*/

/*5. Crea un procedimiento que reciba un empleado y haga un cursor con los clientes a los
que est� asociado el empleado. Por cada cliente asociado deber� llamar al
procedimiento del ejercicio anterior para que vaya �pintando� si tiene pagos
pendientes.*/

/*6. Crea una funci�n que reciba como par�metro el codTienda y devuelva su direcci�n de
email. La direcci�n de email se formar� concatenando el codTienda y la ciudad, y el
dominio �@viverosdelmundo.org�. Ejemplo: si tenemos la tienda 'BCN-ES' que est� en
Barcelona, su email quedar� 'BCN-ES_Barcelona@viverosdelmundo.org'*/

/*7. Crea una tabla tienda_email con las columnas:
    codTienda
    email
Crea un procedimiento almacenado que inserte los codTienda y su email utilizando la
funci�n creada en el ejercicio anterior*/