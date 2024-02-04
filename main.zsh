#!/bin/bash

# Run git status and capture the output
status_output=$(git status --porcelain)

# Initialize an empty array to store files to commit
files_to_commit=()

# Read each line of the status output
while IFS= read -r line; do
  # Check if the line starts with "[AMDR]" indicating a file that has been modified, added, deleted, or renamed
  if [[ $line =~ ^[AMDR] ]]; then
    # Extract the file path and add it to the files_to_commit array
    file_path=${line#??}
    remove_whitespace=${file_path//[[:space:]]/}
    files_to_commit+=("$remove_whitespace")
  fi
done <<< "$status_output"

# Remove duplicates from the files_to_commit array
files_to_commit=($(echo "${files_to_commit[@]}" | awk -v RS=' ' '!a[$1]++'))

# Loop over the files to commit array
for file in "${files_to_commit[@]}"; do
  # Add the file to the Git repository
  git add "$file"

  # Open the changes in VS Code
  code "$file"

  # Prompt for a commit message
  read -rp "Enter a commit message for $file: " commit_message

  # Commit the file with the provided message
  git commit -m "$commit_message"
done

# Open the working tree
git status