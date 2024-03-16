/*1*/
SELECT *
    FROM producto PR 
    WHERE PR.precioventa>10
    AND PR.stock<400;

/*2*/
SELECT PR.NOMBRE, SUM(de.cantidad) CANTIDAD, COUNT(de.codpedido) PEDIDOS
    FROM PRODUCTO PR
    LEFT JOIN detalle_pedido DE ON de.codproducto = PR.CODPRODUCTO
    GROUP BY PR.NOMBRE
    ORDER BY 2 DESC;

/*3*/
SELECT (em.nombre|| ' '||em.apellido1|| ' '||em.apellido2), (CL.nombreCLIENTE|| ' '||CL.apellidoCONTACTO), CL.TELEFONO, CL.TELEFONO2
    FROM empleado EM
    LEFT JOIN CLIENTE CL ON CL.CODEMPLEADOVENTAS=em.codempleado
    ORDER BY 1;
    
/*4*/
SELECT CL.NOMBRECLIENTE, pe.codpedido, (pe.fechaentrega - pe.fechaprevista) DIAS_RETRASO
    FROM CLIENTE CL
    JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
    WHERE TO_CHAR(pe.fechapedido,'YYYY')='2020'
    AND (pe.fechaentrega - pe.fechaprevista)>0;

/*5*/
SELECT CL.NOMBRECLIENTE, 'SI' PEDIDOS
    FROM cliente CL
    JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
UNION
SELECT CL.NOMBRECLIENTE, 'NO' PEDIDOS
    FROM cliente CL
    LEFT JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
    WHERE pe.codcliente IS NULL
ORDER BY 1;

/*6*/
SELECT DISTINCT CL.PAIS, COUNT(de.codproducto) PRODUCTOS_DIFERENTES, SUM(de.cantidad*de.preciounidad) INGRESOS
    FROM CLIENTE CL
    JOIN PEDIDO PE ON pe.codcliente=cl.codcliente
    JOIN DETALLE_PEDIDO DE ON de.codpedido=pe.codpedido
    WHERE CL.PAIS IN (SELECT CL2.PAIS
                        FROM CLIENTE CL2
                        GROUP BY CL2.PAIS
                        HAVING COUNT(1)>1)
    GROUP BY cl.pais;

/*7*/
SELECT pr.codproducto, PR.NOMBRE, (PR.PRECIOVENTA - PR.PRECIOPROVEEDOR) BENEFICIO
    FROM PRODUCTO PR
    WHERE (PR.PRECIOVENTA - PR.PRECIOPROVEEDOR) > 5;

/*8*/
SELECT CL.PAIS, CL.CIUDAD, SUM(PA.IMPORTETOTAL)
    FROM CLIENTE CL
    JOIN PAGO PA ON pa.codcliente=cl.codcliente
    GROUP BY CL.PAIS, CL.CIUDAD
    ORDER BY 1 ASC, 3 DESC;

/*9*/
SELECT tp.tipo, tp.descripcion_texto, pr.codproducto, pr.nombre
    FROM tipoproducto TP
    JOIN producto PR ON pr.tipoproducto=tp.tipo
    WHERE pr.precioventa = (SELECT MAX(pr2.precioventa)
                                FROM producto PR2
                                WHERE pr2.tipoproducto=tp.tipo);

/*10*/                     
SELECT TO_CHAR(pe.fechapedido,'YYYY'), SUM(DE.PRECIOUNIDAD * DE.CANTIDAD) TOTAL
    FROM pedido PE
    JOIN detalle_pedido DE ON de.codpedido=pe.codpedido
    JOIN PRODUCTO PR ON PR.CODPRODUCTO=de.codproducto
    WHERE PR.TIPOPRODUCTO NOT LIKE 'Aromáticas'
    GROUP BY pe.fechapedido
    HAVING SUM(DE.PRECIOUNIDAD * DE.CANTIDAD) >71000;

/*11*/
SELECT DISTINCT ti.*
    FROM TIENDA TI
MINUS
SELECT DISTINCT ti.*
    FROM TIENDA TI
    JOIN empleado EM ON em.codtienda=ti.codtienda
    JOIN cliente CL ON cl.codempleadoventas=em.codempleado
    JOIN pedido PE ON pe.codcliente=cl.codcliente
    JOIN detalle_pedido DE ON de.codpedido=pe.codpedido
    JOIN producto PR ON pr.codproducto=de.codproducto
    WHERE PR.TIPOPRODUCTO LIKE 'Frutales';
    
/*12*/
SELECT EM.CODEMPLEADO, (em.nombre|| ' '||em.apellido1|| ' '||em.apellido2), COUNT(cl.codcliente)
    FROM empleado EM
    JOIN tienda TI ON ti.codtienda=em.codtienda /*TODOS TRABJAN EN TIENDAS*/
    JOIN cliente CL ON cl.codempleadoventas=em.codempleado
    JOIN PAGO PA ON pa.codcliente=cl.codcliente
    GROUP BY EM.CODEMPLEADO, (em.nombre|| ' '||em.apellido1|| ' '||em.apellido2)
    HAVING AVG(PA.IMPORTETOTAL) > (SELECT AVG(PA2.IMPORTETOTAL)
                                    FROM pago PA2);



    
    
    




