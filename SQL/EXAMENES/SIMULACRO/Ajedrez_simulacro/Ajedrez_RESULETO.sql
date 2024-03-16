/*Ejercicio 1.
Sacar un informe con el nombre del país, nombre del jugador y campeonatos ganados, para
participantes que sean jugadores. La consulta debe ordenarse por nº de campeonatos
ganados de más a menos, nombre del país y nombre del jugador alfabéticamente.*/
SELECT pr.pais, pr.nombre, pr.campeonatos
    FROM participantes PR
    JOIN jugadores JU ON ju.n_asociado=pr.num_asociado
    ORDER BY 3 DESC, 1, 2;

/*Ejercicio 2.
Sacar un informe con el nombre del participante, fecha de entrada y fecha de salida,
nombre del hotel y dirección para hoteles cuya dirección sea una calle (ni plaza ni paseo) y
para alojamientos que empezasen el 22 o el 23 de abril del 2007 y acabasen el 25 o el 26
de abril del 2007.*/
SELECT pr.nombre, al.fechain, al.fechaout, ho.nombre, ho.direccion
    FROM alojamientos AL
    JOIN hoteles HO ON ho.nombre=al.hotel
    JOIN participantes PR ON pr.num_asociado=al.participante
    WHERE ho.direccion LIKE 'C%'
        AND al.fechain IN ('22/04/2007','23/04/2007')
        AND al.fechaout IN ('25/04/2007','26/04/2007');
    
SELECT * FROM HOTELES;
    

/*Ejercicio 3.
Queremos un informe con el nombre del jugador, nombre del país, número de campeonatos
ganados y número de partidas ganadas para todos los jugadores que pertenezcan a países
que tengan algún jugador que haya ganado algún campeonato.*/
SELECT pr.nombre, pr.pais, pr.campeonatos, 
        (SELECT COUNT(1)
            FROM partidas PAR
            WHERE par.ganador=pr.num_asociado) PARTIDA_GANADA
    FROM participantes PR
    JOIN jugadores JU ON ju.n_asociado=pr.num_asociado
    WHERE pr.pais IN (SELECT pr2.pais
                        FROM participantes PR2
                        WHERE pr2.campeonatos>0);

/*Ejercicio 4.
Por cada hotel muestra un informe que nos dé: el nombre del hotel, la media de entradas
vendidas en las partidas jugadas en salas de ese hotel y el total de entradas que se
quedaron sin vender.*/
SELECT ho.nombre, ROUND(AVG(ENTRADAS.entradas_hotel),2) MEDIA , SUM(ENTRADAS.capacidad)-SUM(ENTRADAS.vendidas) SIN_VENDER
        
    FROM hoteles HO
    JOIN (SELECT SA.HOTEL HOTEL, PAR.ENTRADAS ENTRADAS_HOTEL, par.entradas VENDIDAS, sa.capacidad CAPACIDAD
                FROM SALAS SA
                JOIN PARTIDAS PAR ON PAR.SALA=SA.COD_SALA) ENTRADAS
            ON ENTRADAS.hotel=ho.nombre
    GROUP BY HO.NOMBRE;

/*Ejercicio 5.
Haz una consulta que me de el nombre de los participantes, si son JUGADOR o ÁRBITRO
y un campo de totales que contará: si es jugador el número de partidas ganadas y si es
árbitro el número de partidas arbitradas. Sólo para jugadores de países que tengan más de
3 participantes*/
SELECT pr.nombre, pr.tipo,
    CASE WHEN PR.TIPO LIKE 'JUGADOR' 
    THEN (SELECT COUNT(1)
            FROM partidas PAR
            WHERE par.ganador=PR.NUM_ASOCIADO)
    ELSE (SELECT COUNT(1)
            FROM partidas PAR2
            WHERE par2.arbitro=PR.NUM_ASOCIADO)
    END CONTEO
    FROM participantes PR
    WHERE pr.pais IN (SELECT PR2.PAIS
                        FROM participantes PR2
                        GROUP BY PR2.PAIS
                        HAVING COUNT(PR2.NUM_ASOCIADO)>=3);
    

