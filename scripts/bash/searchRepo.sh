#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search a list of git repositories."
  echo
  echo "Syntax: searchRepo [-h|l|o] query"
  echo "options:"
  echo "h     Print this Help."
  echo "l     Specify a language."
  echo "o     Output file."
}

############################################################
# Process the input options.                               #
############################################################

while getopts "hl:o:" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  l) # language
    language=$OPTARG
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

shift "$(( OPTIND - 1 ))"

if [ -z "$1" ]; then
        echo 'Missing query argument' >&2
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

echo "All results for Github repositories $1" | tee "$outputFile"

perPage=100

i=10

while curl -sL "https://api.github.com/search/repositories?q=${1// /+}+language:$language&per_page=$perPage&page=$i" | jq -r ".items[].html_url" >>"$outputFile" 2>/dev/null; do
  ((i++))
  echo "Just wrote first $((i * 100)) results"
done
