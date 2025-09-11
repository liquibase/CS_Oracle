--liquibase formatted sql
--changeset asmith:trigger_01 endDelimiter:/ runOnChange:true
create or replace TRIGGER "MUREX"."TEST_TRIG_01"
     AFTER UPDATE
     ON  "MUREX".TABLE_02  DECLARE
         BEGIN
     begin
    
     select * from "MUREX".TABLE_02_X;
    
         when others then
        dbms_output.put_line('Unexpected technical error!!');
    end;
   
    exception
        when others then
        dbms_output.put_line('Unexpected technical error');
    END;
/

--changeset asmith:trigger_02 endDelimiter:/
create or replace TRIGGER
 "MUREX"."TEMP_TRIG_01"
     AFTER UPDATE
     ON  "MUREX".TABLE_02  DECLARE
         BEGIN
     begin
    
     select * from "MUREX".TABLE_02_X;
    
         when others then
        dbms_output.put_line('Unexpected technical error');
    end;
   
    exception
        when others then
        dbms_output.put_line('Unexpected technical error');
    END;
/
