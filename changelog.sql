-- liquibase formatted sql changeLogId:81e3bcd0-4a4c-4292-aa2c-6e8a33d18b8c

--changeset SteveZ:1-createTable_TABLE200 context:TEST,PROD
CREATE TABLE TABLE200
 (
   JOB_ID VARCHAR2(10 BYTE) NOT NULL,
   MIN_SALARY NUMBER(6, 0),
   MAX_SALARY NUMBER(6, 0),
   CONSTRAINT JOB_ID_PK200 PRIMARY KEY (JOB_ID)
 )
;
--rollback drop table TABLE200

--changeset SteveZ:2-createTable_EMPLOYEES context:TEST,PROD
CREATE TABLE EMPLOYEES
(	
  EMPLOYEE_ID NUMBER(6,0) NOT NULL ENABLE, 
	FIRST_NAME VARCHAR2(20), 
	LAST_NAME VARCHAR2(25) CONSTRAINT "EMP_LAST_NAME_NN" NOT NULL ENABLE, 
	EMAIL VARCHAR2(25) CONSTRAINT "EMP_EMAIL_NN" NOT NULL ENABLE, 
	PHONE_NUMBER VARCHAR2(20), 
	HIRE_DATE DATE CONSTRAINT "EMP_HIRE_DATE_NN" NOT NULL ENABLE, 
	JOB_ID VARCHAR2(10) CONSTRAINT "EMP_JOB_NN" NOT NULL ENABLE, 
	SALARY NUMBER(8,2), 
	COMMISSION_PCT NUMBER(2,2), 
	MANAGER_ID NUMBER(6,0), 
	DEPARTMENT_ID NUMBER(4,0), 
	CONSTRAINT EMP_EMP_ID_PK PRIMARY KEY ("EMPLOYEE_ID"))
   ;
--rollback DROP TABLE EMPLOYEES

--changeset MikeO:3-CreatePROC_add_job_history112 endDelimiter:/ splitStatements:false runOnChange:true context:TEST,PROD
CREATE OR REPLACE PROCEDURE add_job_history112
 (  p_emp_id          job_history.employee_id%type
  , p_start_date      job_history.start_date%type
  , p_end_date        job_history.end_date%type
  , p_job_id          job_history.job_id%type
  , p_department_id   job_history.department_id%type
  )
IS
BEGIN
 INSERT INTO job_history (employee_id, start_date, end_date,
                          job_id, department_id)
   VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END;
/
--rollback DROP PROCEDURE add_job_history112;

--changeset AmyS:4-createTrigger_t splitStatements:false context:TEST,PREPROD
create or replace TRIGGER t2
 BEFORE
   INSERT OR
   UPDATE OF salary, department_id OR
   DELETE
 ON EMPLOYEES
BEGIN
 CASE
   WHEN INSERTING THEN
     DBMS_OUTPUT.PUT_LINE('Inserting');
   WHEN UPDATING('salary') THEN
     DBMS_OUTPUT.PUT_LINE('Updating salary');
   WHEN UPDATING('department_id') THEN
     DBMS_OUTPUT.PUT_LINE('Updating department ID');
   WHEN DELETING THEN
     DBMS_OUTPUT.PUT_LINE('Deleting');
 END CASE;
END;
/

--rollback DROP TRIGGER t2

--changeset TsviZ:5-create_sequence_my_test_id_seq context:TEST
create sequence my_test_id_seq increment by 1;
--rollback DROP sequence my_test_id_seq

--changeset TsviZ:6-create_table_my_test context:!prod
create table
   my_test
(
    id   integer,
    name varchar(10)
 );
--rollback DROP table my_test

--changeset TsviZ:7-insert_into_my_test context:"!prod and !preprod"
insert into
   my_test
(id,name)
 values
(
   my_test_id_seq.nextval,
   'Albert');
--rollback DELETE FROM my_test where name='Albert'


