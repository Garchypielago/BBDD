INSERT INTO tienda (ciudad,pais,region,cp, telefono, codtienda, lineadireccion1, lineadireccion2)
VALUES ('Madrid', 'España', 'Madrid', '28001', '666666', 'MAD-CLA', 'CALLE 1', 'CALLE 2');
//PARA METER DATOS DE UN NUEVO INSERT EN UN ORDEN CONCRETO

INSERT INTO tienda VALUES ('MAD-CLA2', 'Madrid', 'España', 'Madrid', '28890', '999999', 'CALLE01' , 'CALLE02');
//PARA METER DATOS DE UN INSERT PERO EN EL ORDEN QUE LO TENGA LA TABLA

//TAMBIEN HAY SUBSELEC AL HACER INSERT

SELECT * FROM TIENDA;
//COMPRUEBA

UPDATE tienda SET ciudad='Lisboa', pais='Portugal' WHERE codtienda='MAD-CLA2';
//ACTUALIZA VALORES PARA LOS INSERT CON UNA CLAUSULA

SELECT * FROM TIENDA;
//COMPRUEBA

SELECT DISTINCT em.codtienda
    FROM cliente CL
    JOIN empleado EM ON em.codempleado=cl.codempleadoventas
    WHERE UPPER(cl.pais) LIKE 'SPAIN';
    
UPDATE tienda SET tienda.cp='00000' WHERE codtienda IN (SELECT DISTINCT em.codtienda
                                                                FROM cliente CL
                                                                JOIN empleado EM ON em.codempleado=cl.codempleadoventas
                                                                WHERE UPPER(cl.pais) LIKE 'SPAIN');
//UPDATE A VALORES CON UNA CLAUSULA CON UNA SUBSELECT

SELECT * FROM TIENDA WHERE CP='00000';
//COMPRUEBA

UPDATE TIENDA SET PAIS='USA' WHERE PAIS='EEUU';
//YA NO HBARA TIENDAS EEUU

SELECT * FROM TIENDA WHERE PAIS='USA';
//COMPRUEBA

DELETE FROM tienda WHERE codtienda LIKE 'MAD-CL%';
//ELIMINA TABLAS CON UNA CLAUSULA, FUNCIONARA CON SUBSELECT IGUAL
//TRUNCATE BORRA TODO

SELECT * FROM TIENDA;
//COMPRUEBA