
ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy hh24:mi';

-- CREACIoN DE TABLAS

CREATE TABLE Departamentos (
        ID NUMBER(6) PRIMARY KEY,
        Nombre VARCHAR2(25) NOT NULL );


CREATE TABLE Empleados (
	ID NUMBER(6) PRIMARY KEY,
	Nombre VARCHAR2(20) NOT NULL,
	Apellido1 VARCHAR2(20) NOT NULL,
	Apellido2 VARCHAR2(20) NOT NULL,
	Sueldo NUMBER(9),
	Telefono VARCHAR(15),
	Departamento  NUMBER(6),
	Cargo VARCHAR2(25),
	Direccion VARCHAR2(500));


ALTER TABLE Empleados 
	ADD CONSTRAINT fk_1 FOREIGN KEY(Departamento) REFERENCES Departamentos;

CREATE TABLE LibrosComprados (
	ID NUMBER(6) PRIMARY KEY,
	Departamento NUMBER(6),
	ISBN VARCHAR2(500) NOT NULL );

ALTER TABLE LibrosComprados 
	ADD CONSTRAINT fk_2 FOREIGN KEY(Departamento) REFERENCES Departamentos;

CREATE SEQUENCE LIBROSCOMPRADOS_SEC INCREMENT BY 1 MAXVALUE 999999 MINVALUE 1 CACHE 20;

CREATE TABLE LlamadasTelefonicas (
        ID NUMBER(6) PRIMARY KEY,
        origen VARCHAR2(15),
        Destino VARCHAR2(15),
	HoraInicio DATE,
	HoraFin DATE);


CREATE SEQUENCE LLAMADASTELEFONICAS_SEC INCREMENT BY 1 MAXVALUE 999999 MINVALUE 1 CACHE 20;

CREATE TABLE Fichajes (
        Hora DATE NOT NULL,
        Empleado NUMBER(6),
	Tipo VARCHAR2(10),
	CONSTRAINT pk_Fichajes PRIMARY KEY(Hora,Empleado));

ALTER TABLE Fichajes 
	ADD CONSTRAINT fk_3 FOREIGN KEY(Empleado) REFERENCES Empleados;

CREATE TABLE DocumentosImprimidos (
        Hora DATE PRIMARY KEY,
        Documento2 VARCHAR(250) NOT NULL,
        Descripcion VARCHAR(250) );

CREATE TABLE Agenda (
        Hora DATE PRIMARY KEY,
        Descripcion VARCHAR(250) NOT NULL );


-- DATOS DE Departamentos

INSERT INTO Departamentos (ID,Nombre) VALUES (1, 'Direccion General');
INSERT INTO Departamentos (ID,Nombre) VALUES (2, 'I+D');
INSERT INTO Departamentos (ID,Nombre) VALUES (3, 'Laboratorio');
INSERT INTO Departamentos (ID,Nombre) VALUES (4, 'Epidemiologia');
INSERT INTO Departamentos (ID,Nombre) VALUES (5, 'Oncologia');
INSERT INTO Departamentos (ID,Nombre) VALUES (6, 'IT');
INSERT INTO Departamentos (ID,Nombre) VALUES (7, 'Sistemas Informaticos');
INSERT INTO Departamentos (ID,Nombre) VALUES (8, 'Comercial');
INSERT INTO Departamentos (ID,Nombre) VALUES (9, 'R+H');
INSERT INTO Departamentos (ID, Nombre) VALUES (10, 'Limpieza');



--DATOS DE Empleados

INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (1,'Jan','Cameron','Murphy',70000,938740101,'1','Director general', 'Gran 43, Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (2,'Xavier','Sevilla','Gagarin',22000,938740102,'1','Secretario', 'Trinitat 12, 5  Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
	VALUES (3,'Leonard','Cameron','Callaghan',40000,938740201,'2','Director I+D', 'Guillem Cata 9, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (4,'Fran','Abbot','Edison',30000,938740202,'2','Investigador senior', 'Major 13, 3 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (5,'Neus','Ferrari','Caldwell',25000,938740203,'2','Investigador junior', 'Pascal 23, 2 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (28,'Fran','Lebaque','Chamin',20000,938740204,'2','Secretario', 'Balmes 72, 4 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (6,'Matilda','Yellow','Vaca',38000,938740301,'3','Investigadora jefe', 'Guillem Cata 9, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (7,'Eduard','Roja','Valdes',33000,938740302,'3','Investigador senior', 'Sant Andreu 44, Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (8,'Guillermina','Fructuos','Amstel',29000,938740303,'3','Investigador junior', 'Cardona 12, 4 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (30,'Ben','Harris','Neal',20000,938740304,'3','Secretario', 'Pere III 68, 6 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (9,'Oriol','Gran','Macias',35000,938740401,'4','Jefe de Epidemiologia', 'Universitat 23, 8 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (10,'Gorka','Boniquet','Fiedler',33000,938740402,'4','Epidemiologia senior', 'Londres 13, Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (11,'Naiara','Fournier','Bakshi',27000,938740403,'4','Epidemiologia junior', 'Paris 54, 5 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (12,'Laura','Essa','Naser',36000,938740501,'5','Jefe de Oncologia', 'Gaudi 24, Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (13,'Mafalda','Olivier','Patel',32000,938740502,'5','Oncologia senior', 'Picasso 57, 7 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (14,'Aldo','Garcia','Delgado',23000,938740503,'5','Oncologia junior', 'Velazquez 499, 2 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (15,'Qiu','Chan','Zhu',37000,938740601,'6','IT Jefe', 'Reina 243, 5 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (16,'Vicente','Avilers','Murphy',34000,938740602,'6','IT senior', 'Centelles 543, 6 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (17,'Maria Veronica','Cabello','Mans',26000,938740603,'6','IT junior', 'Horticultor Corset 79, 2 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (18,'David','Burman','Tahan',40000,938740701,'7','Engeniero de Sistemas', 'Colorado 43, Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (19,'Victoria','Ganim','Dalal',40000,938740702,'7','Tecnico de seguridad', 'Everest 85, 4 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (20,'Olga','Da Costa','Van Hal',18000,938740703,'7','Becario', 'Miseria 12, 9 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (21,'Marc','Cameron','Callaghan',35000,938740801,'8','Director comercial', 'Mediterrani 111, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (22,'Xenia','Kumar','Ray',35000,938740802,'8','comercial', 'Elba 232, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (23,'Saidou','Antar','Morcos',35000,938740803,'8','Marketing', 'Garona 16, 12 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (29,'Ona','Cortina','Garrett',20000,938740804,'8','Secretario', 'Tallers 61, 8 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (24,'Fatima','Bracamonte','Papadopoulus',35000,938740901,'9','Administrativa', 'Lepant 327, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (25,'Nicolai','Rytas','Yanovich',35000,938740902,'9','Administrativo', 'Còrcega 31, 1 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (26,'Mireia','Rojo','Callus',19000,null,'10','Limpieza', 'Rossello 55, 6 Barcelona');
INSERT INTO Empleados (ID, Nombre, Apellido1, Apellido2, Sueldo, Telefono, Departamento, Cargo, Direccion )
        VALUES (27,'Jordi','Casp','Valldaura',19000,null,'10','Limpieza', 'Industria 77, 3 Barcelona');



-- DATOS DE LlamadasTelefonicas
-- DATOS DE LlamadasTelefonicas DEL DIA 12/10/20
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740202, 938740602, to_date('2020-10-12 09:11','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 09:23','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740801, 938740203,  to_date('2020-10-14 15:35','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 15:53','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740304, 935442323, to_date('2020-10-12 09:26','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 09:36','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740901, 935335646, to_date('2020-10-12 09:45','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 09:49','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740402, 938740998, to_date('2020-10-12 10:11','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 10:43','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740804, 0074952217777, to_date('2020-10-12 10:20','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 10:40','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740602, 938740701, to_date('2020-10-12 10:59','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 11:22','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740101, 934679955, to_date('2020-10-12 11:44','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 12:03','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740402, 934522353, to_date('2020-10-12 12:34','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 12:57','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740202, 937844496, to_date('2020-10-12 15:36','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 15:57','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740801, 931288000, to_date('2020-10-12 16:39','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 16:55','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 938740501, to_date('2020-10-12 18:05','yyyy-mm-dd hh24:mi'), to_date('2020-10-12 18:15','yyyy-mm-dd hh24:mi'));


-- DATOS DE LlamadasTelefonicas DEL DIA 13/10/20
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 938731577, to_date('2020-10-13 11:24','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 11:34','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740803, 938760077, to_date('2020-10-13 12:30','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 12:39','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740804, 939760077, to_date('2020-10-13 15:45','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 15:48','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 935460667, to_date('2020-10-13 15:47','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 16:44','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 935403355, to_date('2020-10-13 15:52','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 16:12','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740902, 932458653, to_date('2020-10-13 15:54','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 16:15','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740901, 932457783, to_date('2020-10-13 16:42','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 16:51','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740803, 932452676, to_date('2020-10-13 16:58','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 17:12','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740801, 932452676, to_date('2020-10-13 17:38','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 17:47','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740302, 939747362, to_date('2020-10-13 17:46','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 17:57','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740401, 935682348, to_date('2020-10-13 17:41','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740501, 938740201, to_date('2020-10-13 18:04','yyyy-mm-dd hh24:mi'), to_date('2020-10-13 18:14','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740801, 938740203,  to_date('2020-10-14 15:35','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 15:53','yyyy-mm-dd hh24:mi'));


-- DATOS DE LlamadasTelefonicas DEL DIA 14/10/20
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 938660701, to_date('2020-10-14 09:10','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 09:22','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740304, 935442333, to_date('2020-10-14 09:25','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 09:32','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740902, 935335777, to_date('2020-10-14 09:44','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 09:49','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740401, 938740601, to_date('2020-10-14 10:31','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 10:40','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740601, 938740701, to_date('2020-10-14 10:59','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 11:25','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 934679222, to_date('2020-10-14 11:41','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 12:02','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740401, 934556653, to_date('2020-10-14 12:33','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 12:47','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740203, 938740801, to_date('2020-10-14 15:35','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 15:53','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740802, 931288534, to_date('2020-10-14 16:38','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 16:50','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 938740501, to_date('2020-10-14 18:07','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 18:15','yyyy-mm-dd hh24:mi'));

-- DATOS DE LlamadasTelefonicas DEL DIA 15/10/20
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
	VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 938731527, to_date('2020-10-15 11:21','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 11:33','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
	VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740803, 938760077, to_date('2020-10-15 12:34','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 12:39','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740804, 939760077, to_date('2020-10-15 15:30','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 15:36','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 935460667, to_date('2020-10-15 15:42','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 15:44','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 935403355, to_date('2020-10-15 15:52','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 16:09','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740902, 932458653, to_date('2020-10-15 15:53','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 16:10','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740901, 932457783, to_date('2020-10-15 16:43','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 16:50','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740803, 932452676, to_date('2020-10-15 16:59','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 17:12','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740801, 932452676, to_date('2020-10-15 17:39','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 17:43','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL,  938740203, 938740801, to_date('2020-10-14 15:35','yyyy-mm-dd hh24:mi'), to_date('2020-10-14 15:53','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740302, 939747362, to_date('2020-10-15 17:40','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 17:52','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740401, 935682348, to_date('2020-10-15 17:51','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 18:00','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 938740501, to_date('2020-10-15 18:01','yyyy-mm-dd hh24:mi'), to_date('2020-10-15 18:12','yyyy-mm-dd hh24:mi'));

-- DATOS DE LlamadasTelefonicas DEL DIA 16/10/20
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740601, 938740701, to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 09:12','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740202, 935682333, to_date('2020-10-16 09:15','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 09:22','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740301, 935535777, to_date('2020-10-16 09:34','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 09:39','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740402, 931537655, to_date('2020-10-16 09:51','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 10:10','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740601, 938740701, to_date('2020-10-16 10:19','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 10:25','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740102, 934679223, to_date('2020-10-16 10:41','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 11:03','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740304, 934556673, to_date('2020-10-16 12:33','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 12:57','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740204, 937845366, to_date('2020-10-16 15:30','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 15:23','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740804, 931276534, to_date('2020-10-16 16:18','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 16:30','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740201, 938740203, to_date('2020-10-16 17:15','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 17:17','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740902, 935682348, to_date('2020-10-16 17:41','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 17:59','yyyy-mm-dd hh24:mi'));
INSERT INTO LlamadasTelefonicas (ID,origen,Destino,HoraInicio,HoraFin)
        VALUES (LlamadasTelefonicas_sec.NEXTVAL, 938740501, 938740201, to_date('2020-10-16 18:03','yyyy-mm-dd hh24:mi'), to_date('2020-10-16 18:07','yyyy-mm-dd hh24:mi'));



--DATOS DE Fichajes

INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:00','yyyy-mm-dd hh24:mi'), 2,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:00','yyyy-mm-dd hh24:mi'), 2,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:00','yyyy-mm-dd hh24:mi'), 2,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'), 2,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:00','yyyy-mm-dd hh24:mi'), 2,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:00','yyyy-mm-dd hh24:mi'), 2,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:00','yyyy-mm-dd hh24:mi'), 2,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:00','yyyy-mm-dd hh24:mi'), 2,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), 2,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:00','yyyy-mm-dd hh24:mi'), 2,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:00','yyyy-mm-dd hh24:mi'), 3,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:16','yyyy-mm-dd hh24:mi'), 3,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:12','yyyy-mm-dd hh24:mi'), 3,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:15','yyyy-mm-dd hh24:mi'), 3,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:15','yyyy-mm-dd hh24:mi'), 3,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:16','yyyy-mm-dd hh24:mi'), 3,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:23','yyyy-mm-dd hh24:mi'), 3,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:13','yyyy-mm-dd hh24:mi'), 3,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:21','yyyy-mm-dd hh24:mi'), 3,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:03','yyyy-mm-dd hh24:mi'), 4,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:04','yyyy-mm-dd hh24:mi'), 4,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:06','yyyy-mm-dd hh24:mi'), 4,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:04','yyyy-mm-dd hh24:mi'), 4,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:03','yyyy-mm-dd hh24:mi'), 4,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:07','yyyy-mm-dd hh24:mi'), 4,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:40','yyyy-mm-dd hh24:mi'), 5,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:00','yyyy-mm-dd hh24:mi'), 5,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:50','yyyy-mm-dd hh24:mi'), 5,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'), 5,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:55','yyyy-mm-dd hh24:mi'), 5,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:01','yyyy-mm-dd hh24:mi'), 5,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:42','yyyy-mm-dd hh24:mi'), 5,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:02','yyyy-mm-dd hh24:mi'), 5,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:52','yyyy-mm-dd hh24:mi'), 5,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:12','yyyy-mm-dd hh24:mi'), 5,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:10','yyyy-mm-dd hh24:mi'), 6,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:00','yyyy-mm-dd hh24:mi'), 6,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:12','yyyy-mm-dd hh24:mi'), 6,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'), 6,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:15','yyyy-mm-dd hh24:mi'), 6,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:01','yyyy-mm-dd hh24:mi'), 6,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:23','yyyy-mm-dd hh24:mi'), 6,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:01','yyyy-mm-dd hh24:mi'), 6,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), 6,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:00','yyyy-mm-dd hh24:mi'), 6,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 08:50','yyyy-mm-dd hh24:mi'), 7,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:00','yyyy-mm-dd hh24:mi'), 7,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:01','yyyy-mm-dd hh24:mi'), 7,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'), 7,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:02','yyyy-mm-dd hh24:mi'), 7,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:05','yyyy-mm-dd hh24:mi'), 7,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:04','yyyy-mm-dd hh24:mi'), 7,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:00','yyyy-mm-dd hh24:mi'), 7,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:03','yyyy-mm-dd hh24:mi'), 7,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:00','yyyy-mm-dd hh24:mi'), 7,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:02','yyyy-mm-dd hh24:mi'), 8,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:04','yyyy-mm-dd hh24:mi'), 8,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:05','yyyy-mm-dd hh24:mi'), 8,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:04','yyyy-mm-dd hh24:mi'), 8,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:50','yyyy-mm-dd hh24:mi'), 8,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:00','yyyy-mm-dd hh24:mi'), 8,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:06','yyyy-mm-dd hh24:mi'), 8,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:45','yyyy-mm-dd hh24:mi'), 8,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), 8,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:00','yyyy-mm-dd hh24:mi'), 8,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:10','yyyy-mm-dd hh24:mi'), 9,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:00','yyyy-mm-dd hh24:mi'), 9,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:02','yyyy-mm-dd hh24:mi'), 9,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:00','yyyy-mm-dd hh24:mi'), 9,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:03','yyyy-mm-dd hh24:mi'), 9,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 17:40','yyyy-mm-dd hh24:mi'), 9,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:05','yyyy-mm-dd hh24:mi'), 9,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:30','yyyy-mm-dd hh24:mi'), 9,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), 9,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:10','yyyy-mm-dd hh24:mi'), 9,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:30','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:40','yyyy-mm-dd hh24:mi'), 10,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:30','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 17:50','yyyy-mm-dd hh24:mi'), 10,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:05','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:03','yyyy-mm-dd hh24:mi'), 10,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:00','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:04','yyyy-mm-dd hh24:mi'), 10,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:02','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:03','yyyy-mm-dd hh24:mi'), 10,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:30','yyyy-mm-dd hh24:mi'), 11,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:40','yyyy-mm-dd hh24:mi'), 11,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:35','yyyy-mm-dd hh24:mi'), 11,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 17:55','yyyy-mm-dd hh24:mi'), 11,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:05','yyyy-mm-dd hh24:mi'), 11,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:05','yyyy-mm-dd hh24:mi'), 11,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:05','yyyy-mm-dd hh24:mi'), 11,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:04','yyyy-mm-dd hh24:mi'), 11,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:05','yyyy-mm-dd hh24:mi'), 11,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:03','yyyy-mm-dd hh24:mi'), 11,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:02','yyyy-mm-dd hh24:mi'), 12,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:16','yyyy-mm-dd hh24:mi'), 12,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:03','yyyy-mm-dd hh24:mi'), 12,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:15','yyyy-mm-dd hh24:mi'), 12,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:04','yyyy-mm-dd hh24:mi'), 12,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:16','yyyy-mm-dd hh24:mi'), 12,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:05','yyyy-mm-dd hh24:mi'), 12,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:13','yyyy-mm-dd hh24:mi'), 12,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:08','yyyy-mm-dd hh24:mi'), 12,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:04','yyyy-mm-dd hh24:mi'), 13,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:22','yyyy-mm-dd hh24:mi'), 13,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:24','yyyy-mm-dd hh24:mi'), 13,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:12','yyyy-mm-dd hh24:mi'), 13,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:18','yyyy-mm-dd hh24:mi'), 13,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:15','yyyy-mm-dd hh24:mi'), 13,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:17','yyyy-mm-dd hh24:mi'), 13,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:24','yyyy-mm-dd hh24:mi'), 13,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:02','yyyy-mm-dd hh24:mi'), 13,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:10','yyyy-mm-dd hh24:mi'), 13,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:09','yyyy-mm-dd hh24:mi'), 14,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:22','yyyy-mm-dd hh24:mi'), 14,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:00','yyyy-mm-dd hh24:mi'), 14,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:22','yyyy-mm-dd hh24:mi'), 14,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:14','yyyy-mm-dd hh24:mi'), 14,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:01','yyyy-mm-dd hh24:mi'), 14,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:10','yyyy-mm-dd hh24:mi'), 14,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:03','yyyy-mm-dd hh24:mi'), 14,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:12','yyyy-mm-dd hh24:mi'), 14,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:09','yyyy-mm-dd hh24:mi'), 14,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:11','yyyy-mm-dd hh24:mi'), 15,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:23','yyyy-mm-dd hh24:mi'), 15,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:22','yyyy-mm-dd hh24:mi'), 15,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:08','yyyy-mm-dd hh24:mi'), 15,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:16','yyyy-mm-dd hh24:mi'), 15,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:17','yyyy-mm-dd hh24:mi'), 15,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:04','yyyy-mm-dd hh24:mi'), 15,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:11','yyyy-mm-dd hh24:mi'), 15,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:03','yyyy-mm-dd hh24:mi'), 15,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:00','yyyy-mm-dd hh24:mi'), 15,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:24','yyyy-mm-dd hh24:mi'), 16,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:04','yyyy-mm-dd hh24:mi'), 16,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:09','yyyy-mm-dd hh24:mi'), 16,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:11','yyyy-mm-dd hh24:mi'), 16,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:23','yyyy-mm-dd hh24:mi'), 16,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:05','yyyy-mm-dd hh24:mi'), 16,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:18','yyyy-mm-dd hh24:mi'), 16,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:02','yyyy-mm-dd hh24:mi'), 16,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:08','yyyy-mm-dd hh24:mi'), 16,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:23','yyyy-mm-dd hh24:mi'), 16,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:04','yyyy-mm-dd hh24:mi'), 17,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:19','yyyy-mm-dd hh24:mi'), 17,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:05','yyyy-mm-dd hh24:mi'), 17,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:10','yyyy-mm-dd hh24:mi'), 17,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:15','yyyy-mm-dd hh24:mi'), 17,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:02','yyyy-mm-dd hh24:mi'), 17,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:17','yyyy-mm-dd hh24:mi'), 17,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:14','yyyy-mm-dd hh24:mi'), 17,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:06','yyyy-mm-dd hh24:mi'), 17,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:05','yyyy-mm-dd hh24:mi'), 17,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:17','yyyy-mm-dd hh24:mi'), 18,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:04','yyyy-mm-dd hh24:mi'), 18,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:13','yyyy-mm-dd hh24:mi'), 18,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:20','yyyy-mm-dd hh24:mi'), 18,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:11','yyyy-mm-dd hh24:mi'), 18,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:16','yyyy-mm-dd hh24:mi'), 18,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:21','yyyy-mm-dd hh24:mi'), 18,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:18','yyyy-mm-dd hh24:mi'), 18,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:02','yyyy-mm-dd hh24:mi'), 18,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:08','yyyy-mm-dd hh24:mi'), 18,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:15','yyyy-mm-dd hh24:mi'), 19,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:11','yyyy-mm-dd hh24:mi'), 19,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:03','yyyy-mm-dd hh24:mi'), 19,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:09','yyyy-mm-dd hh24:mi'), 19,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:20','yyyy-mm-dd hh24:mi'), 19,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:23','yyyy-mm-dd hh24:mi'), 19,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:12','yyyy-mm-dd hh24:mi'), 19,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:00','yyyy-mm-dd hh24:mi'), 19,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:04','yyyy-mm-dd hh24:mi'), 19,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:05','yyyy-mm-dd hh24:mi'), 19,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:20','yyyy-mm-dd hh24:mi'), 20,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:17','yyyy-mm-dd hh24:mi'), 20,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:22','yyyy-mm-dd hh24:mi'), 20,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:24','yyyy-mm-dd hh24:mi'), 20,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:06','yyyy-mm-dd hh24:mi'), 20,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:19','yyyy-mm-dd hh24:mi'), 20,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:15','yyyy-mm-dd hh24:mi'), 20,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:12','yyyy-mm-dd hh24:mi'), 20,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:03','yyyy-mm-dd hh24:mi'), 20,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:29','yyyy-mm-dd hh24:mi'), 20,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:10','yyyy-mm-dd hh24:mi'), 21,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:13','yyyy-mm-dd hh24:mi'), 21,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:22','yyyy-mm-dd hh24:mi'), 21,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:17','yyyy-mm-dd hh24:mi'), 21,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:06','yyyy-mm-dd hh24:mi'), 21,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:26','yyyy-mm-dd hh24:mi'), 21,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:14','yyyy-mm-dd hh24:mi'), 22,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:13','yyyy-mm-dd hh24:mi'), 22,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:10','yyyy-mm-dd hh24:mi'), 22,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:11','yyyy-mm-dd hh24:mi'), 22,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:00','yyyy-mm-dd hh24:mi'), 22,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:22','yyyy-mm-dd hh24:mi'), 22,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:17','yyyy-mm-dd hh24:mi'), 22,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:19','yyyy-mm-dd hh24:mi'), 22,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:02','yyyy-mm-dd hh24:mi'), 22,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:15','yyyy-mm-dd hh24:mi'), 22,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:02','yyyy-mm-dd hh24:mi'), 23,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:24','yyyy-mm-dd hh24:mi'), 23,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:06','yyyy-mm-dd hh24:mi'), 23,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:03','yyyy-mm-dd hh24:mi'), 23,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:21','yyyy-mm-dd hh24:mi'), 23,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:24','yyyy-mm-dd hh24:mi'), 23,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:13','yyyy-mm-dd hh24:mi'), 23,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:06','yyyy-mm-dd hh24:mi'), 23,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:05','yyyy-mm-dd hh24:mi'), 23,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:21','yyyy-mm-dd hh24:mi'), 23,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:09','yyyy-mm-dd hh24:mi'), 24,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:23','yyyy-mm-dd hh24:mi'), 24,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:16','yyyy-mm-dd hh24:mi'), 24,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:05','yyyy-mm-dd hh24:mi'), 24,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:24','yyyy-mm-dd hh24:mi'), 24,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:13','yyyy-mm-dd hh24:mi'), 24,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:03','yyyy-mm-dd hh24:mi'), 24,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:13','yyyy-mm-dd hh24:mi'), 24,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:00','yyyy-mm-dd hh24:mi'), 24,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:02','yyyy-mm-dd hh24:mi'), 24,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:11','yyyy-mm-dd hh24:mi'), 25,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:16','yyyy-mm-dd hh24:mi'), 25,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:16','yyyy-mm-dd hh24:mi'), 25,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:17','yyyy-mm-dd hh24:mi'), 25,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:14','yyyy-mm-dd hh24:mi'), 25,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:22','yyyy-mm-dd hh24:mi'), 25,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:23','yyyy-mm-dd hh24:mi'), 25,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:06','yyyy-mm-dd hh24:mi'), 25,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:01','yyyy-mm-dd hh24:mi'), 25,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:02','yyyy-mm-dd hh24:mi'), 25,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:17','yyyy-mm-dd hh24:mi'), 26,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:12','yyyy-mm-dd hh24:mi'), 26,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:19','yyyy-mm-dd hh24:mi'), 26,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:06','yyyy-mm-dd hh24:mi'), 26,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:12','yyyy-mm-dd hh24:mi'), 26,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:19','yyyy-mm-dd hh24:mi'), 26,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:02','yyyy-mm-dd hh24:mi'), 26,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:08','yyyy-mm-dd hh24:mi'), 26,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:03','yyyy-mm-dd hh24:mi'), 26,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:20','yyyy-mm-dd hh24:mi'), 26,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:13','yyyy-mm-dd hh24:mi'), 27,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:24','yyyy-mm-dd hh24:mi'), 27,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:14','yyyy-mm-dd hh24:mi'), 27,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:21','yyyy-mm-dd hh24:mi'), 27,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:21','yyyy-mm-dd hh24:mi'), 27,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:12','yyyy-mm-dd hh24:mi'), 27,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:14','yyyy-mm-dd hh24:mi'), 27,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:16','yyyy-mm-dd hh24:mi'), 27,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:06','yyyy-mm-dd hh24:mi'), 27,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:05','yyyy-mm-dd hh24:mi'), 27,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:18','yyyy-mm-dd hh24:mi'), 28,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:10','yyyy-mm-dd hh24:mi'), 28,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:22','yyyy-mm-dd hh24:mi'), 28,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:01','yyyy-mm-dd hh24:mi'), 28,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:04','yyyy-mm-dd hh24:mi'), 28,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:08','yyyy-mm-dd hh24:mi'), 28,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:20','yyyy-mm-dd hh24:mi'), 28,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:05','yyyy-mm-dd hh24:mi'), 28,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:07','yyyy-mm-dd hh24:mi'), 10,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:17','yyyy-mm-dd hh24:mi'), 28,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:03','yyyy-mm-dd hh24:mi'), 29,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:08','yyyy-mm-dd hh24:mi'), 29,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:18','yyyy-mm-dd hh24:mi'), 29,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:19','yyyy-mm-dd hh24:mi'), 29,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:19','yyyy-mm-dd hh24:mi'), 29,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:11','yyyy-mm-dd hh24:mi'), 29,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:16','yyyy-mm-dd hh24:mi'), 29,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:15','yyyy-mm-dd hh24:mi'), 29,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 09:11','yyyy-mm-dd hh24:mi'), 30,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-12 18:15','yyyy-mm-dd hh24:mi'), 30,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 09:03','yyyy-mm-dd hh24:mi'), 30,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-13 18:09','yyyy-mm-dd hh24:mi'), 30,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 09:08','yyyy-mm-dd hh24:mi'), 30,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-14 18:09','yyyy-mm-dd hh24:mi'), 30,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 09:13','yyyy-mm-dd hh24:mi'), 30,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-15 18:13','yyyy-mm-dd hh24:mi'), 30,'Salida');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 09:09','yyyy-mm-dd hh24:mi'), 30,'Entrada');
INSERT INTO Fichajes (Hora, Empleado,Tipo) VALUES (to_date('2020-10-16 18:01','yyyy-mm-dd hh24:mi'), 30,'Salida');


