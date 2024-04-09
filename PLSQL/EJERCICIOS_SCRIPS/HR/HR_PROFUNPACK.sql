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
CALL modifica_dep_des(220,'NOCTURNO'); --BIEN


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

/*5. Escribir un programa que incremente el salario de los empleados de un determinado
departamento que se pasará como primer parámetro. El incremento será una cantidad
en euros que se pasará como segundo parámetro en la llamada. El programa deberá
informar del número de filas afectadas por la actualización.*/


/*6. Haz una función que reciba el id de empleado y devuelva el número de empleados que
tiene a su cargo.*/

/*7. Haz un procedimiento que reciba como parámetro un código de empleado y Modifica
el salario de un empleado en función del número de empleados que tiene a su cargo:
    ? si no tiene ningún empleado a su cargo subirle 50 euros
    ? si tiene 1 empleado a su cargo subirle 80 euros
    ? si tiene 2 empleados a su cargo subirle 100 euros
    ? si tiene más de tres empleados a su cargo subirle 110 euros
    ? si es el PRESIDENTE su salario se incrementa en 30 euros
Para saber el número de empleados a cargo de un trabajador debes llamar a la función
del ejercicio anterior.*/