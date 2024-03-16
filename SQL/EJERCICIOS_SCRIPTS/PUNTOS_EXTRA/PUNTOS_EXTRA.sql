//EJERCICIO 01
SELECT I.* FROM INFORME_ESCENA_CRIMEN I WHERE CITY LIKE 'Gotham' AND TO_CHAR(DATE_CRIME) LIKE '20180115' AND TYPE LIKE 'murder';
SELECT D.* 
    FROM DECLARACIONES D
    INNER JOIN PERSONA P ON D.PERSON_ID=P.ID
    WHERE P.NAME LIKE '%Susan%' 
    AND P.ADDRESS_STREET_NAME LIKE '%Franklin Ave%';
    //I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
SELECT D.* 
    FROM DECLARACIONES D
    INNER JOIN PERSONA P ON D.PERSON_ID=P.ID
    WHERE P.ADDRESS_STREET_NAME LIKE '%Capital Av%' 
    ORDER BY P.ADDRESS_NUMBER DESC;
    //I heard a gunshot and then saw a man run out. He had a Get Fit Now Gym bag. 
    //The membership number on the bag started with 4. Only gold members have those bags. 
    //The man got into a car with a plate that included the letter H.
SELECT P.NAME
    FROM PERSONA P
    INNER JOIN SOCIOS_GIMNASIO S ON S.PERSON_ID=P.ID
    INNER JOIN GIMNASIO_ENTRADAS_SALIDAS GES ON S.ID=GES.MEMBERSHIP_ID
    INNER JOIN PERMISO_CIRCULACION PE ON PE.ID=P.LICENSE_ID
    WHERE TO_CHAR(GES.CHECK_IN_DATE) IN '20180109' 
    AND S.ID LIKE '4%' 
    AND S.MEMBERSHIP_STATUS LIKE 'gold' 
    AND PE.PLATE_NUMBER LIKE '%H%';
//EJERCICIO 02
SELECT D.TRANSCRIPT 
    FROM DECLARACIONES D
    INNER JOIN PERSONA P ON D.PERSON_ID=P.ID
    WHERE P.NAME LIKE'Larry Preston';
    //I was hired by a woman with a lot of money. I dont know her name but I know shes around 55 (65) or 57 (67). 
    //She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
SELECT P.NAME
    FROM PERSONA P
    INNER JOIN REDES_SOCIALES_EVENTOS RS ON RS.PERSON_ID=P.ID
    INNER JOIN PERMISO_CIRCULACION PE ON PE.ID=P.LICENSE_ID
    WHERE LOWER(PE.HAIR_COLOR) LIKE '%red%'
    AND PE.CAR_MAKE LIKE '%Tesla%'
    AND PE.CAR_MODEL LIKE '%S%'
    AND RS.EVENT_NAME LIKE '%SQL%';