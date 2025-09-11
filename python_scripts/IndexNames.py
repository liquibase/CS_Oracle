###
### This script ensures all indexes end with IDX.
###
### Notes:
###

###
### Helpers come from Liquibase
###
import re
import sys
import liquibase_utilities

words_to_filter = ['UNIQUE','BITMAP']

def ends_with_name_pattern(input_string):
    """
    Checks if a string ends with IDX.

    Args:
        input_string: The string to check.

    Returns:
        True if the string matches pattern, False otherwise.
    """
    if not isinstance(input_string, str):
        return False

    if not re.search("IDX" + r"$", input_string, re.IGNORECASE):
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
    ### Locate INDEX in list
    ###
    if "create" in map(str.casefold, filtered_sql_list) and "index" in map(str.casefold, filtered_sql_list):
        index_of_index = [token.lower() for token in filtered_sql_list].index("index")
        if index_of_index + 1 < len(filtered_sql_list):
            index = filtered_sql_list[index_of_index + 1]

            index_name = index.replace("'", "").replace('"', "").split('.')[-1]
            endsWithNamePattern = ends_with_name_pattern(index_name)
         
            print ("Index name: " + index_name + ", " + str(endsWithNamePattern))
                
            if not endsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Index name \"" + f"{index_name}" + "\" does not end with IDX."
                liquibase_status.message = status_message
                sys.exit(1)

###
### Default return code
###
False