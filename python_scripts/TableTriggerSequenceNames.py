###
### This script ensures all tables, triggers, and sequences start with SWPRC or TEMP.
###
### Notes:
###

###
### Helpers come from Liquibase
###
import re
import sys
import liquibase_utilities

words_to_filter = ['GLOBAL', 'PRIVATE', 'SHARDED', 'DUPLICATED', 'IMMUTABLE', 'BLOCKCHAIN', 'TEMPORARY', 'EDITIONABLE', 'NONEDITIONAL', 'OR', 'REPLACE']

def starts_with_name_pattern(input_string):
    """
    Checks if a string starts with SWPRC or TEMP.

    Args:
        input_string: The string to check.

    Returns:
        True if the string matches pattern, False otherwise.
    """
    if not isinstance(input_string, str):
        return False

    if not re.match(r"^(SWPRC|TEMP)", input_string, re.IGNORECASE):
        return False

    return True

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

###
### Loop through all changes
###
for change in changes:
    ###
    ###
    ### Split SQL into a list of strings to remove whitespace
    ###
    sql_list = liquibase_utilities.generate_sql(change).split()
    # print ("sql_list:" + str(sql_list))
    
    words_set = {word.upper() for word in words_to_filter}
    filtered_sql_list = [word for word in sql_list if word.upper() not in words_set]
    
    # print ("filtered_sql_list:" + str(filtered_sql_list))
    
    ###
    ### Locate CREATE TABLE in list
    ###
    if "create" in map(str.casefold, filtered_sql_list) and "table" in map(str.casefold, filtered_sql_list):
        index_table = [token.lower() for token in filtered_sql_list].index("table")
        if index_table + 1 < len(filtered_sql_list):
            table = filtered_sql_list[index_table + 1]

            table_name = table.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(table_name)
            
            print ("Table name: " + table_name + ", " + str(startsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Table name \"" + f"{table_name}" + "\" does not start with SWPRC or TEMP."
                liquibase_status.message = status_message
                sys.exit(1)

    ###
    ### Locate CREATE TRIGGER in list
    ###
    
    if "create" in map(str.casefold, filtered_sql_list) and "trigger" in map(str.casefold, filtered_sql_list):
        index_trigger = [token.lower() for token in filtered_sql_list].index("trigger")
        if index_trigger + 1 < len(filtered_sql_list):
            trigger = filtered_sql_list[index_trigger + 1]

            trigger_name = trigger.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(trigger_name)
            
            print ("Trigger name: " + trigger_name + ", " + str(startsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Trigger name \"" + f"{trigger_name}" + "\" does not start with SWPRC or TEMP."
                liquibase_status.message = status_message
                sys.exit(1)

    ###
    ### Locate CREATE SEQUENCE in list
    ###
    
    if "create" in map(str.casefold, filtered_sql_list) and "sequence" in map(str.casefold, filtered_sql_list):
        index_sequence = [token.lower() for token in filtered_sql_list].index("sequence")
        if index_sequence + 1 < len(filtered_sql_list):
            sequence = filtered_sql_list[index_sequence + 1]

            sequence_name = sequence.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(sequence_name)
            
            print ("Sequence name: " + sequence_name + ", " + str(startsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Sequence name \"" + f"{sequence_name}" + "\" does not start with SWPRC or TEMP."
                liquibase_status.message = status_message
                sys.exit(1)

###
### Default return code
###
False