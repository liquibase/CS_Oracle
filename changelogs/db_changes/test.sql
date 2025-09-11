--liquibase formatted sql

--changeset adeel:table10
create table table10 (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table10" PRIMARY KEY (id),
   CONSTRAINT "xak_table10" UNIQUE (id,name)
)
--rollback drop table table10

--changeset adeel:table11
create table table11 (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table11" PRIMARY KEY (id),
   CONSTRAINT "xak_table11" UNIQUE (id,name)
)
--rollback drop table table11