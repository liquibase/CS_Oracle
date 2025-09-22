###
### This script ensures all tables starting with SWPRC contain tracking columns:
### insert_date, insert_user, update_date, update_user with NOT NULL constraint
###
### Notes:
###

###
### Helpers come from Liquibase
###
import re
import sys
import liquibase_utilities

words_to_filter = ['GLOBAL', 'PRIVATE', 'SHARDED', 'DUPLICATED', 'IMMUTABLE', 'BLOCKCHAIN', 'TEMPORARY']

# Required audit columns for SWPRC tables
required_audit_columns = ['insert_date', 'insert_user', 'update_date', 'update_user']

###
### Retrieve log handler
### Ex. liquibase_logger.info(message)
###
liquibase_logger = liquibase_utilities.get_logger()

###
### Retrieve status handler
###
liquibase_status = liquibase_utilities.get_status()

###
### Retrieve all changes in changeset
###
changes = liquibase_utilities.get_changeset().getChanges()

def check_audit_columns(sql_text, table_name):
    """
    Check if required audit columns are present and have NOT NULL constraint
    """
    sql_upper = sql_text.upper()
    missing_columns = []
    nullable_columns = []
    
    for column in required_audit_columns:
        column_upper = column.upper()
        
        # Check if column exists in the SQL
        column_pattern = r'\b' + re.escape(column_upper) + r'\b'
        if not re.search(column_pattern, sql_upper):
            missing_columns.append(column)
        else:
            # Check if the column has NOT NULL constraint
            # Look for the column followed by data type and check for NOT NULL
            not_null_pattern = r'\b' + re.escape(column_upper) + r'\b[^,]*NOT\s+NULL'
            if not re.search(not_null_pattern, sql_upper):
                nullable_columns.append(column)
    
    return missing_columns, nullable_columns

###
### Loop through all changes
###
for change in changes:
    ###
    ###
    ### Split SQL into a list of strings to remove whitespace
    ###
    sql_list = liquibase_utilities.generate_sql(change).split()
    # Get the full SQL text for column checking
    full_sql = liquibase_utilities.generate_sql(change)
    
    words_set = {word.upper() for word in words_to_filter}
    filtered_sql_list = [word for word in sql_list if word.upper() not in words_set]
    
    ###
    ### Locate CREATE TABLE in list
    ###
    if "create" in map(str.casefold, filtered_sql_list) and "table" in map(str.casefold, filtered_sql_list):
        index_table = [token.lower() for token in filtered_sql_list].index("table")
        if index_table + 1 < len(filtered_sql_list):
            table = filtered_sql_list[index_table + 1]

            table_name = table.replace("'", "").replace('"', "").split('.')[-1]
            # print ("Table name: " + table_name)

            # Check that the tracking columns are present and not nullable for SWPRC tables
            if table_name.upper().startswith("SWPRC"):
                missing_columns, nullable_columns = check_audit_columns(full_sql, table_name)
                
                if missing_columns:
                    liquibase_status.fired = True
                    status_message = f"Table {table_name} is missing required audit columns: {', '.join(missing_columns)}"
                    liquibase_status.message = status_message
                    sys.exit(1)
                
                if nullable_columns:
                    liquibase_status.fired = True
                    status_message = f"Table {table_name} has audit columns that are not NOT NULL: {', '.join(nullable_columns)}"
                    liquibase_status.message = status_message
                    sys.exit(1)
                
                if not missing_columns and not nullable_columns:
                    success_msg = f"Table {table_name} has all required audit columns with NOT NULL constraints"
                    # print (success_msg)

###
### Default return code
###
False