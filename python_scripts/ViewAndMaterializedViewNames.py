###
### This script ensures all views start with SWPRC and end with V.
### This script ensures all materialized views start with SWPRC and end with MV.
###
### Notes:
###

###
### Helpers come from Liquibase
###
import re
import sys
import liquibase_utilities

words_to_filter = ['IF','NOT','EXISTS','OR','REPLACE','NO','FORCE','EDITIONING','EDITIONABLE','NONEDITIONABLE']

def starts_with_name_pattern(input_string):
    """
    Checks if a string starts with SWPRC.

    Args:
        input_string: The string to check.

    Returns:
        True if the string matches pattern, False otherwise.
    """
    if not isinstance(input_string, str):
        return False

    if not re.match(r"^SWPRC", input_string, re.IGNORECASE):
        return False

    return True

def ends_with_name_pattern(input_string, input_pattern):
    """
    Checks if a string ends with V (for views) or MV (for materialized views).

    Args:
        input_string: The string to check.
        input_pattern: The pattern to check for ('V' or 'MV').

    Returns:
        True if the string matches pattern, False otherwise.
    """
    if not isinstance(input_string, str):
        return False

    if not re.search(input_pattern + r"$", input_string, re.IGNORECASE):
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
    ### Locate MATERIALIZED VIEW in list
    ###
    if "create" in map(str.casefold, filtered_sql_list) and "materialized" in map(str.casefold, filtered_sql_list) and "view" in map(str.casefold, filtered_sql_list):
        index_m_view = [token.lower() for token in filtered_sql_list].index("view")
        if index_m_view + 1 < len(filtered_sql_list):
            m_view = filtered_sql_list[index_m_view + 1]

            m_view_name = m_view.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(m_view_name)
            endsWithNamePattern = ends_with_name_pattern(m_view_name, "MV")
         
            print ("Materialized View name: " + m_view_name + ", " + str(startsWithNamePattern) + ", " + str(endsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Materialized View name \"" + f"{m_view_name}" + "\" does not start with SWPRC."
                liquibase_status.message = status_message
                sys.exit(1)
                
            if not endsWithNamePattern:
                liquibase_status.fired = True
                status_message = "Materialized View name \"" + f"{m_view_name}" + "\" does not end with MV."
                liquibase_status.message = status_message
                sys.exit(1)
    ###
    ### Locate CREATE VIEW in list
    ###
    elif "create" in map(str.casefold, filtered_sql_list) and "view" in map(str.casefold, filtered_sql_list):
        index_view = [token.lower() for token in filtered_sql_list].index("view")
        if index_view + 1 < len(filtered_sql_list):
            view = filtered_sql_list[index_view + 1]

            view_name = view.replace("'", "").replace('"', "").split('.')[-1]
            startsWithNamePattern = starts_with_name_pattern(view_name)
            endsWithNamePattern = ends_with_name_pattern(view_name, "V")
         
            print ("View name: " + view_name + ", " + str(startsWithNamePattern) + ", " + str(endsWithNamePattern))

            if not startsWithNamePattern:
                liquibase_status.fired = True
                status_message = "View name \"" + f"{view_name}" + "\" does not start with SWPRC."
                liquibase_status.message = status_message
                sys.exit(1)
                
            if not endsWithNamePattern:
                liquibase_status.fired = True
                status_message = "View name \"" + f"{view_name}" + "\" does not end with V."
                liquibase_status.message = status_message
                sys.exit(1)

###
### Default return code
###
False