SELECT * FROM EMPLOYEES EM WHERE EM.employee_id=&COD; //CON EL & NOS PREGUNTA

--SET SERVEROUTPUT ON;
DECLARE
    V_MIVARIABLE EMPLOYEES%ROWTYPE;
BEGIN 
    SELECT *
    INTO V_MIVARIABLE
    FROM employees EM
    WHERE EM.employee_id=100;
    
    DBMS_OUTPUT.put_line('Empleado: '||v_mivariable.FIRST_NAME);
END;

DECLARE
    V_MIVARIABLE EMPLOYEES%ROWTYPE;
BEGIN 
    SELECT *
    INTO V_MIVARIABLE
    FROM employees EM
    WHERE EM.employee_id=&COD;
    
    DBMS_OUTPUT.put_line('Empleado: '||v_mivariable.FIRST_NAME);
END;

DECLARE 
    V_COD1 EMPLOYEES.EMPLOYEE_ID%TYPE:=&COD;
    V_COD2 EMPLOYEES.EMPLOYEE_ID%TYPE:=&COD;
    V_CO1 LOCATIONS.COUNTRY_ID%TYPE;
    V_CO2 LOCATIONS.COUNTRY_ID%TYPE;
BEGIN 
    SELECT LO.COUNTRY_ID
        INTO V_CO1
        FROM LOCATIONS LO
        JOIN departments DE ON de.location_id=lo.location_id
        JOIN employees EM ON em.department_id=de.department_id
        WHERE em.employee_id=V_COD1;
    
    SELECT LO.COUNTRY_ID
        INTO V_CO2
        FROM LOCATIONS LO
        JOIN departments DE ON de.location_id=lo.location_id
        JOIN employees EM ON em.department_id=de.department_id
        WHERE em.employee_id=V_COD2;
    
    IF V_CO1=V_CO2 THEN
            DBMS_OUTPUT.put_line('TRABAJAN EN EL MISMO PAIS'); --100 101
        ELSE
            DBMS_OUTPUT.put_line('NO TRABAJAN EN EL MISMO PAIS'); --111 145
        END IF;
        
END;
    
    
    
    
    
    
    
    
    
    
    