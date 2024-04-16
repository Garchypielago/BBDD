SET SERVEROUTPUT ON ;
/*1. Construye un procedimiento que recibe un salario y saque por consola todos los
empleados (nombre, apellidos y job) cuyo salario sea menor que el salario pasado por
par�metro. Si el salario no est� informado o es menor que 0, debe controlarse con una
excepci�n de usuario.*/
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



/*2. Construye un procedimiento que reciba por par�metro un pa�s y saque por consola las
ciudades donde la empresa tiene oficinas. Se controlar� por una excepci�n de usuario
que el pa�s est� informado.*/
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
    


/*3. Dentro de la tabla de trabajos hay un salario m�nimo y un salario m�ximo. Escribe un
procedimiento (recibe como par�metro el trabajo y el % de subida de sueldo:.
    3.a. El procedimiento subir� el sueldo de todos los empleados que ganen menos del
    salario medio de su oficio.
    3.b.La subida ser� un % del salario. El % a subir se recibe por par�metro.
    3.c. Se deber� gestionar los posibles errores.*/
CREATE OR REPLACE PROCEDURE P_SUBIR_SAL_MINMAX
    (V_JOB JOBS.JOB_TITLE%TYPE,
    V_SUBIDA NUMBER 
    ); IS
    
    
    E_NULO EXCEPTION;
BEGIN

EXCEPTION

END P_SUBIR_SAL_MINMAX;

/*4. Crear un programa que reciba un n�mero de empleado y una cantidad que se
incrementar� al salario del empleado correspondiente. Utilizar una excepci�n definida
por el usuario denominada salario_nulo y la predefinida when no_data_found si el
empleado no existe.*/

/*5. Escribir un procedimiento que reciba todos los datos de un nuevo empleado y procese
la transacci�n de alta, gestionando los siguientes errores:
    5.a.no_existe_departamento
    5.b.no_existe_manager
    5.c. numero_empleado_duplicado
    5.d.salario nulo con RAISE_APPLICATION_ERROR
    5.e.Otros posibles errores de Oracle visualizando c�digo y mensaje de error.*/