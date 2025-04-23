--liquibase formatted sql

--changeset adeel:table1
create table table1 (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table1" PRIMARY KEY (id),
   CONSTRAINT "xak_table1" UNIQUE (id,name)
)
--rollback drop table table1

--changeset adeel:table2
create table table2 (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table2" PRIMARY KEY (id),
   CONSTRAINT "xak_table2" UNIQUE (id,name)
)
--rollback drop table table2

--changeset adeel:person
CREATE TABLE person (
   id int,
   first_name varchar(50) NOT NULL,
   last_name varchar(50) NOT NULL,
   CONSTRAINT "pk_person" PRIMARY KEY (id),
   CONSTRAINT "xak_person" UNIQUE (id,last_name)
)
--rollback drop table person

