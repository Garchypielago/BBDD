/*1. Devuelve el nombre del empleado que más gana*/
SELECT EM.first_name
    FROM employees EM
    WHERE EM.salary=(SELECT MAX(EM2.SALARY)
                            FROM employees EM2);
                            
SELECT EM.first_name
    FROM employees EM
    JOIN (SELECT MAX(EM2.SALARY) MAX_SAL
                FROM employees EM2) TABLA
            ON TABLA.max_sal=em.salary;
                            
/*2. Devuelve el nombre del empleado que más gana de cada departamento. Añade al listado el
nombre del departamento.*/
SELECT de.department_name, EM.first_name, em.salary
    FROM employees EM
    JOIN DEPARTMENTS DE ON de.department_id=em.department_id
    WHERE EM.salary=(SELECT MAX(EM2.SALARY)
                            FROM employees EM2
                            WHERE em.department_id=em2.department_id);
                            
SELECT TABLA.NOMBRE, EM.first_name, em.salary
    FROM employees EM
    JOIN (SELECT DE2.DEPARTMENT_NAME NOMBRE, de2.department_ID DEP, MAX(EM2.SALARY) MAXIMO
                FROM employees EM2
                JOIN DEPARTMENTS DE2 ON de2.department_id=em2.department_id
                GROUP BY DE2.DEPARTMENT_NAME, de2.department_ID) TABLA
            ON TABLA.maximo=em.salary
    ORDER BY 1;

/*3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
todos los empleados que ganen más que la media de la empresa.*/
SELECT de.department_name, em.first_name, em.salary
    FROM departments DE
    JOIN EMPLOYEES EM ON em.department_id=de.department_id
    WHERE em.salary>(SELECT AVG(EM2.SALARY)
                        FROM EMPLOYEES EM2)
    ORDER BY 1;
                        
SELECT DE.DEPARTMENT_NAME, EM.first_name, em.salary
    FROM employees EM
    JOIN DEPARTMENTS DE ON em.department_id=de.department_id
    JOIN (SELECT AVG(EM2.SALARY) MEDIA
                FROM employees EM2) TABLA
            ON TABLA.MEDIA<em.salary
    ORDER BY 1;

/*4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
todos los empleados que ganen más que la media de su departamento.*/
SELECT de.department_name, em.first_name, em.salary
    FROM departments DE
    JOIN EMPLOYEES EM ON em.department_id=de.department_id
    WHERE em.salary>(SELECT AVG(EM2.SALARY)
                        FROM EMPLOYEES EM2
                        WHERE em2.department_id=em.department_id)
    ORDER BY 1;
                        
SELECT TABLA.DEP, EM.FIRST_NAME, EM.SALARY
    FROM EMPLOYEES EM
    JOIN (SELECT DE.DEPARTMENT_NAME DEP, DE.DEPARTMENT_ID ID, AVG(EM2.SALARY) MEDIA
                FROM departments DE 
                JOIN EMPLOYEES EM2 ON em2.department_id=de.department_id
                GROUP BY DE.DEPARTMENT_NAME, DE.DEPARTMENT_ID) TABLA
            ON em.department_id=TABLA.ID
    WHERE EM.SALARY>TABLA.MEDIA
    ORDER BY 1;

/*5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
empleado más antiguo por cada puesto de trabajo.*/
SELECT jo.job_title, EM.FIRST_NAME, EM.HIRE_DATE
    FROM jobs JO
    JOIN employees EM ON em.job_id=jo.job_id
    WHERE em.hire_date=(SELECT MIN(EM2.HIRE_DATE)
                            FROM employees EM2);

SELECT jo.job_title, EM.FIRST_NAME, EM.HIRE_DATE
    FROM jobs JO
    JOIN employees EM ON em.job_id=jo.job_id
    JOIN (SELECT MIN(EM2.HIRE_DATE) MINIMO
                FROM employees EM2) TABLA
            ON TABLA.minimo=em.hire_date;

/*6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
empleados en cuyo departamento haya algún empleado que gane menos que ellos.*/
SELECT de.department_name, em.first_name, em.salary
    FROM departments DE
    JOIN EMPLOYEES EM ON em.department_id=de.department_id
    WHERE em.salary>(SELECT MIN(EM2.SALARY)
                        FROM EMPLOYEES EM2
                        WHERE em2.department_id=em.department_id);
                        
SELECT TABLA.ID, EM.FIRST_NAME, EM.SALARY
    FROM EMPLOYEES EM
    JOIN (SELECT EM2.department_id ID, MIN(EM2.SALARY) MINIMO
                FROM EMPLOYEES EM2
                GROUP BY EM2.department_id) TABLA
            ON TABLA.id=em.department_id
        WHERE EM.SALARY!=TABLA.MINIMO;

