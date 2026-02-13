###
### This script ensures all tables starting with SWPRC contain a create trigger statement
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

def check_trigger(sql_text):
    """
    Check if trigger is present
    """
    sql_upper = sql_text.upper() 

    # Check if trigger exists in the SQL
    trigger_pattern = r'CREATE\s+(OR\s+REPLACE\s+)?(EDITIONABLE\s+|NONEDITIONABLE\s+)?TRIGGER'
    match = re.search(trigger_pattern, sql_upper, re.DOTALL)
    if match:
        return False  # Trigger is present
    else:
        return True  # Trigger is missing

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
                missing_trigger = check_trigger(full_sql)
                
                if missing_trigger:
                    liquibase_status.fired = True
                    status_message = f"Table {table_name} is missing a trigger"
                    liquibase_status.message = status_message
                    sys.exit(1)

###
### Default return code
###
False