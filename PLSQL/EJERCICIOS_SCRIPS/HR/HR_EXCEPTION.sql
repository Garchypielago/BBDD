SET SERVEROUTPUT ON ;
/*1. Construye un procedimiento que recibe un salario y saque por consola todos los
empleados (nombre, apellidos y job) cuyo salario sea menor que el salario pasado por
parámetro. Si el salario no está informado o es menor que 0, debe controlarse con una
excepción de usuario.*/
CREATE OR REPLACE PROCEDURE P_COBRAN_MENOS
    (V_SAL EMPLOYEES.SALARY%TYPE) IS
    
    CURSOR EMP IS (SELECT EM.first_name NOM, EM.last_name APE, EM.job_id TRA
                    FROM EMPLOYEES EM
                    WHERE EM.salary<V_SAL);
    
    E_SALNOCONTEMPLADO EXCEPTION;
BEGIN
    
    IF v_sal IS NULL OR v_sal<0 THEN
        RAISE E_SALNOCONTEMPLADO;
    END IF;
    
    FOR I IN EMP LOOP
        DBMS_OUTPUT.PUT_LINE(I.NOM||', '||I.APE||' - '||I.TRA);
    END LOOP;

EXCEPTION 
    WHEN E_SALNOCONTEMPLADO THEN
        DBMS_OUTPUT.PUT_LINE('SALARIO NO ESPECIFICADO O MENOR A 0');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

END P_COBRAN_MENOS;

CALL p_cobran_menos(-1);
CALL p_cobran_menos(NULL);



/*2. Construye un procedimiento que reciba por parámetro un país y saque por consola las
ciudades donde la empresa tiene oficinas. Se controlará por una excepción de usuario
que el país esté informado.*/
SELECT * FROM COUNTRIES;
SELECT * FROM locations;

CREATE OR REPLACE PROCEDURE P_PAIS_CIUDADES
    (V_PAIS COUNTRIES.COUNTRY_NAME%TYPE) IS
    
    V_CODPAIS LOCATIONS.COUNTRY_ID%TYPE;
    
    CURSOR CIUS(V_CODPA LOCATIONS.COUNTRY_ID%TYPE) IS
        (SELECT DISTINCT(LO.city) CIU
            FROM LOCATIONS LO
            WHERE LO.country_id = V_CODPA);
    
    E_PAISNOENCONTRADO EXCEPTION;
BEGIN
        
    IF V_PAIS IS NULL THEN
        RAISE E_PAISNOENCONTRADO;
    END IF;
    
    SELECT CO.country_id
    INTO V_CODPAIS
        FROM COUNTRIES CO
        WHERE CO.country_name=V_PAIS;
    
    dbms_output.put_line(V_PAIS);
    
    FOR I IN CIUS(V_CODPAIS) LOOP
        dbms_output.put_line(' -'||I.CIU);
    END LOOP;
    

