#!/bin/bash


############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search a list of git repositories."
  echo
  echo "Syntax: searchRepo [-h|o] organization"
  echo "options:"
  echo "h     Print this Help."
  echo "o     Output file."
}

############################################################
# Process the input options.                               #
############################################################

while getopts "ho:" option; do
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

shift "$(( OPTIND - 1 ))"

if [ -z "$1" ]; then
        echo 'Missing organization argument' >&2
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

echo "All repositories of organization $1" | tee "$outputFile"

tmpRepoFound="Start"
perPage=100
i=1

while [ -n "$tmpRepoFound" ]; do
  tmpRepoFound=$(curl -sL "https://api.github.com/orgs/$1/repos?type=public&per_page=$perPage&page=$i" | jq -r ".[].html_url" 2>/dev/null)
  echo "$tmpRepoFound" | tr " " "\n" >>"$outputFile"
  ((i++))
done
