#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Create a slither file from the repository list and the finderGithub results."
  echo
  echo "Syntax: createSlitherFile [-h|o] repoFile resultFile"
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

if [ -z "$1" ]; then
  echo 'Missing repoFile argument' >&2
  Help
  exit 1
fi

if [ -z "$1" ]; then
  echo 'Missing resultFile argument' >&2
  Help
  exit 1
fi

if [ -z "$outputFile" ]; then
  echo 'Missing -o option' >&2
  Help
  exit 1
fi

############################################################
# Main program                                             #
############################################################

true > "$outputFile"

while read -r link <&3 && read -r item <&4; do
  itemParsed=$(echo "$item" | cut -d ',' -f 10)
  if [ -n "$itemParsed" ]; then
    echo "${link//[$'\r\n']},$itemParsed">>"$outputFile"
  fi
done 3<"$1" 4<"$2"