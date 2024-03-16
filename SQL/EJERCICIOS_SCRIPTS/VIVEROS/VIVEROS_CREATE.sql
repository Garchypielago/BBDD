/*1. Crea una vista que muestre un listado donde aparezcan todos los clientes y los pagos que ha
realizado cada uno de ellos. La vista debe tener las siguientes columnas: nombre y apellidos del
contacto concatenados, teléfono, ciudad, pais, fecha_pago, importe del pago, id de la
transacción*/
CREATE OR REPLACE VIEW CLIENTE_PAGO_01_NULL_VIEW AS
SELECT cl.codcliente cod_cl,(CL.nombrecontacto|| ' ' || CL.apellidocontacto) NOMBRE, CL.telefono TEL, CL.ciudad CIU, CL.pais PAIS, 
        pa.fechapago FECHA_PA, pa.importetotal IMPORTE, pa.idtransaccion IDTRANS
        
    FROM cliente CL
    LEFT JOIN pago PA ON pa.codcliente=cl.codcliente;
    
CREATE OR REPLACE VIEW CLIENTE_PAGO_01_VIEW AS
SELECT cl.codcliente cod_cl,(CL.nombrecontacto|| ' ' || CL.apellidocontacto) NOMBRE, CL.telefono TEL, CL.ciudad CIU, CL.pais PAIS, 
        pa.fechapago FECHA_PA, pa.importetotal IMPORTE, pa.idtransaccion IDTRANS
        
    FROM cliente CL
    JOIN pago PA ON pa.codcliente=cl.codcliente;

/*2. Crea una vista que muestre un listado donde aparezcan todos los clientes y los pedidos que
ha realizado cada uno. La vista debe tener las siguientes columnas: nombre y apellidos del
contacto concatenados, teléfono, ciudad, país, código del pedido, fecha del pedido, fecha
esperada, fecha de entrega e importe total del pedido, que será la suma del producto de todas
las cantidades por el precio de cada unidad que aparecen en cada detalle de pedido.*/

CREATE OR REPLACE VIEW CLIENTE_PEDIDO_02_NULL_VIEW AS
SELECT cl.codcliente cod_cl,(CL.nombrecontacto|| ' ' || CL.apellidocontacto) NOMBRE, CL.telefono TEL, CL.ciudad CIU, CL.pais PAIS,
        pe.codpedido COD_PED, pe.fechapedido FECHA_PEDIDO, pe.fechaprevista FECHA_ESPERADA, 
        pe.fechaentrega FECHA_ENTREGA, SUM(de.cantidad * de.preciounidad) TOTAL
        
    FROM cliente CL
    LEFT JOIN pedido PE ON pe.codcliente=cl.codcliente
    LEFT JOIN detalle_pedido DE ON de.codpedido=pe.codpedido
    GROUP BY cl.codcliente,(CL.nombrecontacto|| ' ' || CL.apellidocontacto), CL.telefono, CL.ciudad, CL.pais,
        pe.codpedido, pe.fechapedido, pe.fechaprevista, pe.fechaentrega;
        
CREATE OR REPLACE VIEW CLIENTE_PEDIDO_02_VIEW AS
SELECT cl.codcliente cod_cl,(CL.nombrecontacto|| ' ' || CL.apellidocontacto) NOMBRE, CL.telefono TEL, CL.ciudad CIU, CL.pais PAIS,
        pe.codpedido COD_PED, pe.fechapedido FECHA_PEDIDO, pe.fechaprevista FECHA_ESPERADA, 
        pe.fechaentrega FECHA_ENTREGA, SUM(de.cantidad * de.preciounidad) TOTAL
        
    FROM cliente CL
    JOIN pedido PE ON pe.codcliente=cl.codcliente
    JOIN detalle_pedido DE ON de.codpedido=pe.codpedido
    GROUP BY cl.codcliente,(CL.nombrecontacto|| ' ' || CL.apellidocontacto), CL.telefono, CL.ciudad, CL.pais,
        pe.codpedido, pe.fechapedido, pe.fechaprevista, pe.fechaentrega;

/*3. Utiliza las vistas que has creado en los pasos anteriores para devolver un listado de los
clientes de la ciudad de Madrid que han realizado pagos.*/
SELECT CLPA.* 
    FROM cliente_pago_01_null_view CLPA
    WHERE clpa.ciu LIKE 'Madrid'
    and clpa.idtrans is not null;
    
SELECT CLPA.* 
    FROM cliente_pago_01_view CLPA
    WHERE clpa.ciu LIKE 'Madrid';

/*4. Utiliza las vistas que has creado en los pasos anteriores para devolver un listado de los
clientes que todavía no han recibido su pedido.*/
SELECT *
    FROM cliente_pedido_02_null_view CLPE
    WHERE clpe.fecha_entrega IS NULL
    and clpe.cod_ped is not null;
    
SELECT *
    FROM cliente_pedido_02_view CLPE
    WHERE clpe.fecha_entrega IS NULL;

/*5. Utiliza las vistas que has creado en los pasos anteriores para calcular el número de pedidos
que ha realizado cada uno de los clientes.*/
SELECT clpe.nombre, COUNT(1) NUM_PEDIDOS
    FROM cliente_pedido_02_null_view CLPE
    where clpe.cod_ped is not null
    GROUP BY clpe.nombre;
    
SELECT clpe.nombre, COUNT(1) NUM_PEDIDOS
    FROM cliente_pedido_02_view CLPE
    GROUP BY clpe.nombre;

/*6. Utiliza las vistas que has creado en los pasos anteriores para calcular el valor del pedido
máximo y mínimo que ha realizado cada cliente.*/
SELECT clpe.nombre, MAX(clpa.importe), MIN(clpa.importe)
    FROM cliente_pedido_02_view CLPE
    JOIN cliente_pago_01_view CLPA ON clpe.cod_cl=clpa.cod_cl
    GROUP BY clpe.nombre;