/*7 Haz un listado de las ciudades en las que no está ubicado ningún departamento*/
SELECT lo.city
    FROM locations LO
    WHERE lo.location_id NOT IN (SELECT DE.LOCATION_ID
                                    FROM departments DE);
                                    
SELECT lo.city
    FROM locations LO
    WHERE (SELECT count(1)
                FROM departments DE
                where lo.location_id=de.location_id)=0;

/*8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
pertenecientes a este puesto menos el último que se ha contratado.*/
SELECT jo.job_id, jo.job_title, EM.FIRST_NAME, em.hire_date
    FROM jobs JO
    JOIN employees EM ON em.job_id=jo.job_id
    WHERE em.hire_date NOT IN (SELECT MAX(EM2.HIRE_DATE)
                                    FROM employees EM2
                                    WHERE jo.job_id=em2.job_id)
    ORDER BY 1;

/*9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
salarios de su ciudad.*/
SELECT lo.city, em.first_name, em.last_name, em.salary
        , ROUND(EM.SALARY-(SELECT AVG(EM2.SALARY)
                            FROM locations LO2
                            JOIN departments DE2 ON de2.location_id=lo2.location_id
                            JOIN employees EM2 ON em2.department_id=de2.department_id
                            WHERE LO.CITY=lo2.CITY),2) RESTA
    FROM locations LO
    JOIN departments DE ON de.location_id=lo.location_id
    JOIN employees EM ON em.department_id=de.department_id
    WHERE em.salary = (SELECT MAX(EM2.SALARY)
                            FROM locations LO2
                            JOIN departments DE2 ON de2.location_id=lo2.location_id
                            JOIN employees EM2 ON em2.department_id=de2.department_id
                            WHERE LO.CITY=lo2.CITY);
                            


/*10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
? Cuantos empleados del departamento tienen un salario por encima de la media de la
empresa
? Cuantos empleados del departamento tienen un salario por encima de la media del
departamento.*/
SELECT 
        de.department_id, 
        de.department_NAME, 
        
        ROUND(AVG(EM.SALARY),2) MEDIA_DEP, 
        
        ROUND((SELECT AVG(EM1.SALARY) 
                    FROM employees EM1),2) MEDIA_EMPRESA,
                    
        (SELECT COUNT(1)
                FROM EMPLOYEES EM2
                WHERE EM2.SALARY>(SELECT AVG(EM1.SALARY) 
                                        FROM employees EM1)
                AND em2.department_id=DE.DEPARTMENT_ID) EMP_SUP_MED_EMP,
                
        (SELECT COUNT(1)
                FROM EMPLOYEES EM3
                WHERE EM3.SALARY>(SELECT AVG(EM4.SALARY) 
                                        FROM employees EM4
                                        WHERE em4.department_id=em3.department_id)
                AND em3.department_id=DE.DEPARTMENT_ID) EMP_SUP_MED_DEPT
                
    FROM departments DE
    JOIN employees EM ON em.department_id=de.department_id
    GROUP BY de.department_id, de.department_NAME
    HAVING AVG(EM.SALARY)>(SELECT AVG(EM5.SALARY) FROM employees EM5);

/*11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
fecha de contratación del empleado más antiguo que desempeña ese trabajo.*/
SELECT jo.job_title, SUM(EM.SALARY), MIN(EM.HIRE_DATE)
    FROM JOBS JO
    JOIN employees EM ON em.job_id=jo.job_id
    GROUP BY jo.job_title
    HAVING SUM(EM.SALARY)>(SELECT SUM(EM2.SALARY)
                                FROM employees EM2 
                                JOIN jobS JO2 ON jo2.job_id=em2.job_id
                                WHERE jo2.job_ID LIKE '%IT_PROG%');


/*12 (difícil) Haz un listado que me de el nombre y salario de un empleado y la diferencia salarial
que tiene con la media del salario de los empleados que son jefes, pero sin considerar a su
propio jefe.*/
SELECT em.first_name, em.salary, 
        ROUND((SELECT AVG(EM2.SALARY)
                    FROM employees EM2
                    WHERE EM2.EMPLOYEE_ID IN (SELECT DISTINCT EM3.MANAGER_ID
                                                FROM EMPLOYEES EM3)
                    AND (em.manager_id != EM2.EMPLOYEE_ID OR EM.MANAGER_ID IS NULL ))    
                - em.salary,2) RESTA
    FROM EMPLOYEES EM;