--DATOS DE LIBROS COMPRADOS

INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 7 ,'Legislacion sobre seguridad informatica (LOPD)');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 2 ,'I+D farmaceutico: investigacion y desarrollo ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 4 ,'Molecular simulations of globins: Exploring the relationship between structure, dynamics and function ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 2 ,'Membrane interaction of polymyxin B and synthetic analogues studied in biomimetic systems: implications for antibacterial action ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Claves de la dermofarmacia');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 2 ,'Farmacia clinica ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 4 ,'The Coming Plague: Newly Emerging Diseases in a World Out of Balance');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Operaciones basicas en el Laboratorio');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 8 ,'Pharmacology - Toxicology');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Innovacion en empresas Farmaceuticas');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Direccion de empresas Farmaceuticas y Biotecnologicas');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 2 ,'Pharmakoteka');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 8 ,'What are Novichok agents and what do they do');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Analisis critico, toma de decisiones y resolucion de problemas en el sector farmaceutico ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Gestion de muestras biologicas');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Anatomofisiologia y Patologias');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 2 ,'Enciclopedia de farmacia practica');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 5 ,'Cancer: Principles - Practices of Oncology');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 5 ,'Cancer: The Facts');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Comunicacion, negociacion y liderazgo en el sector farmaceutico ');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 4 ,'Gordis Epidemiology');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Formacion en la industria farmaceutica');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Industria farmaceutica y patentes');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 1 ,'Los patrones de innovacion en España a traves del analisis de patentes');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 4 ,'Basics of epidemiology');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Operaciones basiques en el Laboratorio');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 4 ,'The vaccine friendly plan');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 5 ,'A Primer of Brain Tumors');
INSERT INTO LibrosComprados (ID, Departamento, ISBN) VALUES (Libroscomprados_sec.nextval, 3 ,'Laboratory procedures for pharmacy technicians');


