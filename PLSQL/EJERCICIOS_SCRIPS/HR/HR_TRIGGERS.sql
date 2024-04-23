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



/*4. Crea un trigger que me avise al cambiar el departamento de un empleado si el
departamento antiguo y el nuevo no están en la misma ciudad.*/

/*5. Codifica triggers de sistema para que se inserten registros de auditoría en la tabla
que hemos creado en clase AUDITORIA_EVENTOS_BD con las siguientes
condiciones
    a. Cuando se desconecte el usuario SYSTEM
    b. Cuando cree una tabla en el sistema
    c. Cuando se asignen permisos*/

/*6. Crea un trigger de sistema que guarde en una tabla que debes crear el usuario, la
fecha, el código de error de oracle (ora_server_error(1)) y el mensaje de error de
oracle (columna varchar2(4000) y ora_server_error_msg(1)) cada vez que haya un
error en el sistema.*/