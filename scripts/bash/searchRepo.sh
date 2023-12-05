#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search a list of git repositories corresponding to a query."
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

shift "$((OPTIND - 1))"

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

githubTokenHeader="Authorization: Bearer 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"

echo "All results for Github repositories $1" | tee "$outputFile"

apiCalls=0

starsHigh=100000000
starsLow=1000

while [[ $starsHigh -ge 0 ]]; do

  numberOfResults=$(curl -sL --header "$githubTokenHeader" "https://api.github.com/search/repositories?q=dapp+stars:$starsLow..$starsHigh" | jq -r ".total_count")

  ((apiCalls++))

  if [[ $apiCalls -gt 29 ]]; then
    echo "Api rate limit about to be exceeded, sleep for 1min"
    sleep 60
    apiCalls=0
  fi

  while [[ $numberOfResults -gt 1000 ]]; do
    if [[ $starsLow -eq $((starsLow / 2 + starsHigh / 2)) ]]; then
        starsLow=$((starsHigh - 1))
        break
    fi
    starsLow=$((starsLow / 2 + starsHigh / 2))

    numberOfResults=$(curl -sL --header "$githubTokenHeader" "https://api.github.com/search/repositories?q=dapp+stars:$starsLow..$starsHigh" | jq -r ".total_count")
    ((apiCalls++))
    if [[ $apiCalls -gt 29 ]]; then
      echo "Api rate limit about to be exceeded, sleep for 1min"
      sleep 60
      apiCalls=0
    fi
  done

  perPage=100
  i=0

  errorMessage=$(curl -sL --header "$githubTokenHeader" "https://api.github.com/search/repositories?q=${1// /+}+language:$language+stars:$starsLow..$starsHigh&per_page=1&page=$i" | jq -r ".message" 2>/dev/null)
  ((apiCalls++))
  if [[ $apiCalls -gt 29 ]]; then
    echo "Api rate limit about to be exceeded, sleep for 1min"
    sleep 60
    apiCalls=0
  fi

  if [ "$errorMessage" != "null" ]; then
    echo "An error as occurred when trying to found $numberOfResults results for stars between $starsLow and $starsHigh: $errorMessage"
    curl -sL --header "$githubTokenHeader" "https://api.github.com/rate_limit" | jq -r ".resources.search"
    exit 1
  fi

  ((apiCalls++))
  if [[ $apiCalls -gt 29 ]]; then
    echo "Api rate limit about to be exceeded, sleep for 1min"
    sleep 60
    apiCalls=0
  fi

  while curl -sL --header "$githubTokenHeader" "https://api.github.com/search/repositories?q=${1// /+}+language:$language+stars:$starsLow..$starsHigh&per_page=$perPage&page=$i" | jq -r ".items[].html_url" >>"$outputFile" 2>/dev/null; do
    ((i++))
    ((apiCalls++))
    if [[ $apiCalls -gt 29 ]]; then
      echo "Api rate limit about to be exceeded, sleep for 1min"
      sleep 60
      apiCalls=0
    fi
  done

  echo "Just wrote $numberOfResults results for stars between $starsLow and $starsHigh"

  starsHigh=$((starsLow - 1))
  starsLow=$((starsLow / 10))

done
