--liquibase formatted sql

--changeset asmith:insert_01
INSERT INTO LIQUIBASE_USER.PERSON (ID, FIRST_NAME, LAST_NAME)
VALUES(1, 'Amy', 'Smith');
--rollback DELETE FROM LIQUIBASE_USER.PERSON WHERE ID = 1;

--changeset asmith:delete_01
DELETE FROM LIQUIBASE_USER.PERSON;