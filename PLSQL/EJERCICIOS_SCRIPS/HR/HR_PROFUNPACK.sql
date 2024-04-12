SET SERVEROUTPUT ON;
/*1. Codificar un procedimiento que permita borrar un empleado cuyo número se pasa en
la llamada.*/
CREATE OR REPLACE PROCEDURE BORRAR_EMP_IDEMP
    (V_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE
    ) IS
BEGIN
    DELETE employees EM WHERE EM.employee_id = V_ID;
END BORRAR_EMP_IDEMP;

SELECT * FROM EMPLOYEES;
CALL borrar_emp_idemp(199); --BIEN

/*2. Escribir un procedimiento que modifique la descripción de un departamento. El
procedimiento recibirá como parámetros el número de departamento y la nueva
descripción.*/
CREATE OR REPLACE PROCEDURE MODIFICA_DEP_DES
    (V_DEPID IN DEPARTMENTS.DEPARTMENT_ID%TYPE,
    V_DEPDES IN DEPARTMENTS.DEPARTMENT_NAME%TYPE
    ) IS
BEGIN
    UPDATE departments DE SET de.department_name=V_DEPDES WHERE de.department_id=V_DEPID;
END MODIFICA_DEP_DES;

SELECT * FROM departments;
CALL modifica_dep_des(220,'NOC'); --BIEN


/*3. Haz un procedimiento donde visualicemos los 2 departamentos más caros y el total de
dinero destinado en salarios por esos departamentos (se considera como
departamento más caro aquel cuya suma de sueldos de sus empleados sea la más
alta).*/
CREATE OR REPLACE PROCEDURE MAS_CAROS 
    (V_CANT IN OUT NUMBER
    ) IS
    CURSOR CARO IS (SELECT de.department_id ID, de.department_namE NOM, ROUND(SUM(em.salary),2) SUMA
                        FROM departments DE
                        JOIN employees EM ON de.department_id=em.department_id
                        GROUP BY de.department_id, de.department_name
                        ) ORDER BY 3 DESC;
BEGIN
    FOR I IN CARO LOOP
        DBMS_OUTPUT.PUT_LINE('ID: '||I.ID||' - Nombre: '||I.NOM||' - Total: '||I.SUMA);
        V_CANT := V_CANT-1;
        IF V_CANT=0 THEN EXIT;
        END IF;
    END LOOP;
END MAS_CAROS;

DECLARE
    CONT NUMBER:=&CONTADOR;
BEGIN
    MAS_CAROS(CONT);
END;

/*4. Haz una función donde se nos muestre el IRPF de un empleado. Si gana por debajo de
4000 devolverá 10% de su salario y si gana igual o más devolverá 15% de su salario.*/
CREATE OR REPLACE FUNCTION IRPF 
    (V_EMP EMPLOYEES.EMPLOYEE_ID%TYPE
    )RETURN NUMBER IS
    V_IRPF EMPLOYEES.SALARY%TYPE:=-1;
BEGIN
    SELECT em.salary
    INTO V_IRPF
        FROM EMPLOYEES EM
        WHERE em.employee_id=V_EMP;

    IF V_IRPF<4000  THEN
        RETURN V_IRPF*0.1;
    ELSE 
        RETURN V_IRPF*0.15;
    END IF;
END IRPF;

SELECT * FROM EMPLOYEES;

DECLARE
    EMP_ID NUMBER:=&ID;
    V_IRPF NUMBER;
BEGIN
    V_IRPF:=irpf(emp_id);
    dbms_output.put_line('IRPF DE '||EMP_ID||': '||V_IRPF||'€');
END;

SELECT IRPF(EM.EMPLOYEE_ID), EM.* 
    FROM EMPLOYEES EM;

/*5. Escribir un programa que incremente el salario de los empleados de un determinado
departamento que se pasará como primer parámetro. El incremento será una cantidad
en euros que se pasará como segundo parámetro en la llamada. El programa deberá
informar del número de filas afectadas por la actualización.*/
CREATE OR REPLACE FUNCTION SUBIDA 
    (V_DEP EMPLOYEES.DEPARTMENT_ID%TYPE,
    V_SUBIDA EMPLOYEES.SALARY%TYPE
    )RETURN NUMBER IS
    V_ACTU NUMBER:=0;
