#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Transform results from finderGithub into CSV file."
  echo "It will search for file finishing with results.txt | res.txt | result.txt."
  echo "The python script *finder_github_results_to_csv* must be in a subdirectory of current directory."
  echo
  echo "Syntax: resultsToCSVfromDir [-h] directory"
  echo "options:"
  echo "h     Print this Help."
  echo "*if no directory takes the actual one"
}

############################################################
# Process the input options.                               #
############################################################

while getopts "h:" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

shift "$((OPTIND - 1))"

############################################################
# Main program                                             #
############################################################

if [ -z "$1" ]; then
  dir="$PWD"
else
  dir="$1"
fi

scriptToCsv=$(find . -name "finder_github_results_to_csv.py")

files=$(find "$dir" -regextype posix-extended -iregex '.*res(ult)?s?\.txt')

echo "$files"

for file in $files; do
  python3 "$scriptToCsv" "$file" "${file%.txt}.csv"
done
