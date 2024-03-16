--SET SERVEROUTPUT ON;

/*1. Crear un bloque PL que visualice el país de una tienda que se pida al usuario por
teclado.*/
--SELECT * FROM TIENDA; 'TRS-ES'

DECLARE 
    V_TIENDA TIENDA.CODTIENDA%TYPE := &CODIGO;
    V_LOC TIENDA.PAIS%TYPE;
BEGIN
    SELECT TD.pais
        INTO V_LOC
        FROM tienda TD
        WHERE TD.codtienda=V_TIENDA;
        
        dbms_output.PUT_LINE('PAIS=' || V_LOC);
END;

/*2. Dado un tipo de producto introducido por teclado, obtener el número de productos
que hay asociados a este tipo de producto.*/
SELECT * FROM producto; --'FR-41'

DECLARE
    V_STOCK PRODUCTO.STOCK%TYPE;
BEGIN
    SELECT PR.STOCK
        INTO V_STOCK
        FROM producto PR
        WHERE PR.codproducto = &COD;

    DBMS_OUTPUT.PUT_LINE('STOCK='||v_stock);
END;

/*3. Incrementar el precio de venta en 5€ a todos productos para los que su stock sea
menor de 25 unidades.*/
SELECT * FROM producto WHERE STOCK<25; --7,5

UPDATE PRODUCTO SET precioventa= (precioventa+5) WHERE STOCK<25; --12,5
    
/*4. Haz un bloque anónimo que asigne a una variable declarada el código de un cliente y
cuente el número de pedidos del cliente.*/
SELECT * FROM CLIENTE; --1
SELECT COUNT (1)
    FROM PEDIDO PE
    JOIN CLIENTE CI ON ci.codcliente=pe.codcliente
    WHERE ci.codcliente=1; --11

DECLARE
    V_CODCLIENTE CLIENTE.CODCLIENTE%TYPE := 1;
    V_PEDIDOS NUMBER:=0;
BEGIN
    SELECT COUNT (1)
    INTO V_PEDIDOS
    FROM PEDIDO PE
    WHERE pe.codcliente= V_CODCLIENTE;

    DBMS_OUTPUT.PUT_LINE('Nº PEDIDOS='||V_PEDIDOS);
END;

/*5. Pide dos tiendas por teclado e indica cuál de las dos tiendas ingresó más dinero por los
pedidos hechos por sus clientes.*/
SELECT * FROM tienda; --'TRS-ES' = 0 

SELECT td.codtienda ,SUM(pa.importetotal)
        FROM TIENDA TD
        LEFT JOIN empleado EM ON em.codtienda=td.codtienda
        LEFT JOIN cliente CL ON cl.codempleadoventas=em.codempleado
        LEFT JOIN pago PA ON pa.codcliente=cl.codcliente
        GROUP BY td.codtienda;

DECLARE
    V_TIENDA01 TIENDA.CODTIENDA%TYPE := 'BCN-ES'; --MENOR
    V_TIENDA02 TIENDA.CODTIENDA%TYPE := 'MAD-ES'; --MAYOR
    V_ING01 NUMBER:=0;
    V_ING02 NUMBER:=0;
BEGIN
    SELECT NVL(SUM(pa.importetotal),0)
        INTO V_ING01
        FROM TIENDA TD
        LEFT JOIN empleado EM ON em.codtienda=td.codtienda
        LEFT JOIN cliente CL ON cl.codempleadoventas=em.codempleado
        LEFT JOIN pago PA ON pa.codcliente=cl.codcliente
        WHERE td.codtienda=v_tienda01;
        
    SELECT NVL(SUM(pa.importetotal),0)
        INTO V_ING02
        FROM TIENDA TD
        LEFT JOIN empleado EM ON em.codtienda=td.codtienda
        LEFT JOIN cliente CL ON cl.codempleadoventas=em.codempleado
        LEFT JOIN pago PA ON pa.codcliente=cl.codcliente
        WHERE td.codtienda=v_tienda02;
        
    IF(V_ING01>V_ING02) THEN
        DBMS_OUTPUT.PUT_LINE('TIENDA '||V_TIENDA01||' INGRESA MAS');
    ELSIF (V_ING02>V_ING01) THEN
        DBMS_OUTPUT.PUT_LINE('TIENDA '||V_TIENDA02||' INGRESA MAS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INGRESAN LO MISMO');
    END IF;
    
END;

/*6. Para un producto introducido por teclado calcula y muestra si su margen de beneficio
es alto (mayor o igual que el 30%), normal (entre el 30% y el 20%) o bajo (menor o
igual que el 20%).
    1. El margen se calculará como ( (precio de venta - precio proveedor)/precio
    proveedor) *100 siempre el que precio proveedor sea distinto de 0. Si es 0
    pondremos SIN DATOS.*/
SELECT * FROM PRODUCTO ORDER BY 1;


DECLARE 
    V_PROD PRODUCTO%ROWTYPE;
    V_BENEFICIO NUMBER:=0;
