--liquibase formatted sql

--changeset amy_smith:FT_01 labels:"v2026.1.24,ABC-0987" runWith:sqlplus ignore:true
CREATE TABLE CAPS.COLORS_101 (ID NUMBER(*, 0), COLOR VARCHAR2(20 BYTE));
--rollback drop table CAPS.COLORS_101;

--changeset amy_smith:FT_01_1 labels:"v2026.1.24,ABC-0987" runWith:sqlplus ignore:true
INSERT INTO CAPS.COLORS_101 VALUES (1, 'RED');
INSERT INTO CAPS.COLORS_101 VALUES (2, 'BLUE');
--rollback delete from CAPS.COLORS_101 where ID in (1,2);

--changeset amy_smith:FT_01_2 labels:"v2026.1.24,ABC-0987" runWith:sqlplus ignore:true
SELECT * FROM CAPS.COLORS_101;
--rollback SELECT * FROM CAPS.COLORS_101;

--changeset amy_smith:FT_01_3 labels:"v2026.1.24,ABC-0987" runWith:sqlplus ignore:true
DESCRIBE CAPS.COLORS_101;
--rollback DESCRIBE CAPS.COLORS_101;

--changeset amy_smith:test_sqlp2 labels:"v2026.1.24,ABC-0987" runWith:sqlplus
SELECT 1 from dual;
--rollback SELECT 1 from dual;