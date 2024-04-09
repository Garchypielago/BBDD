SET SERVEROUTPUT ON;
/*1. Codificar un procedimiento que permita borrar un empleado cuyo n�mero se pasa en
la llamada.*/
CREATE OR REPLACE PROCEDURE BORRAR_EMP_IDEMP
    (V_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE
    ) IS
BEGIN
    DELETE employees EM WHERE EM.employee_id = V_ID;
END BORRAR_EMP_IDEMP;

SELECT * FROM EMPLOYEES;
CALL borrar_emp_idemp(199); --BIEN

/*2. Escribir un procedimiento que modifique la descripci�n de un departamento. El
procedimiento recibir� como par�metros el n�mero de departamento y la nueva
descripci�n.*/
CREATE OR REPLACE PROCEDURE MODIFICA_DEP_DES
    (V_DEPID IN DEPARTMENTS.DEPARTMENT_ID%TYPE,
    V_DEPDES IN DEPARTMENTS.DEPARTMENT_NAME%TYPE
    ) IS
BEGIN
    UPDATE departments DE SET de.department_name=V_DEPDES WHERE de.department_id=V_DEPID;
END MODIFICA_DEP_DES;

SELECT * FROM departments;
CALL modifica_dep_des(220,'NOCTURNO'); --BIEN


/*3. Haz un procedimiento donde visualicemos los 2 departamentos m�s caros y el total de
dinero destinado en salarios por esos departamentos (se considera como
departamento m�s caro aquel cuya suma de sueldos de sus empleados sea la m�s
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

/*4. Haz una funci�n donde se nos muestre el IRPF de un empleado. Si gana por debajo de
4000 devolver� 10% de su salario y si gana igual o m�s devolver� 15% de su salario.*/
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
    dbms_output.put_line('IRPF DE '||EMP_ID||': '||V_IRPF||'�');
END;

/*5. Escribir un programa que incremente el salario de los empleados de un determinado
departamento que se pasar� como primer par�metro. El incremento ser� una cantidad
en euros que se pasar� como segundo par�metro en la llamada. El programa deber�
informar del n�mero de filas afectadas por la actualizaci�n.*/


/*6. Haz una funci�n que reciba el id de empleado y devuelva el n�mero de empleados que
tiene a su cargo.*/

/*7. Haz un procedimiento que reciba como par�metro un c�digo de empleado y Modifica
el salario de un empleado en funci�n del n�mero de empleados que tiene a su cargo:
    ? si no tiene ning�n empleado a su cargo subirle 50 euros
    ? si tiene 1 empleado a su cargo subirle 80 euros
    ? si tiene 2 empleados a su cargo subirle 100 euros
    ? si tiene m�s de tres empleados a su cargo subirle 110 euros
    ? si es el PRESIDENTE su salario se incrementa en 30 euros
Para saber el n�mero de empleados a cargo de un trabajador debes llamar a la funci�n
del ejercicio anterior.*/