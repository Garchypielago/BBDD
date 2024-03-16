/*1. Devuelve el listado con el nombre, apellidos, email y nombre del departamento al que
pertenecen todos los empleados.*/
SELECT EM.FIRST_NAME, EM.last_name, EM.EMAIL, DE.DEPARTMENT_NAME 
    FROM EMPLOYEES EM
    INNER JOIN departments DE ON de.department_id=em.department_id;

/*2. A la consulta anterior añade la descripción de su puesto de trabajo.*/
SELECT EM.FIRST_NAME, EM.last_name, EM.EMAIL, DE.DEPARTMENT_NAME, JOB.job_TITLE
    FROM EMPLOYEES EM
    INNER JOIN departments DE ON de.department_id=em.department_id
    INNER JOIN jobs JOB ON job.job_id=em.job_id;

/*3. Haz un listado con todos los departamentos y el nombre y apellido del manager del
departamento.*/
SELECT DE.DEPARTMENT_NAME, em.first_name, em.last_name
    FROM DEPARTMENTS DE
    INNER JOIN EMPLOYEES EM ON de.department_id=em.department_id
    WHERE em.EMPLOYEE_id=DE.MANAGER_id;
    
SELECT DE.DEPARTMENT_NAME, em.first_name, em.last_name
    FROM DEPARTMENTS DE
    INNER JOIN EMPLOYEES EM ON em.EMPLOYEE_id=DE.MANAGER_id;
    
/*4. Al listado anterior, añade la ciudad dónde se ubican los departamentos.*/
SELECT DE.DEPARTMENT_NAME, em.first_name, em.last_name, LO.CITY
    FROM DEPARTMENTS DE
    INNER JOIN EMPLOYEES EM ON em.EMPLOYEE_id=DE.MANAGER_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id;

/*5. Al listado anterior, añade el país dónde se ubican los departamentos.*/
SELECT DE.DEPARTMENT_NAME, em.first_name, em.last_name, CO.COUNTRY_NAME
    FROM DEPARTMENTS DE
    INNER JOIN EMPLOYEES EM ON em.EMPLOYEE_id=DE.MANAGER_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id;

/*6. Haz un listado con los departamentos y su dirección pero sólo deben salir los
departamentos ubicados en Italia.*/
SELECT * FROM COUNTRIES;

SELECT DE.DEPARTMENT_NAME, LO.*
    FROM DEPARTMENTS DE
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    WHERE UPPER(CO.COUNTRY_NAME) LIKE '%ITALY%';

/*7. Haz un listado con los departamentos y su dirección pero sólo deben salir los
departamentos ubicados en América.*/
SELECT DE.DEPARTMENT_NAME, re.region_name
    FROM DEPARTMENTS DE
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    INNER JOIN REGIONS RE ON re.region_id=co.region_id
    WHERE UPPER(re.region_name) LIKE '%AMERICA%';

/*8. Haz un listado con nombre, apellido, teléfono, ciudad donde está el departamento y
salario para los empleados que trabajan en Europa y ganan más de 10.000$.*/
SELECT * FROM REGIONS;

SELECT EM.FIRST_NAME, em.last_name, em.phone_number, lo.city, em.salary
    FROM EMPLOYEES EM
    INNER JOIN DEPARTMENTS DE ON em.department_id=de.department_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    INNER JOIN REGIONS RE ON re.region_id=co.region_id
    WHERE re.region_name LIKE '%Europe%' AND em.salary>10000;

/*9. Haz un listado con las descripciones de los trabajos que se hacen en la región de
América. Ojo, no deben salir duplicados.*/
SELECT DISTINCT job.job_title
    FROM jobs JOB
    inner join EMPLOYEES EM ON job.job_id=em.job_id
    INNER JOIN departments DE ON de.department_id=em.department_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    INNER JOIN REGIONS RE ON re.region_id=co.region_id
    WHERE re.region_name LIKE 'Americas';

/*10. Haz un listado con nombre, apellido, teléfono, ciudad donde está el departamento y
salario para los empleados que trabajan en Toronto o Munich.*/
SELECT EM.FIRST_NAME, em.last_name, em.phone_number, lo.city, em.salary
    FROM EMPLOYEES EM
    INNER JOIN DEPARTMENTS DE ON em.department_id=de.department_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    WHERE lo.city IN ('Toronto', 'Munich');

/*11. Haz un listado con el nombre y apellidos del empleado, nombre y apellidos de su jefe y
la diferencia de salario entre el empleado y el jefe.*/
SELECT (EM.FIRST_NAME || ' ' || em.last_name),(JE.FIRST_NAME || ' ' || JE.last_name) , JE.salary-em.salary
    FROM EMPLOYEES EM
    INNER JOIN EMPLOYEES JE ON JE.employee_id=EM.manager_id;

/*12. Haz un listado con las ciudades de Europa, sin repetir, dónde hay trabajadores cuyo
puesto de trabajo incluye en la descripción la palabra “Representative”.*/
SELECT distinct lo.city
    FROM EMPLOYEES EM
    INNER JOIN DEPARTMENTS DE ON em.department_id=de.department_id
    INNER JOIN LOCATIONS LO ON lo.location_id=de.location_id
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    INNER JOIN REGIONS RE ON re.region_id=co.region_id
    inner join JOBS JO ON jo.job_ID=em.job_id
    WHERE re.region_name LIKE '%Europe%' AND jo.job_title LIKE '%Representative%';

/*13. Haz un listado con los países que en esta BBDD tienen alguna dirección cuyo código
postal empieza por 2,4, 6 u 8,*/
SELECT distinct CO.*, lo.postal_code
    FROM LOCATIONS LO 
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    WHERE TO_CHAR(lo.postal_code) IN ('2%','4%','6%','8%');
    
SELECT distinct CO.*, lo.postal_code
    FROM LOCATIONS LO 
    INNER JOIN COUNTRIES CO ON Co.COUNTRY_id=Lo.COUNTRY_id
    WHERE SUBSTR(lo.postal_code,1,1) IN ('2','4','6','8');

/*14. Haz un listado con los empleados cuyo salario está por debajo del rango salarial que
corresponde a su puesto de trabajo.*/
SELECT EM.*
    FROM EMPLOYEES EM
    INNER JOIN JOBS JO ON jo.job_id=em.job_id
    WHERE em.salary<jo.min_salary;

/*15. Haz un listado con los empleados cuyo salario está por encima del rango salarial que
corresponde a su puesto de trabajo.*/
SELECT EM.*
    FROM EMPLOYEES EM
    INNER JOIN JOBS JO ON jo.job_id=em.job_id
    WHERE em.salary>jo.mAX_salary;

/*16. Haz un listado con los empleados cuyo salario es igual al mínimo del rango salarial que
corresponde a su puesto de trabajo o es igual al máximo del rango salarial que
corresponde a su puesto de trabajo.*/
SELECT EM.*
    FROM EMPLOYEES EM
    INNER JOIN JOBS JO ON jo.job_id=em.job_id
    WHERE em.salary=jo.min_salary OR em.salary=jo.mAX_salary;