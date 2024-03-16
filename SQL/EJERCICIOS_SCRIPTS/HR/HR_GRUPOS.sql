/*1. Haz un listado con todos los departamentos, nombre del departamento, el n�mero de
trabajadores que hay en el departamento y la media de su salario.*/
SELECT DE.DEPARTMENT_NAME, COUNT(1), ROUND( AVG(SALARY),2)
    FROM EMPLOYEES EM
    INNER JOIN departments DE ON em.department_id=de.department_id
    GROUP BY de.department_NAME;

/*2. Haz un listado con todas las ciudades y el n�mero de trabajadores que hay en cada ciudad.*/
SELECT lo.city, COUNT(1)
    FROM employees EM
    JOIN departments DE ON em.department_id=de.department_id
    JOIN locations LO ON de.location_id=lo.location_id
    GROUP BY lo.city;
    
SELECT DISTINCT LO2.CITY,
        (SELECT COUNT(1)
        FROM employees EM
        JOIN departments DE ON em.department_id=de.department_id
        JOIN locations LO ON de.location_id=lo.location_id
        WHERE lo.city=LO2.CITY) TRABAJADORES
    FROM LOCATIONS LO2;

/*3. Haz un listado con todos los pa�ses, nombre del pa�s, y el salario del trabajador que m�s
gana y el que menos de cada pa�s.*/
SELECT co.country_name, MAX(EM.SALARY), MIN(EM.SALARY)
    FROM employees EM
    JOIN departments DE ON em.department_id=de.department_id
    JOIN locations LO ON de.location_id=lo.location_id
    JOIN countries CO ON co.country_id=lo.country_id
    GROUP BY co.country_name;
    
SELECT DISTINCT co2.country_name, 
        (SELECT MAX(EM.SALARY)
        FROM employees EM
        JOIN departments DE ON em.department_id=de.department_id
        JOIN locations LO ON de.location_id=lo.location_id
        JOIN countries CO ON co.country_id=lo.country_id
        WHERE co.country_name=CO2.COUNTRY_NAME) SALARIO_MAXIMO,
        (SELECT MIN(EM.SALARY)
        FROM employees EM
        JOIN departments DE ON em.department_id=de.department_id
        JOIN locations LO ON de.location_id=lo.location_id
        JOIN countries CO ON co.country_id=lo.country_id
        WHERE co.country_name=CO2.COUNTRY_NAME) SALARIO_MINIMO
    FROM COUNTRIES CO2;

/*4. Haz un listado con todos los a�os en que se contrat� a m�s de 10 personas. Saca el a�o y el
n�mero de contrataciones por a�o.*/
SELECT TO_CHAR(EM.HIRE_DATE, 'yyyy'), COUNT(1)
    FROM employees EM
    GROUP BY TO_CHAR(EM.HIRE_DATE, 'yyyy')
    HAVING COUNT(1)>10;

/*5. Muestra en un listado los departamentos que tengan m�s de 5 empleados. Ord�nalos de
mayor a menor n�mero de trabajadores.*/
SELECT DE.DEPARTMENT_NAME, COUNT(1)
    FROM EMPLOYEES EM
    INNER JOIN departments DE ON em.department_id=de.department_id
    GROUP BY de.department_NAME
    HAVING COUNT(1)>5
    ORDER BY COUNT(1) DESC;

/*6. Muestra los pa�ses, nombre, donde haya departamentos en m�s de una ciudad,.*/
SELECT co.country_name, count(DISTINCT lo.city)
    FROM locations LO 
    JOIN departments DE ON de.location_id=lo.location_id
    JOIN COUNTRIES CO ON co.country_id=lo.country_id
    GROUP BY co.country_name
    HAVING COUNT(1)>1;

/*7. Muestra la suma de los salarios de los empleados cuyo tel�fono acabe en 9.*/
SELECT SUM(EM.SALARY)
    FROM employees EM
    WHERE SUBSTR(EM.PHONE_NUMBER,-1)=9;

/*8. Muestra un listado con el n�mero de empleados de cada ciudad de Europa.*/
SELECT lo2.city,
(SELECT COUNT(1)
    FROM employees EM
    JOIN departments DE ON em.department_id=de.department_id
    JOIN locations LO ON de.location_id=lo.location_id
    JOIN countries CO ON co.country_id=lo.country_id
    JOIN regions RE ON re.region_id=co.region_id
    WHERE UPPER(re.region_name) LIKE '%EUROPE%' AND
    lo.city=LO2.CITY) EMPLEADOS
FROM LOCATIONS LO2;

/*9. Muestra la fecha de contrataci�n del empleado m�s antiguo de cada departamento.*/
SELECT de.department_name, MIN(EM.HIRE_DATE)
    FROM employees EM
    JOIN departments DE ON de.department_id=em.department_id
    GROUP BY de.department_name;
    

/*10. Obt�n la suma de salarios de los empleados cuyo nombre empiece por A.*/
SELECT SUM(EM.SALARY)
    FROM employees EM
    WHERE SUBSTR(em.first_name,1,1)='A';

/*11. Obt�n la media de salarios de los empleados agrupando por la primera letra del apellido.
Ordena el listado alfab�ticamente.*/
SELECT SUBSTR(em.last_name,1,1), ROUND(AVG(EM.SALARY),2)
    FROM employees EM
    GROUP BY SUBSTR(em.last_name,1,1)
    ORDER BY 1 ASC;
