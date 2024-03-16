/*1. (F) �Cu�ntas personas del mundo viven en un pa�s en el que se habla el espa�ol?
--- 750296800*/
SELECT sUM(CO.population)
    FROM country CO
    JOIN countrylanguage CL ON cl.countrycode=co.code
    WHERE cl.language LIKE 'Spanish';

/*2. (F) �Cu�ntas personas del mundo viven en un pa�s en el que el espa�ol es un idioma
oficial?*/
--372190700
SELECT sUM(CO.population)
    FROM country CO
    JOIN countrylanguage CL ON cl.countrycode=co.code
    WHERE cl.language LIKE 'Spanish' AND cl.isofficial LIKE 'T';

/*3. (F) �Cu�ntas personas del mundo hablan ingles?*/
--34707786730
SELECT  SUM(CO.population * cl.percentage) TOTAL
    FROM country CO
    JOIN countrylanguage CL ON cl.countrycode=co.code
    WHERE cl.language LIKE 'English';

/*4. (F) �Cu�ntas ciudades de m�s de 500.000 habitantes tiene el continente que mas
ciudades de m�s de 500.000 tiene?*/
--248
SELECT co.continent ,COUNT(CI.ID)
    FROM country CO
    JOIN city CI ON ci.countrycode=co.code
    WHERE ci.population > 500000
    GROUP BY co.continent
    HAVING COUNT(CI.ID) = (SELECT MAX(COUNT(CI2.ID))
                            FROM country CO2
                            JOIN city CI2 ON ci2.countrycode=co2.code
                            WHERE ci2.population > 500000
                            GROUP BY co2.continent);
    

/*5. (F) �Cual es la esperanza de vida media de los pa�ses con m�s de 50 millones de
habitantes? (redondeando a 2 decimales)*/
-- 67.35
SELECT ROUND(AVG(co.lifeexpectancy),2)
    FROM country CO
    WHERE co.population > 50000000;

/*6. (F) �En cu�ntas ciudades el espa�ol es lengua oficial?*/
-- 498
SELECT COUNT(ci.id)
    FROM country CO
    JOIN countrylanguage CL ON cl.countrycode=co.code
    JOIN city CI ON ci.countrycode=co.code
    WHERE cl.language LIKE 'Spanish' AND cl.isofficial LIKE 'T';

/*7. (M) Saca la ciudad m�s poblada de cada continente .*/
SELECT CI.NAME, co.continent
    FROM country CO
    JOIN city CI ON ci.countrycode=co.code
    WHERE ci.population = (SELECT MAX(CI2.POPULATION)
                               FROM city CI2
                               JOIN country CO2 ON co2.code=ci2.countrycode
                               WHERE CO.CONTINENT = co2.continent);

/*8. (M) Agrupando por continente cuenta los pa�ses cuya esperanza de vida est� por
encima de la media de la esperanza de vida del continente.*/
SELECT co.continent, COUNT(CO.CODE)
    FROM country CO
    WHERE co.lifeexpectancy > (SELECT AVG(co2.lifeexpectancy)
                                    FROM country CO2
                                    WHERE co.continent = co2.continent)
    GROUP BY co.continent;

/*9. (M) Selecciona el pa�s m�s peque�o de cada continente de los que son m�s grandes de
100.000 km2*/
SELECT co.name, co.continent
    FROM country CO
    WHERE co.surfacearea = (SELECT MIN(CO2.surfacearea)
                                FROM country CO2
                                WHERE co.continent=co2.continent)
    AND co.continent IN (SELECT CO3.CONTINENT
                            FROM country CO3
                            GROUP BY CO3.CONTINENT
                            HAVING SUM(CO3.surfacearea) > 100000);
//SALEN TODOS

/*10. (M) Si sumas el a�o de independencia del pa�s m�s antiguo (a�o de independencia
m�nimo) de cada continente �cu�nto sale?*/
-- 5574
SELECT SUM(MIN(co.indepyear))
    FROM country CO
    GROUP BY co.continent;

SELECT SUM(ABS(MIN(co.indepyear)))
    FROM country CO
    GROUP BY co.continent;

/*11. (M) Saca la capital menos poblada de cada continente*/
SELECT co.continent, MIN(ci.name)
    FROM country CO
    JOIN city CI ON ci.id=co.capital
    GROUP BY co.continent;

/*12. (M) De los pa�ses que tienen m�s de 10 ciudades saca la media de poblaci�n de las
ciudades (adem�s del pa�s, claro)*/
SELECT co.name, ROUND(SUM(ci.population)/COUNT(CI.ID),2) MEDIA
    FROM country CO 
    JOIN city CI ON ci.countrycode=co.code
    GROUP BY co.name
    HAVING COUNT(CI.ID)>10;



