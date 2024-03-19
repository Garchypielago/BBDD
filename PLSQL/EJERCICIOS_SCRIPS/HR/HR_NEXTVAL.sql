SET SERVEROUTPUT ON;
/*1. Crear un bloque PL que visualice el departamento de un empleado que se pida al
usuario por teclado.*/
SELECT * FROM EMPLOYEES;

declare
    V_CODEMP EMPLOYEES.EMPLOYEE_ID%TYPE:= &COD;
    V_DEP EMPLOYEES.DEPARTMENT_ID%TYPE;
begin
    SELECT EM.department_id
    INTO V_DEP
        FROM employees EM
        WHERE EM.employee_id=v_codemp;
    dbms_output.put_line('EMPLEADO: '|| v_codemp ||' TRABAJA EN DEP NUM: '|| V_DEP );
end;

/*2. Incrementar el salario 100€ a todos los trabajadores que sean ‘IT_PROG’, mediante un
bloque anónimo PL, asignando dicho valor a una variable declarada.*/
SELECT * FROM EMPLOYEES WHERE job_id = 'IT_PROG';

DECLARE
    V_INCREMENTO NUMBER :=100;
    V_TRABAJO EMPLOYEES.job_id%TYPE := 'IT_PROG';
BEGIN
    UPDATE EMPLOYEES EM 
        SET EM.SALARY= EM.SALARY + v_incremento
        WHERE EM.JOB_ID = v_trabajo; 
END;

/*3. Crea un bloque de PL/SQL que inserte un nuevo registro en la tabla de empleados. Con
las siguientes características:
    3.a. Pedirá por teclado al usuario un código de empleado válido (employee_id)
    3.b.Buscará al empleado que menos dinero gane que pertenezca al mismo
    departamento que el que nos han pasado y duplicará todos sus datos menos
    3.b.i. El id (sacarlo de la secuencia)
    3.b.ii. El nombre y apellidos que será: PEPITO GRILLO
    3.b.iii. La fecha de contratación será hoy.*/
SELECT * FROM EMPLOYEES WHERE department_id=90;
    
SELECT EMPLOYEES_SEQ.NEXTVAL FROM DUAL;
ALTER SEQUENCE EMPLOYEES_SEQ INCREMENT BY 1;

SELECT EMPLOYEES_SEQ.CURRVAL FROM DUAL;

SELECT sequence_name
FROM all_sequences;
    
DECLARE
    V_EMPID EMPLOYEES.DEPARTMENT_ID%TYPE;
    V_EMPMIN EMPLOYEES%ROWTYPE ;
BEGIN
     SELECT EM.DEPARTMENT_ID
     INTO V_EMPID
        FROM EMPLOYEES EM
        WHERE EM.employee_id = 101;
    
    dbms_output.put_line(V_EMPID);
    
    SELECT EM.*
        INTO V_EMPMIN
            FROM EMPLOYEES EM
            WHERE EM.salary = (SELECT MIN(EM2.SALARY) SAL
                                    FROM EMPLOYEES EM2
                                    WHERE EM2.department_id = V_EMPID)
            AND EM.department_id = V_EMPID
            FETCH FIRST ROW ONLY;
        
        dbms_output.put_line(V_EMPMIN.EMPLOYEE_ID||' '||V_EMPMIN.FIRST_NAME||' '||V_EMPMIN.SALARY||' '||V_EMPMIN.DEPARTMENT_ID);
        
        V_EMPMIN.EMPLOYEE_ID := EMPLOYEES_SEQ.NEXTVAL ;
        V_EMPMIN.FIRST_NAME := 'PEPITO';
        V_EMPMIN.LAST_NAME := 'GRILLO';
        V_EMPMIN.EMAIL := 'PORQUERNOVA';
        V_EMPMIN.HIRE_DATE := SYSDATE;
        
        dbms_output.put_line(V_EMPMIN.EMPLOYEE_ID||V_EMPMIN.FIRST_NAME||V_EMPMIN.LAST_NAME||V_EMPMIN.EMAIL||V_EMPMIN.PHONE_NUMBER
        ||V_EMPMIN.HIRE_DATE||V_EMPMIN.JOB_ID||V_EMPMIN.SALARY||V_EMPMIN.COMMISSION_PCT||V_EMPMIN.MANAGER_ID||V_EMPMIN.DEPARTMENT_ID);
        
        INSERT INTO EMPLOYEES VALUES V_EMPMIN;
END;

SELECT * FROM EMPLOYEES WHERE first_name='PEPITO';

/*4. Diseñar un bloque PL que introduciendo el código de un empleado por teclado,
visualice el sueldo y su código, para posteriormente actualizar su comisión teniendo en
cuenta que si su salario es menor de 3.000 € su comisión será del 10% de este, si está
entre 3.000 y 5.000 del 15% y si es mayor de 5.000 el 20%. Posteriormente se
visualizará su comisión actualizada.*/
SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE 'SA%';

DECLARE
    V_EMP EMPLOYEES%ROWTYPE;
BEGIN
    SELECT *
    INTO v_emp
        FROM employees EM
        WHERE EM.employee_id = &ID;
        
    dbms_output.put_line('CODIGO: '||V_EMP.EMPLOYEE_ID||', SUELDO: '||v_emp.SALARY);
    
    IF v_emp.SALARY>5000 THEN
        UPDATE employees SET commission_pct = (V_EMP.SALARY*0.2) WHERE employee_id=V_EMP.employee_id;
    ELSIF v_emp.SALARY>3000 THEN
        UPDATE employees SET commission_pct = (V_EMP.SALARY*0.1) WHERE employee_id=V_EMP.employee_id;
    ELSE 
        UPDATE employees SET commission_pct = (V_EMP.SALARY*0.15) WHERE employee_id=V_EMP.employee_id;
        
    dbms_output.put_line('CODIGO: '||V_EMP.EMPLOYEE_ID||', SUELDO: '||v_emp.SALARY);
    END IF;
        