BEGIN
    UPDATE employees EM SET em.salary=em.salary+V_SUBIDA WHERE em.department_id=V_DEP;
    
    SELECT COUNT(em.employee_id)
    INTO V_ACTU
        FROM EMPLOYEES EM
        WHERE em.department_id=V_DEP;
    
    RETURN V_ACTU;
END SUBIDA;

SELECT * FROM departments;
SELECT * FROM EMPLOYEES EM WHERE em.department_id=80;

DECLARE
    DEP_ID NUMBER:=&DEP;
    V_SUB NUMBER:=&DINERO;
    V_ACTU NUMBER;
BEGIN
    V_ACTU:=SUBIDA(DEP_id, V_SUB);
    dbms_output.put_line('ACTUALIZADAS: '||V_ACTU);
END;

CREATE OR REPLACE PROCEDURE SUBIDA_ACT 
    (V_DEP EMPLOYEES.DEPARTMENT_ID%TYPE,
    V_SUBIDA EMPLOYEES.SALARY%TYPE
    ) IS
BEGIN
    UPDATE employees EM SET em.salary=em.salary+V_SUBIDA WHERE em.department_id=V_DEP;
    dbms_output.put_line('ACTUALIZADAS: '||SQL%ROWCOUNT);

END SUBIDA_ACT;

SELECT * FROM departments;
SELECT * FROM EMPLOYEES EM WHERE em.department_id=80;

CALL subida_act(80,5);

/*6. Haz una función que reciba el id de empleado y devuelva el número de empleados que
tiene a su cargo.*/
CREATE OR REPLACE FUNCTION JEFE 
    (V_MAN EMPLOYEES.MANAGER_ID%TYPE
    )RETURN NUMBER IS
    V_EMPS NUMBER:=0;
    
    CURSOR C1 (V_JEFE EMPLOYEES.MANAGER_ID%TYPE) IS
        (SELECT em.employee_id ID
            FROM EMPLOYEES EM
            WHERE em.manager_id = V_JEFE
            );
BEGIN
    FOR I IN C1(V_MAN) LOOP
        V_EMPS:=V_EMPS+1;
    END LOOP;
        
    RETURN V_EMPS;
END JEFE;

SELECT * FROM EMPLOYEES WHERE MANAGER_ID = 100;

DECLARE
    V_MAN EMPLOYEES.MANAGER_ID%TYPE :=&ID;
    V_NUM NUMBER;
BEGIN
    V_NUM:=JEFE(V_MAN);
    dbms_output.put_line('A CARGO: '||V_NUM);
END;

/*7. Haz un procedimiento que reciba como parámetro un código de empleado y Modifica
el salario de un empleado en función del número de empleados que tiene a su cargo:
    ? si no tiene ningún empleado a su cargo subirle 50 euros
    ? si tiene 1 empleado a su cargo subirle 80 euros
    ? si tiene 2 empleados a su cargo subirle 100 euros
    ? si tiene más de tres empleados a su cargo subirle 110 euros
    ? si es el PRESIDENTE su salario se incrementa en 30 euros
Para saber el número de empleados a cargo de un trabajador debes llamar a la función
del ejercicio anterior.*/
CREATE OR REPLACE PROCEDURE SUBIDA_JEFE 
    (V_MAN EMPLOYEES.MANAGER_ID%TYPE
    ) IS
    V_NUM NUMBER;
    V_SUB NUMBER:=0;
    
    CURSOR PRESI IS
        (SELECT em.employee_id ID
            FROM EMPLOYEES EM
            JOIN JOBS JOB ON job.job_id=em.job_id
            WHERE job.job_title='President');
    
BEGIN
    V_NUM:=JEFE(V_MAN);
    
    IF V_NUM>2 THEN
        V_SUB:=110;
    ELSIF V_NUM=2 THEN
        V_SUB:=100;
    ELSIF V_NUM=1 THEN
        V_SUB:=80;
    ELSE
        V_SUB:=50;
    END IF;
    
    FOR I IN PRESI LOOP
        IF V_MAN = I.ID THEN
            V_SUB:=V_SUB+30;
        END IF;
    END LOOP;
    
    UPDATE employees EM SET em.salary=em.salary+V_SUB WHERE em.employee_id=V_MAN;
    
END SUBIDA_JEFE;

CALL subida_jefe(100);


SELECT * FROM EMPLOYEES;





