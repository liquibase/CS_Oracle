-- liquibase formatted sql

--changeset SteveZ:45555-createTable_EMPLOYEES
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


--changeset TsviZ:45-create_sequence_my_test_id_seq
create sequence my_test_id_seq increment by 1;
--rollback DROP sequence my_test_id_seq


--changeset TsviZ:45-create_table_my_test
create table
   my_test
(
    id   integer,
    name varchar(10)
 );
--rollback DROP table my_test