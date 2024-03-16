SELECT DEP.department_name, em.first_name
    FROM departments DEP
    RIGHT JOIN employees EM ON em.department_id=dep.department_id; 
--SACA NULOS DE DEPARTEMENT_NAME, POR QUE EXISTEN EN EMPLOYEES

SELECT DEP.department_name, em.first_name
    FROM departments DEP
    RIGHT JOIN employees EM ON em.department_id=dep.department_id
    JOIN LOCATIONS LO ON lo.location_id=dep.location_id;
--DESAPARECEN LOS NULOS POR QUE ACTUALIZO EL ENLACE DE TABLAS

SELECT DEP.department_name, em.first_name
    FROM departments DEP
    JOIN LOCATIONS LO ON lo.location_id=dep.location_id
    RIGHT JOIN employees EM ON em.department_id=dep.department_id;
--AQUI AL ACTUALIZAR PONGO QUE SE ACTUALICE CON LOS RIGHTS NULOS

SELECT DEP.department_name, em.first_name
    FROM departments DEP
    RIGHT JOIN employees EM ON em.department_id=dep.department_id
    LEFT JOIN LOCATIONS LO ON lo.location_id=dep.location_id;
--JUGAR CON RIGHT Y LEFT

SELECT DEP.department_name, em.first_name
    FROM departments DEP
    /*RIGHT*/ JOIN LOCATIONS LO ON lo.location_id=dep.location_id
    RIGHT JOIN employees EM ON em.department_id=dep.department_id;
--AQUI CREO QUE DARIA IGUAL EL PRIMER RIGHT

SELECT DEP.department_name, (em.first_name ||' '|| em.last_name)
    FROM departments DEP
    FULL OUTER JOIN employees EM ON em.department_id=dep.department_id; 
--SACA LOS QUE NO COINCIDAN DE LOS DOS CAMPOS

SELECT *
    FROM employees EM 
    WHERE em.salary>5000 --SACA 58
MINUS --INTERSECT --UNION --ALL
SELECT * 
    FROM employees EM
    WHERE em.department_id=60; 
--UNION LOS UNE Y SACA LOS DOS
--UNION ALL SACA DUPLICADOS
--INTERSECT SOLO COMUNES
--MINUS SELECT DE ARRIBA MENOS LOS DE ABAJO
--SI QUIERES HACER UN SELECT - OTRO + OTRO... FUNCINOAN COMO MATEMATICAS, CON PARENTESIS
--UNION ALL NO MIRA DUPLICADOS, ASI TRABAJA MENOS LA MAQUINA