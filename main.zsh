#!/bin/bash

# Run git status and capture the output
status_output=$(git status --porcelain)

# Initialize an empty array to store untracked files
untracked_files=()

# Read each line of the status output
while IFS= read -r line; do
  # Check if the line starts with "??" indicating an untracked file
  if [[ $line =~ ^\?\? ]]; then
    # Extract the file path and add it to the untracked_files array
    file_path=${line#??}
    remove_whitespace=${file_path//[[:space:]]/}
    untracked_files+=("$remove_whitespace")
  fi
done <<< "$status_output"


# Get the absolute path of the current directory
current_dir=$(pwd)

# Loop over the untracked files array
for file in "${untracked_files[@]}"; do

  # Get the absolute path of the file
  file_path="${current_dir}/${file}"
  echo $file_path
  # Add the file to the Git repository
  git add "$file_path"

  # Open the changes in VS Code
  zed "$file_path"

  # Prompt for a commit message
  read -rp "Enter a commit message for $file: " commit_message

  # Commit the file with the provided message
  git commit -m "$commit_message"

done


