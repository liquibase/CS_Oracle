--liquibase formatted sql

--changeset amy_smith:01-data labels:blah
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (1, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 1;

--changeset amy_smith:02-data labels:blah2
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (2, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 2;

--changeset amy_smith:03-data
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (3, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 3;

--changeset amy_smith:04-data
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (4, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 4;

--changeset amy_smith:05-data
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (5, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 5;

--changeset amy_smith:select-01 labels:blah2 runAlways:false
SELECT '1' from dual;
--rollback SELECT '1' from dual;

--changeset amy_smith:test_rows_affected_1
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (6, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 6;

--changeset amy_smith:test_rows_affected_2
INSERT INTO KPATH1.PERSON (id, first_name, last_name) VALUES (7, 'Amy', 'Smith');
--rollback DELETE FROM KPATH1.PERSON WHERE id = 7;

--changeset amy_smith:test_rows_affected_3
UPDATE KPATH1.PERSON set last_name = 'Smith2' where id in (6,7);
--rollback UPDATE KPATH1.PERSON set last_name = 'Smith' where id in (6,7);