#!/bin/bash
# Define the directory and the base text to prepend
DIRECTORY="."
BASE_TEXT="--liquibase formatted sql\n--changeset baseline-file:1"

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory $DIRECTORY does not exist."
  exit 1
fi

# Use 'find' to loop through only .sql files (including those in subdirectories)
find "$DIRECTORY" -type f -name "*.sql" | while read FILE; do
  # Get the directory path of the file
  DIR_PATH=$(dirname "$FILE")
  echo "DIR_PATH $DIR_PATH"
  
  # Check if the path contains Functions, Stored Procedures, or Views
  if [[ "$DIR_PATH" =~ (Functions|Stored[[:space:]]Procedures|Views) ]]; then
    # Add runOnChange:true for these specific subdirectories
    TEXT_TO_PREPEND="$BASE_TEXT runOnChange:true"
    echo "Adding header with runOnChange:true to $FILE"
  else
    # Use base text for other files
    TEXT_TO_PREPEND="$BASE_TEXT"
    echo "Adding standard header to $FILE"
  fi
  
  # Prepend the text to the file
  echo -e "$TEXT_TO_PREPEND\n$(cat "$FILE")" > "$FILE"
  echo "Prepended text to $FILE"
done

echo "Liquibase Headers have been added."
