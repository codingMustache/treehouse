#!/bin/bash

# Run git diff and capture the output
diff_output=$(git diff --name-only)

# Initialize an empty array to store files with changes
files_with_changes=()

# Read each line of the diff output
while IFS= read -r line; do
  # Extract the file path and add it to the files_with_changes array
  file_path=$line
  remove_whitespace=${file_path//[[:space:]]/}
  files_with_changes+=("$remove_whitespace")
done <<< "$diff_output"

# Remove duplicates from the files_with_changes array
files_with_changes=($(echo "${files_with_changes[@]}" | awk -v RS=' ' '!a[$1]++'))

# Loop over the files with changes array
for file in "${files_with_changes[@]}"; do
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