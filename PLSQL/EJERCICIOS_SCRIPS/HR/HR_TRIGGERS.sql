SET SERVEROUTPUT ON;
/*1. Crea un trigger de tabla que cuando cambie el número de teléfono de un empleado
guarde en una tabla que debes haber creado previamente el código de empleado, el
número de teléfono antiguo y el número de teléfono nuevo, ademas de la fecha del
cambio.*/
CREATE TABLE PHONE_HISTORY(
EMP_ID NUMBER(6,0) NOT NULL,
PHONE_NUMBER VARCHAR2(20 BYTE),
DATE_CHANGE DATE NOT NULL,
CONSTRAINT FK_EMP_ID
FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
PRIMARY KEY (EMP_ID, DATE_CHANGE)
);

DROP TABLE PHONE_HISTORY;

CREATE OR REPLACE TRIGGER T_CAMBIO_TELEFONO
    BEFORE INSERT OR UPDATE OF PHONE_NUMBER ON EMPLOYEES 
FOR EACH ROW
DECLARE 
    E_MISMONUM EXCEPTION;
BEGIN
    IF :OLD.PHONE_NUMBER = :NEW.PHONE_NUMBER THEN
        RAISE E_MISMONUM;
    END IF;
    
    INSERT INTO phone_history VALUES (:NEW.EMPLOYEE_ID, :OLD.PHONE_NUMBER, SYSDATE);

EXCEPTION
    WHEN E_MISMONUM THEN
        dbms_output.put_line('ERROR: MISMO NUMERO DE TELEFONO CRACK, ' || :OLD.PHONE_NUMBER);
        RETURN;
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: GENERAL');
        RETURN;
END;

SELECT * FROM EMPLOYEES;
UPDATE employees SET phone_number= '515.123.4567' WHERE employee_id=100;

/*2. Crear un trigger que se ejecutará antes de eliminar un empleado e insertará en una
tabla de BackUp el id, nombre y apellidos, email, salario, departamento y trabajo,
además de la fecha de la eliminación.*/
CREATE TABLE EMP_BACKUP AS SELECT * FROM EMPLOYEES WHERE 1 = 0;
ALTER TABLE EMP_BACKUP ADD DATE_DELETE DATE;
ALTER TABLE EMP_BACKUP DROP (PHONE_NUMBER, HIRE_DATE, COMMISSION_PCT, MANAGER_ID) ;

CREATE OR REPLACE TRIGGER T_ELIMINAR_EMP
    BEFORE DELETE ON EMPLOYEES FOR EACH ROW
BEGIN
    INSERT INTO EMP_BACKUP VALUES
    (:OLD.EMPLOYEE_ID,
    :OLD.FIRST_NAME,
    :OLD.LAST_NAME,
    :OLD.EMAIL,
    :OLD.JOB_ID,
    :OLD.SALARY,
    :OLD.DEPARTMENT_ID,
    SYSDATE
    );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('ERROR: GENERAL');
        RETURN;
END;

SELECT * FROM EMPLOYEES;
DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID=202;
SELECT * FROM EMP_BACKUP;
/*3. Dentro de la tabla de trabajos hay un salario mínimo y un salario máximo.
Necesitamos un control por el que cada vez que se cambie uno de estos datos,
saber si hay empleados de ese trabajo que quedan fuera de ese rango y si es así
impedirlo dando un mensaje por consola.
    a. Por ejemplo, el salario mínimo de IT_PROG es 4.000. Si se quisiera cambiar
    el salario mínimo a 5.000, debe dar error porque hay trabajadores con este
    trabajo que no ganan 5.000.*/
create or replace trigger T_CAMBIO_MINMAX
    BEFORE UPDATE OF MIN_SALARY, MAX_SALARY
    ON JOBS FOR EACH ROW
DECLARE
    E_COBRAMENOS EXCEPTION;
    E_COBRAMAS EXCEPTION;
    
    V_CONTMIN NUMBER:=0;
    V_CONTMAX NUMBER:=0;
BEGIN
    SELECT COUNT(1)
    INTO V_CONTMIN
        FROM EMPLOYEES EM
        WHERE em.salary<:NEW.MIN_SALARY;
        
     IF V_CONTMIN > 0 THEN
         RAISE E_COBRAMENOS;
     END IF;
        
    SELECT COUNT(1)
    INTO V_CONTMAX
        FROM EMPLOYEES EM
        WHERE em.salary<:NEW.MAX_SALARY;

    IF V_CONTMAX > 0 THEN
        RAISE E_COBRAMAS;
    END IF;
    
