-- 1. Crear un usuario llamado PRUEBA_EJERCICIO
CREATE USER PRUEBA_EJERCICIO IDENTIFIED BY PRUEBA
  DEFAULT TABLESPACE USERS
  QUOTA 1M ON USERS;

-- 2. Modificar la contraseña de PRUEBA_EJERCICIO a NUEVA_PRUEBA y desbloquear la cuenta
ALTER USER PRUEBA_EJERCICIO IDENTIFIED BY NUEVA_PRUEBA ACCOUNT UNLOCK;

-- 3. Asignar permisos de conexión al usuario PRUEBA_EJERCICIO
GRANT CONNECT TO PRUEBA_EJERCICIO;

-- 4. Asignar permisos de INSERT y UPDATE sobre la tabla EMPLOYEES del esquema HR
GRANT INSERT, UPDATE ON HR.EMPLOYEES TO PRUEBA_EJERCICIO;

-- 5. Asignar al usuario PRUEBA_EJERCICIO la posibilidad de crear tablas
GRANT CREATE TABLE TO PRUEBA_EJERCICIO;

-- Comprobar que puede crear tablas
-- Conectar con PRUEBA_EJERCICIO y ejecutar el siguiente comando:
-- CREATE TABLE PRUEBA_TABLE (ID NUMBER, NAME VARCHAR2(50));

-- 6. Quitar al usuario PRUEBA_EJERCICIO la posibilidad de crear tablas
REVOKE CREATE TABLE FROM PRUEBA_EJERCICIO;

-- Comprobar que ya no puede crear tablas
-- Conectar con PRUEBA_EJERCICIO y ejecutar el siguiente comando:
-- CREATE TABLE OTRA_PRUEBA_TABLE (ID NUMBER, NAME VARCHAR2(50));