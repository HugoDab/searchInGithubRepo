#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Write into a file the names of repositories from github links."
  echo
  echo "Syntax: getName [-h|o] repoFile"
  echo "options:"
  echo "h     Print this Help."
  echo "o     Output file."
}

############################################################
# Process the input options.                               #
############################################################

while getopts "h:o:" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  o) # output file
    outputFile=$OPTARG
    ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

shift "$((OPTIND - 1))"

if [ -z "$outputFile" ]; then
  echo 'Missing -o option' >&2
  Help
  exit 1
fi

############################################################
# Main program                                             #
############################################################

touch "$outputFile"
while read -r repolink; do
  repoTemp=$(echo "$repolink" | cut -d '/' -f 4-5)
  repo=$(echo "$repoTemp" | cut -d '.' -f 1)
  echo "$repo">>"$outputFile"
done <"$1"