--DATOS DE Agenda DE LA VICTIMA

INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-12 09:30','yyyy-mm-dd hh24:mi'), 'Notario - pospuesto. Testamento?');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-12 12:00','yyyy-mm-dd hh24:mi'), 'Reunion departamento');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-13 10:00','yyyy-mm-dd hh24:mi'), 'Reunion Xavier Sevilla ');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-13 12:00','yyyy-mm-dd hh24:mi'), 'Reunion Dr Oliver - Vall Hebron (Dr papa) Planta 2');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-14 14:00','yyyy-mm-dd hh24:mi'), 'Comida con Oriol Gran');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-15 12:00','yyyy-mm-dd hh24:mi'), 'Asesoramiento genetico - Vall Hebron Planta Baja');
INSERT INTO Agenda (Hora, Descripcion) VALUES (to_date('2020-10-16 17:30','yyyy-mm-dd hh24:mi'), 'Reunion Neus Ferrari');


--DATOS DE DocumentosImprimidos DE LA VICTIMA

INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-12 09:02','yyyy-mm-dd hh24:mi'), 'NuevoTestamentoPapa.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-13 16:12','yyyy-mm-dd hh24:mi'), 'AumentoSueldoBenHarris.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-14 10:02','yyyy-mm-dd hh24:mi'), 'ParteBajaPapaCancer.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-14 11:02','yyyy-mm-dd hh24:mi'), 'PharmacNews034L.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-14 11:03','yyyy-mm-dd hh24:mi'), 'NovaPharmaTrend078T.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-15 09:15','yyyy-mm-dd hh24:mi'), 'AntecedentesGeneticosFamilia.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-15 15:15','yyyy-mm-dd hh24:mi'), 'PatologyTest0067.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-15 15:30','yyyy-mm-dd hh24:mi'), 'PatentReview.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-16 17:02','yyyy-mm-dd hh24:mi'), 'DespidoNeusFerrari.pdf',NULL);
INSERT INTO DocumentosImprimidos  VALUES (to_date('2020-10-16 17:58','yyyy-mm-dd hh24:mi'), 'AutorizacionDesconexion.pdf',NULL);


