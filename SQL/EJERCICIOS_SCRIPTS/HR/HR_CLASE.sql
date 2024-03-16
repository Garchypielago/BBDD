SELECT DE.DEPARTMENT_NAME, EM.*
    FROM EMPLOYEES EM
    JOIN DEPARTMENTS DE ON DE.DEPARTMENT_ID=em.department_id
    WHERE EM.salary IN (SELECT MIN(EM2.SALARY) 
            FROM EMPLOYEES EM2 
            GROUP BY em2.department_id);
SELECT DE.DEPARTMENT_NAME, EM.*
    FROM EMPLOYEES EM
    JOIN DEPARTMENTS DE ON DE.DEPARTMENT_ID=em.department_id
    WHERE 
        (EM.salary=(SELECT MIN(EM2.SALARY) 
        FROM EMPLOYEES EM2 
        WHERE em.department_id=em2.department_id))
    OR 
        (EM.salary=(SELECT MAX(EM2.SALARY) 
        FROM EMPLOYEES EM2 
        WHERE em.department_id=em2.department_id));
        
        
SELECT EM.DEPARTMENT_ID DEPARTAMENTO, MIN(EM.SALARY) SALARIO, MAX(EM.SALARY) SALARIO2
    FROM EMPLOYEES EM 
    GROUP BY em.department_id;
    
SELECT DE.DEPARTMENT_NAME, EM.*
    FROM EMPLOYEES EM
    JOIN DEPARTMENTS DE ON DE.DEPARTMENT_ID=em.department_id
    JOIN (SELECT EM.DEPARTMENT_ID DEPARTAMENTO , MIN(EM.SALARY) SALARIO, MAX(EM.SALARY) SALARIO2
        FROM EMPLOYEES EM 
        GROUP BY em.department_id) TABLA ON TABLA.departamento=de.department_id /*DEVUELVE EL SAL MIN DE CADA DEPART*/
    WHERE em.salary=TABLA.salario OR em.salary=TABLA.salario2;
        
        
SELECT job.job_title, em.first_name, (SELECT COUNT(1) 
                        FROM EMPLOYEES EM3
                        WHERE EM.JOB_ID=EM3.JOB_ID)EMLPEADOS
                        
    FROM EMPLOYEES EM
    JOIN JOBS JOB ON job.job_id=em.job_id
    JOIN (SELECT MAX(EM2.SALARY) SALARIO, job2.job_id TRABAJO
        FROM EMPLOYEES EM2
        JOIN JOBS JOB2 ON job2.job_id=em2.job_id
        GROUP BY job2.job_id) TABLA ON TABLA.trabajo=em.job_id
    WHERE em.salary=TABLA.salario;
    
SELECT JOB.JOB_TITLE, EM.SALARY
    FROM EMPLOYEES EM
    JOIN JOBS JOB ON em.job_id=job.job_id
    WHERE em.salary=(SELECT MAX(EM2.SALARY)
                    FROM employees EM2
                    WHERE EM.JOB_ID=EM2.JOB_ID);

/*SELECT * FROM (SELECT ar.name, SUM(inl.quantity)
                    FROM ARTIST AR 
                    JOIN ALBUM AL ON al.artistid=ar.artistid
                    JOIN TRACK TR ON tr.albumid=al.albumid
                    JOIN invoiceline INL ON inl.trackid=tr.trackid
                    GROUP BY ar.name
                    ORDER BY 2 DESC)
    WHERE ROWNUM<2;
*/ --ESTO ES DE CHINOOK
    