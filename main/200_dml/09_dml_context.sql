-- liquibase formatted sql

--changeset TsviZ:45-insert_into_my_test
insert into
   my_test
(id,name)
 values
(
   my_test_id_seq.nextval,
   'Albert');
--rollback DELETE FROM my_test where name='Albert'
