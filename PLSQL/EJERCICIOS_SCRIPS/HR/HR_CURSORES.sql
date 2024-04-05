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
    CURSOR TRABAJO IS (SELECT jo.job_id IDS, jo.job_title NOM
                            FROM JOBS JO);
    
    CURSOR SUELDOMEDIO (V_JOBID JOBS.JOB_ID%TYPE) IS 
        (SELECT AVG(em.salary) AVSAL
            FROM employees EM
            WHERE em.job_id = V_JOBID);
            
    CURSOR EMPLEADOS (V_JOBID JOBS.JOB_ID%TYPE) IS 
        (SELECT em.first_name NOM, em.last_name APE , em.salary SAL
            FROM employees EM
            WHERE em.job_id = V_JOBID)
        ORDER BY 3 DESC;
BEGIN
    
    FOR I IN TRABAJO LOOP
        FOR J IN SUELDOMEDIO(I.IDS) LOOP
            DBMS_OUTPUT.PUT_LINE(I.IDS||' - '||I.NOM||' - '||J.AVSAL);
            
            FOR H IN EMPLEADOS(I.IDS) LOOP
                DBMS_OUTPUT.PUT_LINE('  '||H.NOM||' '||H.APE||' - '||H.SAL);
            
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
    END LOOP;

END;

/*5. Necesitamos obtener una salida en que se indique por cada región el número de
trabajadores y su salario medio y a continuación de cada región todos los países
pertenecientes a esa región con su número de trabajadores y salario medio.*/

DECLARE
    CURSOR REGION IS (SELECT re.region_id ID, re.region_name NOM
                        FROM REGIONS RE );
                        
    CURSOR EMP_RE (V_REGION REGIONS.REGION_ID%TYPE) IS 
        (SELECT COUNT(1) CONT , NVL(ROUND(AVG(em.salary),2), 0) AVSAL
            FROM employees EM
            JOIN DEPARTMENTS DE ON DE.DEPARTMENT_ID = EM.DEPARTMENT_ID
            JOIN LOCATIONS LO ON LO.LOCATION_ID = DE.LOCATION_ID
            JOIN COUNTRIES CO ON CO.COUNTRY_ID = LO.COUNTRY_ID
            WHERE CO.REGION_ID = V_REGION );
            
    CURSOR PAIS_RE (V_REGION REGIONS.REGION_ID%TYPE) IS 
        (SELECT co.country_id ID, co.country_name NOM
            FROM countries CO
            WHERE co.region_id = V_REGION );
    
    CURSOR EMP_PA (V_PAIS COUNTRIES.COUNTRY_ID%TYPE) IS 
        (SELECT COUNT(1) CONT , NVL(ROUND(AVG(em.salary),2), 0) AVSAL
            FROM employees EM
            JOIN DEPARTMENTS DE ON DE.DEPARTMENT_ID = EM.DEPARTMENT_ID
            JOIN LOCATIONS LO ON LO.LOCATION_ID = DE.LOCATION_ID
            WHERE LO.COUNTRY_ID = V_PAIS );
    
BEGIN
    FOR I IN REGION LOOP
        FOR J IN EMP_RE(I.ID) LOOP
            DBMS_OUTPUT.PUT_LINE(I.ID||' - '||I.NOM||' - '||J.CONT||'EMP'||' - '||J.AVSAL||'€');
            
            FOR H IN PAIS_RE(I.ID) LOOP
                FOR K IN EMP_PA(H.ID) LOOP
                    DBMS_OUTPUT.PUT_LINE('  '||H.ID||' - '||H.NOM||' - '||K.CONT||'EMP'||' - '||K.AVSAL||'€');
                END LOOP;
            END LOOP;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('  ');
    END LOOP;
END;









