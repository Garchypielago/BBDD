CREATE TABLE empleados (
Numempleado number not null primary key,
nombre varchar(30) not null,
edad number(2) not null,
CONSTRAINT Ck_edad check (edad>=16),
oficina number not null,
titulo varchar2(20) not null,
fechacontrato date not null,
director number not null,
cuota number(10,2) not null,
ventas number(20,2) not null
);

create table oficinas(
oficina number primary key,
ciudad varchar2(30) not null,
region varchar2(30) not null,
coddirector number,
CONSTRAINT Fk_numempleado 
foreign key (coddirector) REFERENCES empleados(numempleado),
importeobjetivos number(20,2),
importeventas number(20,2)
);

create table productos(
idfabrica varchar(10) not null,
idproducto varchar(10) not null,
descripcion varchar2(30) not null,
precio number(10,2) not null,
existencias number,
primary key (idfabrica, idproducto)
);

create table clientes(
numcliente number not null primary key,
nombre varchar2(30) not null,
vendedor number,
CONSTRAINT Fk_vendedor
foreign key (vendedor) references empleados(Numempleado)
);

create table pedido(
codigo number not null,
numpedido number not null,
fechapedido date not null,
cliente number,
vendedor number,
fabrica varchar2(10) not null,
producto varchar2(10),
CONSTRAINT Fk_Cliente
foreign key (cliente) references clientes(numcliente),
CONSTRAINT Fk_empleado
foreign key (vendedor) references empleados(Numempleado),
CONSTRAINT Fk_producto
foreign key (fabrica, producto) references productos(idfabrica, idproducto),
importe number(10,2) not null
);

alter table clientes add limitecredito number(10,2);

ALTER TABLE empleados ADD CONSTRAINT Fk_oficina FOREIGN KEY
(oficina) REFERENCES oficinas(oficina);

ALTER TABLE empleados ADD CONSTRAINT Fk_director FOREIGN KEY
(director) REFERENCES empleados(Numempleado);

alter table empleados modify nombre UNIQUE;

create sequence NumEmpleado
start with 1
increment by 1
nocycle;

create sequence CodigoProducto
start with 1
increment by 1
nocycle;

alter table pedido drop column codigo;

alter table pedido add primary key (numpedido);

create sequence numpedido
start with 1
increment by 1
nocycle;

alter table empleados add constraint Ck_edad2 check (edad<70);

//Añade a la tabla Pedidos la columna Estado después de FechaPedido, esta columna sólo
//podrá tomar los valores ‘Solicitado','Enviado','Entregado' y 'Reembolsado’. Por defecto tendrá
//el valor ‘Solicitado’.

alter table pedido add estado varchar2(10) not null;

alter table pedido add constraint Ck_estadopedido check (estado in ('Solicitado','Enviado','Entregado', 'Reembolsado'));

alter table pedido modify estado default ('Solicitado');

