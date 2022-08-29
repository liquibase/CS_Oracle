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