BEGIN
    --'AR-001';--'FR-41';--'FR-1'
    SELECT *
    INTO V_PROD
        FROM PRODUCTO PR
        WHERE pr.codproducto=&COD;
        
    SELECT (pr.precioventa - pr.precioproveedor)*100 BENEFICIO
        INTO V_BENEFICIO
        FROM producto PR
        WHERE pr.codproducto=V_PROD.CODPRODUCTO;
        
        IF V_PROD.PRECIOPROVEEDOR=0 THEN
            DBMS_OUTPUT.PUT_LINE('BENEFICIO TOTAL');
        ELSIF v_beneficio/V_PROD.PRECIOPROVEEDOR>=30 THEN
            DBMS_OUTPUT.PUT_LINE('BENEFICIO ALTO, DEL ' || ROUND(v_beneficio/V_PROD.PRECIOPROVEEDOR,2) || '%');
        ELSIF v_beneficio/V_PROD.PRECIOPROVEEDOR>20 THEN
            DBMS_OUTPUT.PUT_LINE('BENEFICIO MEDIO, DEL ' || ROUND(v_beneficio/V_PROD.PRECIOPROVEEDOR,2) || '%');
        ELSE
            DBMS_OUTPUT.PUT_LINE('BENEFICIO BAJO, DEL ' || ROUND(v_beneficio/V_PROD.PRECIOPROVEEDOR,2) || '%');
        END IF;
END;


/*7. Para un cliente que se pase por teclado indica si su ciudad coincide con la de la tienda
en la que trabaja el empleado que tiene asignado o no.*/
SELECT * FROM CLIENTE; --SAN FRNACISCO --19
SELECT * FROM EMPLEADO WHERE empleado.codempleado=19; 
SELECT * FROM tienda WHERE tienda.codtienda='SFC-USA';

DECLARE
    V_CLIENTE CLIENTE%ROWTYPE;
    V_TIENDACIU TIENDA.CIUDAD%TYPE;
BEGIN
    SELECT *
    INTO v_cliente
        FROM CLIENTE CL
        WHERE CL.CODCLIENTE=1;
    
    SELECT td.ciudad
    INTO V_TIENDACIU
        FROM TIENDA TD
        JOIN EMPLEADO EM ON em.codtienda=td.codtienda
        JOIN CLIENTE CL ON cl.codempleadoventas=em.codempleado
        WHERE cl.codcliente=V_CLIENTE.CODCLIENTE;
        
        IF UPPER(V_CLIENTE.CIUDAD) LIKE UPPER(V_TIENDACIU) THEN 
            DBMS_OUTPUT.PUT_LINE('COINCIDEN Y ES: ' || V_TIENDACIU);
        ELSE
            DBMS_OUTPUT.PUT_LINE('NO COINCIDEN');
        END IF;
END;

/*8. Renombra el tipo de producto Utensilios y llamalo Herramientas. Para ello tendrás que
hacer los siguientes pasos
    1. Inserta un nuevo tipo de producto llamado Herramientas. El resto de campos deben
    ser los que tenga actualmente el tipo de Utensilios.
    2. Actualiza todos los productos que tuvieran como tipo Utensilios para que tengan el
    nuevo tipo de Herramientas
    3. Borra el tipo de producto Utensilios.
    4. Al final de todo, haz commit.*/
SELECT * 
    FROM PRODUCTO PR
    WHERE pr.tipoproducto='Utensilios';
    
SELECT *
    FROM tipoproducto
    WHERE tipo='Utensilios';
--11679	Sierra de Poda 400MM	Utensilios	0,258	HiperGarden Tools	Gracias a la poda se consigue manipular un poco la naturaleza, dándole la forma que más nos guste. Este trabajo básico de jardinería también facilita que las plantas crezcan de un modo más equilibrado, y que las flores y los frutos vuelvan cada año con regularidad. Lo mejor es dar forma cuando los ejemplares son jóvenes, de modo que exijan pocos cuidados cuando sean adultos. Además de saber cuándo y cómo hay que podar, tener unas Utensilios adecuadas para esta labor es también de vital importancia.	15	19	11
--21636	Pala	Utensilios	0,156	HiperGarden Tools	Palas de acero con cresta de corte en la punta para cortar bien el terreno. Buena penetración en tierras muy compactas.	15	19	13
--22225	Rastrillo de Jardín	Utensilios	1,064	HiperGarden Tools	Fabuloso rastillo que le ayudará a eliminar piedras, hojas, ramas y otros elementos incómodos en su jardín.	15	17	11
--30310	Azadón	Utensilios	0,168	HiperGarden Tools	Longitud:24cm. Herramienta fabricada en acero y pintura epoxi,alargando su durabilidad y preveniendo la corrosión.Diseño pensado para el ahorro de trabajo.	15	17	11
SAVEPOINT ANTES_DEL_8;

DECLARE
    V_TIPOHERRA TIPOPRODUCTO%ROWTYPE;

BEGIN
    /*1. Inserta un nuevo tipo de producto llamado Herramientas. El resto de campos deben
    ser los que tenga actualmente el tipo de Utensilios.*/
    SELECT *
    INTO V_TIPOHERRA 
        FROM tipoproducto TP
        WHERE tp.tipo='Utensilios';
        
    INSERT INTO tipoproducto VALUES ('Herramientas',V_TIPOHERRA.DESCRIPCION_TEXTO,V_TIPOHERRA.DESCRIPCION_HTML,V_TIPOHERRA.IMAGEN);
    
    /*2. Actualiza todos los productos que tuvieran como tipo Utensilios para que tengan el
    nuevo tipo de Herramientas*/
    UPDATE producto PR SET pr.tipoproducto='Herramientas' WHERE pr.tipoproducto='Utensilios';
    
    /*3. Borra el tipo de producto Utensilios.*/
    DELETE FROM tipoproducto TP WHERE tp.tipo='Utensilios';
    
    /*4. Al final de todo, haz commit.*/
    COMMIT;
END;

SELECT * 
    FROM PRODUCTO PR
    WHERE pr.tipoproducto='Herramientas';
    
SELECT *
    FROM tipoproducto
    WHERE tipo='Herramientas';

