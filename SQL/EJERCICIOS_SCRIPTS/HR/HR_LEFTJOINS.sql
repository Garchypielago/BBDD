/*1. Devuelve los departamentos y en caso de que el departamento tenga manager, los
datos del manger (nombre, apellidos, salario y fecha de contrataci�n)*/
SELECT dep.department_name, em.first_name, em.last_name, em.salary, em.hire_date
    FROM departments DEP
    LEFT JOIN employees EM ON em.EMPLOYEE_id=dep.manager_id;

/*2. Devuelve los pa�ses (c�digo y descripci�n) y en caso de que haya direcciones en ese
pa�s, la ciudad de la direcci�n.*/
SELECT co.country_id, co.country_name, lo.city
     FROM countries CO
     LEFT JOIN locations LO ON lo.COUNTRY_id=co.country_id;

/*3. Al listado anterior, a�ade c�digo y descripci�n del departamento.*/
SELECT co.country_id, co.country_name, lo.city, de.department_id, de.department_name
     FROM countries CO
     LEFT JOIN locations LO ON lo.COUNTRY_id=co.country_id
     LEFT JOIN departments DE ON lo.location_id=de.location_id;

/*4. Al listado anterior, a�ade el nombre y apellidos del manager.*/
SELECT co.country_id, co.country_name, lo.city, de.department_name, (em.first_name||' '||em.last_name)
     FROM countries CO
     LEFT JOIN locations LO ON lo.COUNTRY_id=co.country_id
     LEFT JOIN departments DE ON lo.location_id=de.location_id
     LEFT JOIN employees EM ON em.employee_id=de.manager_id;

/*5. Devuelve todos los empleados (nombre y apellido) con el nombre del departamento al
que pertenecen, los departamentos que no tienen empleados y los empleados que no
tienen departamento. Si puedes haz la select de 2 formas distintas.*/
SELECT (em.first_name||' '||em.last_name), de.department_name
    FROM employees EM
    FULL OUTER JOIN departments DE ON de.department_id=em.department_id
    ORDER BY 1;

/*Realiza las consultas utilizando UNION, UNION ALL, INTERSEC, MINUS*/
/*6. Devuelve un listado que muestre el salario medio, m�ximo y m�nimo de los empleados
con comisi�n y los mismos datos de los empleados sin comisi�n.*/
SELECT 'CON COMISION' TIPO, ROUND( AVG(EM.SALARY),2), MIN(EM.SALARY),MAX(EM.SALARY)
    FROM employees EM
    WHERE em.commission_pct IS NOT NULL
UNION
SELECT 'SIN COMISION' TIPO, ROUND( AVG(EM.SALARY),2), MIN(EM.SALARY),MAX(EM.SALARY)
    FROM employees EM
    WHERE em.commission_pct IS NULL;

/*7. Devuelve un listado con el nombre, apellidos y fecha de contrataci�n de los empleados
y un literal al lado que indique �TIENE EMPLEADOS A SU CARGO� o �NO TIENE
EMPLEADOS A SU CARGO�.*/
SELECT DISTINCT (em.first_name||' '||em.last_name), EM.HIRE_DATE, 'TIENE EMPLEADOS A SU CARGO' MANAGER
    FROM employees EM
    JOIN employees EM2 ON em.employee_id=em2.manager_id
/*18 REGISTROS*/
UNION 
SELECT DISTINCT (em.first_name||' '||em.last_name), EM.HIRE_DATE, 'NO TIENE EMPLEADOS A SU CARGO' MANAGER
    FROM employees EM
    WHERE em.employee_id NOT IN (SELECT DISTINCT (em2.employee_id)
                                    FROM employees EM2
                                    JOIN employees EM3 ON em2.employee_id=em3.manager_id);
/*107 REGISTROS*/

/*8. Devuelve un listado con todos los empleados salvo los que su nombre empieza por
vocal o ganan m�s de 12.000$.*/
SELECT *
    FROM employees EM
/*107 REGISTROS*/
MINUS 
(SELECT *
    FROM employees EM
    WHERE SUBSTR(UPPER(em.first_name),1,1) IN ('A','E','I','O','U')
/*91 REGISTROS*/
UNION
SELECT *
    FROM employees EM
    WHERE em.salary>12000);
/*83 REGISTROS*/
/*FUNCIONA COMO MATEMATICAS EL MINUS Y EL UNION*7


/*9. Devuelve un listado con todos los empleados salvo los que su nombre empieza por
vocal y cuyo salario est� por encima de la media de su departamento.
o ganan m�s de 12.000$*/
SELECT (em.first_name||' '||em.last_name), em.salary
    FROM employees EM
MINUS(
SELECT (em.first_name||' '||em.last_name), em.salary
    FROM employees EM
    WHERE SUBSTR(UPPER(em.first_name),1,1) IN ('A','E','I','O','U')
INTERSECT
SELECT (em.first_name||' '||em.last_name), em.salary 
    FROM employees EM
    WHERE em.salary > (SELECT AVG(EM2.SALARY)
                        FROM employees EM2
                        WHERE em2.department_id=em.department_id)
)MINUS
SELECT (em.first_name||' '||em.last_name), em.salary 
    FROM employees EM
    WHERE em.salary > 12000;

