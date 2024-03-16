/*1. Inserta una nueva tienda en ‘Tres Cantos’*/
SELECT * FROM TIENDA;
INSERT INTO TIENDA VALUES ('TRS-ES', 'Tres Cantos', 'España', 'Madrid', 28890, '+34 918867555', 'Avenida Brasil, 30', NULL );

/*2. Inserta un empleado para la tienda de ‘Tres Cantos’ que sea representante de ventas.*/
SELECT * FROM empleado;
INSERT INTO empleado VALUES (90,'Alejandro', 'Garcia', 'Sanchez', 4231, 'EJEMPLO@VIVERO.ES', 'TRS-ES', 3, 'Representante de ventas');

/*3. Inserta un cliente que tenga como empleado de ventas al empleado que hemos creado
en el punto anterior.*/
SELECT * FROM cliente;
INSERT INTO cliente VALUES (90, 'PEREZA', 'Mucho', 'Perezote', '555011718', '555011717', 'PEREZA, 12', NULL, 'Tres Cantos', 'Madrid', 'España', 28890, 90, 121212 );

/*4. Inserta un pedido para el cliente que acabamos de crear, que contenga al menos dos
productos diferentes.*/
SELECT * FROM pedido;
INSERT INTO PEDIDO VALUES (190, SYSDATE, SYSDATE, SYSDATE, 'Entregado', NULL, 90);

SELECT * FROM detalle_pedido;
INSERT INTO detalle_pedido VALUES (190, 'FR-11', 90, 100, 1 );
INSERT INTO detalle_pedido VALUES (190, 'FR-48', 90, 59, 2 );

/*5. Actualiza el código del cliente que hemos creado en el punto anterior y averigua si hubo
cambios en las tablas relacionadas.*/
UPDATE CLIENTE SET codcliente=100 WHERE codcliente=90;
//NO DEJA FK

/*6. Borra el cliente y averigua si hubo cambios en las tablas relacionadas.*/
DELETE CLIENTE WHERE codcliente=90;
//NO DEJA FK

/*7. Elimina los clientes que no hayan realizado ningún pedido.*/
SAVEPOINT ANTES7;
SELECT * FROM CLIENTE; // 37

DELETE CLIENTE CL 
    WHERE cl.codcliente NOT IN (SELECT pe.codcliente
                                    FROM PEDIDO PE
                                    GROUP BY pe.codcliente);//20
                                
/*8. Incrementa en un 25% el precio de los productos que no tengan pedidos.*/
SELECT * FROM producto; //276
UPDATE PRODUCTO PR SET pr.precioventa=(pr.precioventa*1.25) 
    WHERE pr.codproducto NOT IN (SELECT DISTINCT de.codproducto
                                    FROM detalle_pedido DE); //129 FILAS ACT

/*9. Borra los pagos del cliente con menor límite de crédito.*/
SELECT * FROM CLIENTE; //20

DELETE pago PA
    WHERE pa.codcliente = (SELECT cl2.codcliente
                                FROM cliente CL2
                                WHERE cl2.limitecredito = (SELECT MIN(cl.limitecredito)
                                                                FROM cliente CL));

/*10. Modifica la tabla detalle_pedido para insertar un campo nume?rico llamado IVA.
Mediante una transaccio?n, establece el valor de ese campo a 18 para aquellos registros
cuyo pedido tenga fecha a partir de Enero de 2019. Después, con otra sentencia,
actualiza el resto de pedidos estableciendo el IVA al 21.*/
ALTER TABLE DETALLE_PEDIDO ADD IVA NUMBER(4,2) DEFAULT 18 NOT NULL;

SELECT * FROM detalle_pedido;
SELECT * FROM pedido;

UPDATE detalle_pedido DE SET IVA=21 
WHERE de.codpedido IN (SELECT pe.codpedido
                            FROM pedido PE
                            WHERE ((pe.fechapedido)-TO_DATE('01-01-2019', 'MM-DD-YYYY'))<0);//12 FILAS ACT
                            

/*11. Modifica la tabla detalle_pedido para incorporar un campo nume?rico llamado
total_linea y actualiza todos sus registros para calcular su valor con la fo?rmula:
total_linea = precio_unidad*cantidad * (1 + (IVA/100));*/
ALTER TABLE DETALLE_PEDIDO ADD TOTAL_LINEA NUMBER;

UPDATE detalle_pedido DE SET de.total_linea=(de.preciounidad*de.cantidad*(1+(de.iva/100)));//320 FILAS ACT

