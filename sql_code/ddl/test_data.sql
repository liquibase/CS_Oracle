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
create table dbo.TEMP_table2 (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table1" PRIMARY KEY (id),
   CONSTRAINT "xak_table1" UNIQUE (id,name)
)
--rollback drop table dbo.TEMP_table2

--changeset adeel:table3
create table SWPRC_blah (
   id int,
   name varchar(50) not null,
   address1 varchar(50),
   address2 varchar(50),
   city varchar(30),
   CONSTRAINT "xpk_table1" PRIMARY KEY (id),
   CONSTRAINT "xak_table1" UNIQUE (id,name)
)
--rollback drop table SWPRC_blah

--changeset adeel:sequence1
CREATE SEQUENCE employee_id_seq
  START WITH 1001
  INCREMENT BY 1
  MAXVALUE 99999
  NOCYCLE
  CACHE 50;
--rollback drop sequence employee_id_seq

--changeset adeel:sequence2
CREATE SEQUENCE dbo.TEMP_employee_id_seq
  START WITH 1001
  INCREMENT BY 1
  MAXVALUE 99999
  NOCYCLE
  CACHE 50;
--rollback drop sequence dbo.TEMP_employee_id_seq

--changeset customer:test1_bad
CREATE TABLE "PRICING"."SWPRX_BLAH" 
   (	"AUDIT_LOG_ID" NUMBER, 
	"CHANGED_TABLE_NAME" VARCHAR2(50 BYTE), 
	"INSERT_USER" VARCHAR2(100 BYTE), 
	"INSERT_DATE" DATE ,
	"UPDATE_USER" VARCHAR2(200 BYTE), 
	"UPDATE_DATE" DATE
   )  ;
 
  CREATE OR REPLACE EDITIONABLE TRIGGER "PRICING"."SWPRX_BLAH_TRG" BEFORE
    INSERT OR UPDATE ON PRICING.SWPRX_BLAH
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.AUDIT_LOG_ID IS NULL THEN
            :NEW.AUDIT_LOG_ID := PRICING.SWPRX_AUDIT_LOG_SEQ.NEXTVAL;
        END IF;
 
        :NEW.INSERT_USER := NVL(
            :NEW.INSERT_USER,
            USER
        );
        :NEW.INSERT_DATE := SYSTIMESTAMP;
        :NEW.UPDATE_USER := NVL(
            :NEW.UPDATE_USER,
            USER
        );
        :NEW.UPDATE_DATE := SYSTIMESTAMP;
    END IF;
END;
 
/
ALTER TRIGGER "PRICING"."SWPRX_BLAH_TRG" ENABLE;

--changeset customer:test2_good
CREATE TABLE "PRICING"."SWPRC_BLAH" 
   (	"AUDIT_LOG_ID" NUMBER, 
	"CHANGED_TABLE_NAME" VARCHAR2(50 BYTE), 
	"INSERT_USER" VARCHAR2(100 BYTE), 
	"INSERT_DATE" DATE ,
	"UPDATE_USER" VARCHAR2(200 BYTE), 
	"UPDATE_DATE" DATE
   )  ;
 
  CREATE OR REPLACE EDITIONABLE TRIGGER "PRICING"."SWPRC_BLAH_TRG" BEFORE
    INSERT OR UPDATE ON PRICING.SWPRC_BLAH
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.AUDIT_LOG_ID IS NULL THEN
            :NEW.AUDIT_LOG_ID := PRICING.SWPRC_AUDIT_LOG_SEQ.NEXTVAL;
        END IF;
 
        :NEW.INSERT_USER := NVL(
            :NEW.INSERT_USER,
            USER
        );
        :NEW.INSERT_DATE := SYSTIMESTAMP;
        :NEW.UPDATE_USER := NVL(
            :NEW.UPDATE_USER,
            USER
        );
        :NEW.UPDATE_DATE := SYSTIMESTAMP;
    END IF;
END;
 
/
ALTER TRIGGER "PRICING"."SWPRC_BLAH_TRG" ENABLE;


--changeset customer:test3_bad
CREATE TABLE "PRICING"."HELLO_SWPRC_BLAH" 
   (	"AUDIT_LOG_ID" NUMBER, 
	"CHANGED_TABLE_NAME" VARCHAR2(50 BYTE), 
	"INSERT_USER" VARCHAR2(100 BYTE), 
	"INSERT_DATE" DATE ,
	"UPDATE_USER" VARCHAR2(200 BYTE), 
	"UPDATE_DATE" DATE
   )  ;
 
  CREATE OR REPLACE EDITIONABLE TRIGGER "PRICING"."SWPRC_BLAH_TRG" BEFORE
    INSERT OR UPDATE ON PRICING.SWPRC_BLAH
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.AUDIT_LOG_ID IS NULL THEN
            :NEW.AUDIT_LOG_ID := PRICING.SWPRC_AUDIT_LOG_SEQ.NEXTVAL;
        END IF;
 
        :NEW.INSERT_USER := NVL(
            :NEW.INSERT_USER,
            USER
        );
        :NEW.INSERT_DATE := SYSTIMESTAMP;
        :NEW.UPDATE_USER := NVL(
            :NEW.UPDATE_USER,
            USER
        );
        :NEW.UPDATE_DATE := SYSTIMESTAMP;
    END IF;
END;
 
/
ALTER TRIGGER "PRICING"."SWPRC_BLAH_TRG" ENABLE;

--changeset customer:test4_bad
CREATE TABLE "PRICING"."SWPRC_BLAH" 
   (	"AUDIT_LOG_ID" NUMBER, 
	"CHANGED_TABLE_NAME" VARCHAR2(50 BYTE), 
	"INSERT_USER" VARCHAR2(100 BYTE), 
	"INSERT_DATE" DATE ,
	"UPDATE_USER" VARCHAR2(200 BYTE), 
	"UPDATE_DATE" DATE
   )  ;
 
  CREATE OR REPLACE EDITIONABLE TRIGGER "PRICING"."BAD_SWPRC_BLAH_TRG" BEFORE
    INSERT OR UPDATE ON PRICING.SWPRC_BLAH
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.AUDIT_LOG_ID IS NULL THEN
            :NEW.AUDIT_LOG_ID := PRICING.SWPRC_AUDIT_LOG_SEQ.NEXTVAL;
        END IF;
 
        :NEW.INSERT_USER := NVL(
            :NEW.INSERT_USER,
            USER
        );
        :NEW.INSERT_DATE := SYSTIMESTAMP;
        :NEW.UPDATE_USER := NVL(
            :NEW.UPDATE_USER,
            USER
        );
        :NEW.UPDATE_DATE := SYSTIMESTAMP;
    END IF;
END;
 
/
ALTER TRIGGER "PRICING"."BAD_SWPRC_BLAH_TRG" ENABLE;

--changeset asmith:bad_sequence
CREATE SEQUENCE customers_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
--changeset asmith:good_sequence
CREATE SEQUENCE "PRICING"."TEMP_BLAH"
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;

--changeset asmith:bad_index
CREATE INDEX index ON table (new_hash_column);

--changeset asmith:database_link_stmt
CREATE PUBLIC DATABASE LINK remote 
   USING 'remote'; 