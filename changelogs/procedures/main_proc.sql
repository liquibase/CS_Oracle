-- Main entry point script
-- In SQL*Plus, the @ operator calls other scripts relative to the current file
--@&script_dir.helper_package.sql
--@&script_dir.lookup_data.sql
@helper_package.sql
@lookup_data.sql

-- Main stored procedure that depends on the above
CREATE OR REPLACE PROCEDURE main_proc AS
BEGIN
    helper_proc();
    populate_lookup();
END;
/