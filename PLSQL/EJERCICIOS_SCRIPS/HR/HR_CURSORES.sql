SET SERVEROUTPUT ON;
/*1. Diseñar un bloque PL que muestre el nombre del departamento y el número de
trabajadores que tiene cada uno.*/
DECLARE 
    CURSOR DEP IS (SELECT de.department_name NOM, COUNT(em.employee_id) CON
                        FROM DEPARTMENTS DE
                        LEFT JOIN EMPLOYEES EM ON em.department_id=de.department_id
                        GROUP BY de.department_name);
BEGIN
    FOR I IN DEP LOOP
        DBMS_OUTPUT.PUT_LINE('ID de departamento: '||I.NOM);
        DBMS_OUTPUT.PUT_LINE('  Empleados: '||I.CON);
    END LOOP;
END;

/*2. Construye un bloque de Pl/sql que dado un país me saque por consola (dbms_output)
el nombre y apellidos y fecha de incorporación de los empleados que trabajan en ese
país. Los empleados irán ordenados alfabéticamente por apellido.*/
DECLARE
    CURSOR PAIS (V_PAISID COUNTRIES.COUNTRY_ID%type) is 
        (SELECT em.first_name NOM, em.last_name APE, em.hire_date FEC
            FROM employees EM
            JOIN departments DE ON de.department_id=em.department_id
            JOIN locations LO ON lo.location_id=de.location_id
            WHERE lo.country_id=V_PAISID
            )ORDER BY 2;
    
    V_PAIS COUNTRIES%ROWTYPE;
BEGIN
    SELECT *
    INTO V_PAIS
        FROM COUNTRIES CO
        WHERE co.country_name=&PAIS;
        DBMS_OUTPUT.PUT_LINE('Pais: '||V_PAIS.COUNTRY_NAME);
    
    FOR I IN PAIS(V_PAIS.COUNTRY_ID) LOOP
        DBMS_OUTPUT.PUT_LINE('   '||I.APE||', '||I.NOM||'       '||I.FEC);
    END LOOP;

END;

SELECT * FROM COUNTRIES; --'United Kingdom'

/*3. Codificar un programa que visualice los dos empleados que ganan menos de cada
oficio.*/
DECLARE 
    CURSOR DEP IS (SELECT de.department_name NOM, de.department_id ID
                        FROM DEPARTMENTS DE);
                        
    CURSOR EMP (V_DEP DEPARTMENTS.DEPARTMENT_ID%TYPE) IS 
        SELECT em.first_name NOM, em.last_name APE, em.salary SAL, em.department_id DEP
            FROM employees EM
            WHERE em.department_id=V_DEP
            ORDER BY em.salary ASC;
    
    LN_CONTADOR NUMBER;
BEGIN
    FOR I IN DEP LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre de departamento: '||I.ID);
        LN_CONTADOR:=0;
        FOR J IN EMP(I.ID) LOOP
            DBMS_OUTPUT.PUT_LINE('   Empleado: '||J.NOM||'   '||J.APE);
            LN_CONTADOR:=LN_CONTADOR+1;
            IF LN_CONTADOR=2 THEN EXIT;
            END IF;
        END LOOP;
    END LOOP;
END;

/*4. Construye un bloque de pl/sql que me saque por consola la siguiente información:
?   Trabajo (código y descripción)
?   Sueldo medio de los empleados que tienen ese trabajo
?   Por cada trabajo debajo aparecerán ordenados por salario descendente:
        ? nombre y apellidos del empleado
        ? Salario
ITPROG - PROGRAMADOR IT - 20.000
Juan Perez - 18.000
Mario Martínez - 17.500
Ana Fernández - 16.000
…
SALES - DEPARTAMENTO DE VENTAS -10.000*/

DECLARE
    
BEGIN
    
END;

/*5. Necesitamos obtener una salida en que se indique por cada región el número de
trabajadores y su salario medio y a continuación de cada región todos los países
pertenecientes a esa región con su número de trabajadores y salario medio.*/