END;

/*5. Introduciendo un año por teclado, decir si este es bisiesto o no.*/
DECLARE
    V_YEAR NUMBER(4,0) := &YEAR ;
BEGIN
    
    IF MOD(V_YEAR,400)=0 THEN
        dbms_output.put_line('ES BISIESTO');
    ELSIF MOD(V_YEAR,100)!=0 AND MOD(V_YEAR,4)=0 THEN
        dbms_output.put_line('ES BISIESTO');
    ELSE 
        dbms_output.put_line('NO ES BISIESTO');
    END IF;  
END;

/*6. Diseñar un bloque de PL que le pida al usuario un código de empleado y que devuelva
el mayor divisor del salario del empleado.*/
DECLARE 
   V_EMP EMPLOYEES%ROWTYPE; 
   V_DIVISOR NUMBER;
BEGIN
    SELECT *
    INTO V_EMP 
        FROM employees EM
        WHERE EM.employee_id=&COD;
        
    FOR I IN 1..V_EMP.SALARY/2 LOOP
        IF MOD(V_EMP.SALARY,I)=0 THEN
            V_DIVISOR := I;
        END IF;
    END LOOP;
    
    IF v_divisor IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('MAYOR DIVISOR: '||V_DIVISOR);
    ELSE
        DBMS_OUTPUT.PUT_LINE('NO TIENE MAYOR DIVISOR');
    END IF;
END;

SELECT * FROM EMPLOYEES;

/*7. Dado un país introducido por teclado, obtener el número de empleados que hay en ese
país.*/
DECLARE
    V_PAIS COUNTRIES.COUNTRY_NAME%TYPE :=&PAIS;
    V_NUMEMP NUMBER;
BEGIN
    SELECT COUNT(1)
    INTO V_NUMEMP
        FROM employees EM
        JOIN departments DE ON em.department_id=de.department_id
        JOIN LOCATIONS LO ON lo.location_id=de.location_id
        JOIN countries CO ON co.country_id=lo.country_id
        WHERE co.country_name = V_PAIS;
    
    DBMS_OUTPUT.PUT_LINE(V_NUMEMP||' DE EMPLEADOS EN '||V_PAIS);
END;

SELECT * FROM COUNTRIES;

/*8. Crear una tabla llamada TANGULOS con tres columnas ángulo, seno, coseno. Rellenar
la misma mediante un bloque PL de todos los ángulos comprendidos entre 0 y 90, en
intervalos de diez en diez.*/


/*9. Haz un bloque anónimo que pida un id de empleado y cuente el número de vocales
que hay en su email.*/
DECLARE
    V_EMPMAIL EMPLOYEES.EMAIL%TYPE;
    V_NUMVOCALES NUMBER:=0;
BEGIN
    SELECT em.email
    INTO V_EMPMAIL
        FROM EMPLOYEES EM
        WHERE em.employee_id=&ID;
        
    FOR I IN 1..LENGTH(V_EMPMAIL) LOOP
        IF UPPER(SUBSTR(V_EMPMAIL, I, 1)) IN ('A','E','I','O','U') THEN
            V_NUMVOCALES := V_NUMVOCALES +1;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(V_EMPMAIL||' TIENE '||V_NUMVOCALES||' VOCALES');
END;

/*10. Los departamentos de RRHH e ADMINISTRACIÓN se van a fusionar, por lo que
debemos hacer un proceso que:
    10.a. Genere un nuevo departamento (RRHH+ADMIN)
    10.b. Cuyo responsable ý localización será igual al del actual de RRHH
    10.c. Asigne a los trabajadores de ambos departamentos el nuevo manager y el 
    nuevo departamento*/
SELECT * FROM departments;
SELECT * FROM EMPLOYEES WHERE employees.department_id=260;
    
DECLARE 
    V_NEWDEP DEPARTMENTS%ROWTYPE;
    V_REP DEPARTMENTS.MANAGER_ID%TYPE;
BEGIN
    SELECT *
    INTO V_NEWDEP
        FROM departments DE
        WHERE de.department_name='Human Resources';
    
    V_NEWDEP.DEPARTMENT_NAME:='RRHH+ADMIN';
    V_NEWDEP.DEPARTMENT_ID:=DEPARTMENTS_SEQ.NEXTVAL;
    
    INSERT INTO departments VALUES V_NEWDEP;
    
    UPDATE employees EM 
    SET em.department_id=V_NEWDEP.DEPARTMENT_ID, em.MANAGER_ID=V_NEWDEP.MANAGER_ID
    WHERE em.department_id IN (SELECT de.department_id
                                FROM DEPARTMENTS DE
                                WHERE de.department_name IN 
                                ('Human Resources','Administration'));
                                
    DELETE FROM departments 
    WHERE department_id IN (SELECT de.department_id
                                FROM DEPARTMENTS DE
                                WHERE de.department_name IN 
                                ('Human Resources','Administration'));

END;

SELECT * FROM departments;
SELECT * FROM EMPLOYEES WHERE employees.department_id=280;