EXCEPTION
    WHEN E_COBRAMENOS THEN
        RAISE_APPLICATION_ERROR(-20001,'UN EMPLEADO COBRA MENOS');
        RETURN;
    WHEN E_COBRAMAS THEN
        RAISE_APPLICATION_ERROR(-20002,'UN EMPLEADO COBRA MAS');
        RETURN;
    WHEN OTHERS THEN
        RETURN;
END;

UPDATE JOBS SET MIN_SALARY=5000 WHERE JOB_ID = 'IT_PROG';
SELECT * FROM JOBS;


/*4. Crea un trigger que me avise al cambiar el departamento de un empleado si el
departamento antiguo y el nuevo no están en la misma ciudad.*/
create or replace trigger T_CAMBIO_CIUDAD
    AFTER UPDATE OF DEPARTMENT_ID
    ON EMPLOYEES FOR EACH ROW
DECLARE
    E_DIFCIU EXCEPTION;
    V_CIUOLD LOCATIONS.CITY%TYPE;
    V_CIUNEW LOCATIONS.CITY%TYPE;
BEGIN
    SELECT LO.CITY
    INTO V_CIUNEW
        FROM LOCATIONS LO
        JOIN DEPARTMENTS DE ON de.location_id=lo.location_id
        WHERE de.department_id=:NEW.DEPARTMENT_ID;
    
    SELECT LO.CITY
    INTO V_CIUOLD
        FROM LOCATIONS LO
        JOIN DEPARTMENTS DE ON de.location_id=lo.location_id
        WHERE de.department_id=:OLD.DEPARTMENT_ID;
    
    IF V_CIUNEW != V_CIUOLD THEN
        RAISE E_DIFCIU;
    END IF;
    
EXCEPTION
    WHEN E_DIFCIU THEN
        dbms_output.put_line('AVISO: CIUDADES NO COINCIDENTES');
        RETURN;
    WHEN OTHERS THEN
        RETURN;
END;

SELECT * FROM EMPLOYEES;
UPDATE EMPLOYEES SET DEPARTMENT_ID = 60 WHERE EMPLOYEE_ID = 206; --110 ORIGINAL


SET SERVEROUTPUT ON;
/*5. Codifica triggers de sistema para que se inserten registros de auditoría en la tabla
que hemos creado en clase AUDITORIA_EVENTOS_BD con las siguientes
condiciones*/
CREATE TABLE AUDITORIA_EVENTOS_BD(
USUARIO VARCHAR2(50),
EVENTO VARCHAR2(50),
FECHA DATE,
PRIMARY KEY (USUARIO,EVENTO,FECHA)
);

CREATE OR REPLACE TRIGGER AUDITORIA_LOGIN
    AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO AUDITORIA_EVENTOS_BD VALUES (USER,ORA_SYSEVENT,SYSDATE);
END;

    --a. Cuando se desconecte el usuario SYSTEM
CREATE OR REPLACE TRIGGER AUDITORIA_LOGOUT
    BEFORE LOGOFF ON DATABASE
BEGIN
    IF USER = 'SYSTEM' THEN
        INSERT INTO AUDITORIA_EVENTOS_BD VALUES (USER,ORA_SYSEVENT,SYSDATE);
    END IF;
END;

    --b. Cuando cree una tabla en el sistema
CREATE OR REPLACE TRIGGER AUDITORIA_CREATETABLE
    AFTER CREATE ON DATABASE
BEGIN
    INSERT INTO AUDITORIA_EVENTOS_BD VALUES (USER,ORA_SYSEVENT,SYSDATE);
END;

    --c. Cuando se asignen permisos
CREATE OR REPLACE TRIGGER AUDITORIA_GRANT
    AFTER GRANT ON DATABASE
BEGIN
    INSERT INTO AUDITORIA_EVENTOS_BD VALUES (USER,ORA_SYSEVENT,SYSDATE);
END;

/*6. Crea un trigger de sistema que guarde en una tabla que debes crear el usuario, la
fecha, el código de error de oracle (ora_server_error(1)) y el mensaje de error de
oracle (columna varchar2(4000) y ora_server_error_msg(1)) cada vez que haya un
error en el sistema.*/

CREATE TABLE ERROR_EJECUCION(
USUARIO VARCHAR2(50),
COD_ERROR VARCHAR2(50),
FECHA DATE,
MSG_ERROR VARCHAR2(4000),
PRIMARY KEY (USUARIO,COD_ERROR,FECHA)
);

CREATE OR REPLACE TRIGGER SYSTEM_ERROR
    AFTER SERVERERROR ON DATABASE
BEGIN
    INSERT INTO ERROR_EJECUCION VALUES (USER,ora_server_error(1),SYSDATE,ora_server_error_msg(1));
END;

select * from ERROR_EJECUCION;