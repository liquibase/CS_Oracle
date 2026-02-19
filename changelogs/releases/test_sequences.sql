--liquibase formatted sql

--changeset amy_smith:seq_01 ignore:true
CREATE SEQUENCE CAPS.my_sequence_01
    START WITH     1
    INCREMENT BY   1
    MINVALUE       1
    MAXVALUE       999999999999999999999999999
    CACHE          20
    NOCYCLE;
--rollback drop sequence CAPS.my_sequence_01;

--changeset amy_smith:view_01 runOnChange:true ignore:true
CREATE OR REPLACE VIEW CAPS.DEALER01_VW AS
SELECT 
    USER_ID,
    USERNAME,
    USER_FIRST_NAME || ' ' || USER_LAST_NAME AS NAME,
    CASE USER_CITY
        WHEN '0' THEN 'EMPTY'
        ELSE 'HAS_VALUE'
    END AS USER_CITY_STATUS,
	NVL(USER_STATE, 'NA') AS USER_STATE
FROM CAPS.DEALER01;
--rollback drop view CAPS.DEALER01_VW;