#!/bin/bash

# Define the directory and the text to prepend
DIRECTORY="sql_code"
TEXT_TO_PREPEND="--liquibase formatted sql\n--changeset baseline-file:1"

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory $DIRECTORY does not exist."
  exit 1
fi

# Use 'find' to loop through all files (including those in subdirectories)
find "$DIRECTORY" -type f | while read FILE; do
  # Prepend the text to the file
  echo -e "$TEXT_TO_PREPEND\n$(cat "$FILE")" > "$FILE"
  echo "Prepended text to $FILE"
done

echo "Liquibase Headers have been added."