/*Ejercicio 6.
Queremos saber el número de partidas que se han iniciado con el movimiento: P3x4Q  */
SELECT COUNT(1)
    FROM movimientos MOV
    WHERE mov.jugada LIKE 'P3x4Q' 
    AND mov.comentario LIKE 'comienza%';

/*Ejercicio 7.
Necesitamos un informe que indique
? Código de partida PATIDA
? Nombre del jugador que jugaba con blancas CONTRINCANTE
? Nombre del jugador que jugaba con negras CONTRINCANTE
? Árbitro PART
? Nombre del ganador PART Y PARTIDA
? Número de movimientos de la partida MOVI*/ 
SELECT par.cod_partida, 
        (SELECT pa2.nombre
            FROM contrincantes CON2 
            JOIN jugadores JU2 ON con2.jugador=ju2.n_asociado
            JOIN participantes PA2 ON pa2.num_asociado=ju2.n_asociado
            WHERE con2.partida=PAR.COD_PARTIDA
            AND UPPER(con2.color) LIKE 'BLANCAS') NOMBRE_BLANCAS,
            
        (SELECT pa3.nombre
            FROM contrincantes CON3
            JOIN jugadores JU3 ON con3.jugador=ju3.n_asociado
            JOIN participantes PA3 ON pa3.num_asociado=ju3.n_asociado
            WHERE con3.partida=PAR.COD_PARTIDA
            AND UPPER(con3.color) LIKE 'NEGRAS') NOMBRE_NEGRAS,
        
        (SELECT pa4.nombre
            FROM PARTIDAS PAR2
            JOIN participantes PA4 ON par2.arbitro=pa4.num_asociado
            WHERE par2.cod_partida=PAR.COD_PARTIDA) ARBITRO,
        
        (SELECT pa4.nombre
            FROM PARTIDAS PAR2
            JOIN participantes PA4 ON par2.GANADOR=pa4.num_asociado
            WHERE par2.cod_partida=PAR.COD_PARTIDA) GANADOR,
        
        (SELECT COUNT(mov.jugada)
            FROM movimientos MOV
            WHERE mov.partida=PAR.COD_PARTIDA) MOVIMIENTOS
        
    FROM partidas PAR;

/*Ejercicio 8.
Haz un listado de las salas en las que no se hayan vendido 50 entradas contando todas las
partidas jugadas en esa sala.*/
SELECT sa.cod_sala 
    FROM SALAS SA
    WHERE 50<(SELECT SUM(par.entradas)
                FROM partidas PAR
                WHERE par.sala=sa.cod_sala);
    

/*Ejercicio 9.
Haz un listado con el código de partida y el ganador de la partida que más entradas vendió en cada
sala.*/
SELECT sa.cod_sala, TABLA.ganador, TABLA.cpar
    FROM salas SA
    JOIN (SELECT PAR.SALA SALA , par.cod_partida CPAR, par.ganador GANADOR, par.entradas ENTRADAS
            FROM partidas PAR
            GROUP BY par.cod_partida, par.ganador,PAR.SALA, par.entradas ) TABLA
        ON TABLA.sala=sa.cod_sala
    WHERE TABLA.entradas = (SELECT MAX(par2.entradas)
            FROM partidas PAR2
            WHERE par2.sala=sa.cod_sala)
    ORDER BY 1;
        
            

/*Ejercicio 10.
Haz una consulta que me de por país:
? nombre del país
? número de jugadores del país
? nivel medio de los jugadores (redondeado a 1 decimal)
? total de partidas jugadas
Siempre que el jugador de menos nivel del país sea al menos de nivel 3*/
SELECT  pa.pais PAIS, COUNT(pa.num_asociado) CONTEO, ROUND(AVG(ju.nivel),2) NVL_MEDIO, SUM(ju.num_partidas)TOTAL_PARTIDAS
    FROM participantes PA
    JOIN jugadores JU ON ju.n_asociado=pa.num_asociado
    GROUP BY pa.pais
    HAVING MIN(JU.NIVEL)>=3;
    
    
    
