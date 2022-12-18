create database oficina;
use oficina;
drop database oficina;
create table clients (
	id_client int auto_increment unique primary key,
    fname varchar(20) not null,
    lname varchar(20),
    cpf char(9) not null unique,
    vehicle_model varchar(30) not null
);

create table orders (
	id_orders int auto_increment unique primary key,
    solicitation_date datetime not null,
    inspection tinyint,
    mending tinyint,
    fkclients int,
    fkmechanics int,
    fkoservice int,
    constraint fk_mechanics foreign key (fkmechanics) references mechanics(id_mechanics),
    constraint fk_clients foreign key (fkclients) references clients(id_client),
    constraint chk_order check (inspection=true or mending=true),
    constraint fk_oservice foreign key (fkoservice) references orderservice(id_oservice)
);

create table mechanics (
	id_mechanics int auto_increment unique primary key,
    fname varchar(20) not null,
    lname varchar(20),
    specialty varchar(40) not null,
    adress varchar(45) not null
);

create table orderservice (
	id_oservice int auto_increment unique primary key,
    deliverytime date not null,
    dispatchtime date not null,
    servicestatus enum('Solicitado', 'Processando', 'Concluído'),
    suplyquantity int default 0,
    fkservicesoserv int,
    fksupplies int,
    constraint chk_date check (deliverytime >= dispatchtime),
    constraint fk_servicesoserv foreign key (fkservicesoserv) references service(id_service),
    constraint fk_supplies foreign key (fksupplies) references supplies(id_supplies)
);

create table service (
	id_service int auto_increment unique primary key,
    servicename varchar(45) not null,
    price float not null
);

create table supplies (
	id_supplies int auto_increment unique primary key,
    suplyname varchar(40),
    price float
);


-- Inserção de dados
-- Clients
insert into Clients(fname,lname,cpf,vehicle_model)
	values('Ricardo','Silva','123456789','Gol'),
	('Maria','Souza','234567891','Gol'),
	('Pedro','Bastos','345678912','FordKA'),
	('Ana','Barbosa', '456789123','Palio'),
	('Jonathan','Matheus','567891234','CrossFox'),
	('Guilherme','Afonso','678912345','Voyage');

-- Orders
insert into orders(solicitation_date,inspection,mending,fkclients,fkmechanics,fkoservice)
	values('2022-10-10 18:25:13',false,true,1,2,1),
	('2022-10-5 08:15:17',true,true,2,2,2),
	('2022-09-30 15:06:08',false,true,3,3,3),
	('2022-09-28 17:52:03',true,false,4,2,4),
	('2022-10-05 09:31:17',true,true,5,1,5);

-- Mechanics
insert into mechanics(fname,lname,specialty,adress)
	values('Pedro','Carvalho','Reparador','rua jardim 29, cristo - Joao Pessoa'),
	('Jose','Araujo','Balanceamento','avenidade epitacio 19, Centro - Joao Pessoa'),
	('Bruno','Dantas','Eletrico', 'rua bancarios 28, Centro - Joao Pessoa');

-- orderservice
insert into orderservice(deliverytime,dispatchtime,servicestatus,suplyquantity,fkservicesoserv,fksupplies)
	values('2022-10-11','2022-10-10','Processando',4,1,1),
	('2022-10-7','2022-10-5','Concluído',2,1,2),
	('2022-10-1','2022-09-30','Concluído',2,1,1),
	('2022-09-29','2022-09-28','Solicitado',default,3,null),
	('2022-10-06','2022-10-0','Concluído',1,2,3);

-- Service
insert into service(servicename,price)
	values('Substituir pecas',50.8),
	('Troca de oleo',100),
	('Revisao',150);

-- Supplies
insert into supplies(suplyname,price)
	values('Pastilhas de freio',100),
	('Pistao da mala',40),
	('Oleo',50);
    
    
-- Queries
-- Quais os principais serviços realizados?
select s.servicename as 'Serviço',count(s.servicename) as Quantidade, os.servicestatus as SStatus from orders o
	inner join orderservice os on fkoservice=id_oservice
    inner join service s on fkservicesoserv=id_service
    group by s.servicename
    order by count(s.servicename) desc;
    
-- Qual o valor total para cada cliente?
select concat(fname,' ',lname) as Cliente, round(os.suplyquantity*su.price,2) as 'Preço total de peças', s.price as 'Preço do serviço', round((os.suplyquantity*su.price)+s.price,2) as 'Preço total' from clients
	inner join orders o on fkclients=id_client
    inner join orderservice os on fkoservice=id_oservice
    inner join service s on fkservicesoserv=id_service
    inner join supplies su on fksupplies=id_supplies;