EXCEPTION
    WHEN E_PAISNOENCONTRADO THEN
        DBMS_OUTPUT.PUT_LINE('PAIS NO ESPECIFICADO');
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('PAIS NO EXISTE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

END P_PAIS_CIUDADES;

CALL p_pais_ciudades('A');
CALL p_pais_ciudades(NULL);
CALL p_pais_ciudades('United States of America');
    


/*3. Dentro de la tabla de trabajos hay un salario mínimo y un salario máximo. Escribe un
procedimiento (recibe como parámetro el trabajo y el % de subida de sueldo:.
    3.a. El procedimiento subirá el sueldo de todos los empleados que ganen menos del
    salario medio de su oficio.
    3.b.La subida será un % del salario. El % a subir se recibe por parámetro.
    3.c. Se deberá gestionar los posibles errores.*/
CREATE OR REPLACE PROCEDURE P_SUBIR_SAL_MINMAX
    (V_JOB JOBS.JOB_TITLE%TYPE,
    V_SUBIDA NUMBER
    ) IS
    
    V_JOBID JOBS.JOB_ID%TYPE;
    
    V_JOBAVG JOBS.MAX_SALARY%TYPE;
    
    E_NULO EXCEPTION;
BEGIN
    IF V_JOB IS NULL OR V_SUBIDA IS NULL THEN
        RAISE E_NULO;
    END IF;

    SELECT JO.JOB_ID
    INTO V_JOBID
        FROM JOBS JO WHERE JO.JOB_TITLE=V_JOB;
    
    SELECT ROUND(AVG(EM.SALARY))
    INTO V_JOBAVG
        FROM EMPLOYEES EM
        WHERE EM.JOB_ID = V_JOBID;
    
    UPDATE employees EM SET EM.salary=EM.salary+EM.salary*V_SUBIDA/100 WHERE EM.job_id=V_JOBID AND EM.salary<=V_JOBAVG;
    
EXCEPTION
    WHEN E_NULO THEN
        dbms_output.PUT_LINE('PARAMETRO/S NULO/S');
    WHEN NO_DATA_FOUND THEN
        dbms_output.PUT_LINE('DATOS NO ENCONTRADOS');
    WHEN OTHERS THEN
        dbms_output.PUT_LINE('ERROR GENERAL');
END P_SUBIR_SAL_MINMAX;

CALL p_subir_sal_minmax('Programmer',10);
CALL p_subir_sal_minmax('Programmer',NULL);
CALL p_subir_sal_minmax(NULL,10);
CALL p_subir_sal_minmax('DF',10);
SELECT * FROM EMPLOYEES WHERE JOB_ID='IT_PROG';
SELECT * FROM JOBS;

/*4. Crear un programa que reciba un número de empleado y una cantidad que se
incrementará al salario del empleado correspondiente. Utilizar una excepción definida
por el usuario denominada salario_nulo y la predefinida when no_data_found si el
empleado no existe.*/
CREATE OR REPLACE PROCEDURE P_SUBIR_SUELDO
    (V_EMPID EMPLOYEES.EMPLOYEE_ID%TYPE,
    V_SUB EMPLOYEES.SALARY%TYPE
    ) IS

    CURSOR EMP IS (SELECT * FROM EMPLOYEES);
    
    V_NOEXISTE BOOLEAN := TRUE;
    
    E_SALNULO EXCEPTION;
BEGIN
    IF V_SUB IS NULL OR V_SUB=0 THEN
        RAISE E_SALNULO;
    END IF;
    
    FOR I IN EMP LOOP
        IF V_EMPID = I.EMPLOYEE_ID THEN
            V_NOEXISTE:=FALSE;
        END IF;
    END LOOP;
    
    IF V_NOEXISTE THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    UPDATE EMPLOYEES EM SET EM.salary=EM.salary+V_SUB WHERE EM.employee_id=V_EMPID;

EXCEPTION
    WHEN E_SALNULO THEN
        DBMS_OUTPUT.PUT_LINE('SALARIO NULO');
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.put_line('NO EXISTE ESE EMPLEADO');
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(SQLERRM);
END P_SUBIR_SUELDO;

CALL p_subir_sueldo(100, 10);
CALL p_subir_sueldo(0, 10);
CALL p_subir_sueldo(100, NULL);
SELECT * FROM EMPLOYEES WHERE employee_id=100;

/*5. Escribir un procedimiento que reciba todos los datos de un nuevo empleado y procese
la transacción de alta, gestionando los siguientes errores:
    5.a.no_existe_departamento
    5.b.no_existe_manager
    5.c. numero_empleado_duplicado
    5.d.salario nulo con RAISE_APPLICATION_ERROR
    5.e.Otros posibles errores de Oracle visualizando código y mensaje de error.*/
    
CREATE OR REPLACE PROCEDURE P_NUEVO_EMP
    (V_ID EMPLOYEES.EMPLOYEE_ID%TYPE,
    V_NOM EMPLOYEES.FIRST_NAME%TYPE,
    V_APE EMPLOYEES.LAST_NAME%TYPE,
    V_EMAIL EMPLOYEES.EMAIL%TYPE,
    V_NUM EMPLOYEES.PHONE_NUMBER%TYPE,
    V_ALTA EMPLOYEES.HIRE_DATE%TYPE,
    V_JOBID EMPLOYEES.JOB_ID%TYPE,
    V_SAL EMPLOYEES.SALARY%TYPE,
    V_COMM EMPLOYEES.COMMISSION_PCT%TYPE,
    V_JEFE EMPLOYEES.MANAGER_ID%TYPE,
    V_DEPTID EMPLOYEES.DEPARTMENT_ID%TYPE
    );

BEGIN

EXCEPTION

END P_NUEVO_EMP;
    
    
    
    