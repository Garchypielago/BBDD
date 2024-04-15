SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE MODIFICA_DEP_DES_EXCEPTION
    (V_DEPID IN DEPARTMENTS.DEPARTMENT_ID%TYPE,
    V_DEPDES IN DEPARTMENTS.DEPARTMENT_NAME%TYPE
    ) IS
BEGIN
    UPDATE departments DE SET de.department_name=V_DEPDES WHERE de.department_id=V_DEPID;
    
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('HA FALLADO');
    
END MODIFICA_DEP_DES_EXCEPTION;

SELECT * FROM departments;
CALL modifica_dep_des_EXCEPTION(990,'NOC'); --BIEN

--SQL%ROWCOUNT