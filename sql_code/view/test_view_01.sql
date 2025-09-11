--liquibase formatted sql
--changeset asmith:materialized_view_01 endDelimiter:/ runOnChange:true
CREATE MATERIALIZED VIEW SWPRC_foreign_customers_MVX
   AS SELECT * FROM sh.customers@remote cu
   WHERE EXISTS
     (SELECT * FROM sh.countries@remote co
      WHERE co.country_id = cu.country_id);
/

--changeset asmith:view_01 endDelimiter:/ runOnChange:true
CREATE VIEW SAMP.V1 (COL_SUM, COL_DIFF)
	AS SELECT COMM + BONUS, COMM - BONUS
	FROM SAMP.EMPLOYEE;
/
