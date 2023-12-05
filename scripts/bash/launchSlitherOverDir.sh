#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Launch the slither analysis on every slither file in the given directory or its subdirectories."
  echo "The bash script *launchSlitherAnalysis.sh* must be in a subdirectory of current directory."
  echo
  echo "Syntax: launchSlitherOverDir [-h] directory"
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

slitherAnalysis=$(find . -name "launchSlitherAnalysis.sh")

files=$(find "$dir" -name '*slither.csv')

for file in $files; do
  bash "$slitherAnalysis" -o "${file%.csv}res.txt" "$file"
done
