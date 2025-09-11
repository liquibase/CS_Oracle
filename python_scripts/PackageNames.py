###
### This script ensures all packages start with SWPRC, PRICING, PRC, or LOAD.
###
### Notes:
###

###
### Helpers come from Liquibase
###
import re
import sys
import liquibase_utilities

words_to_filter = ['OR', 'REPLACE']

def starts_with_name_pattern(input_string):
    """
    Checks if a string starts with SWPRC, PRICING, PRC, or LOAD.

    Args:
        input_string: The string to check.

    Returns:
        True if the string matches pattern, False otherwise.
    """
    if not isinstance(input_string, str):
        return False

    if not re.match(r"^(SWPRC|PRICING|PRC|LOAD)", input_string, re.IGNORECASE):
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
    ### Locate CREATE PACKAGE in list
    ###
    if "create" in map(str.casefold, filtered_sql_list) and "package" in map(str.casefold, filtered_sql_list):
        index_package = [token.lower() for token in filtered_sql_list].index("package")
        if index_package + 1 < len(filtered_sql_list):
            package = filtered_sql_list[index_package + 1]

            package_name = package.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(package_name)
            
            print ("Package name: " + package_name + ", " + str(startsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Package name \"" + f"{package_name}" + "\" does not start with SWPRC, PRICING, PRC, or LOAD."
                liquibase_status.message = status_message
                sys.exit(1)


###
### Default return code
###
False