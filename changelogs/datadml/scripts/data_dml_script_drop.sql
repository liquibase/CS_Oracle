--liquibase formatted sql
--changeset asmith:02
select '1' from dual;
--rollback drop table LIQUIBASE_TRACKING.DATABASECHANGELOG;
--rollback drop table LIQUIBASE_TRACKING.DATABASECHANGELOGLOCK;
--rollback drop table LIQUIBASE_TRACKING.DATABASECHANGELOGHISTORY;
