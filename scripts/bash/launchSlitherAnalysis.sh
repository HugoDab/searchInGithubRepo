#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Launch the slither backdoor for every repo in list."
  echo
  echo "Syntax: launchSlitherAnalysis [-h|o] repoFile"
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

if [ -z "$outputFile" ]; then
  echo 'Missing -o option' >&2
  Help
  exit 1
fi

############################################################
# Main program                                             #
############################################################

workdir=$(pwd)

nbLines=$(wc -l <"$1")
counter=1

while read -r repolink; do

  repoTemp=$(echo "$repolink" | cut -d '/' -f 4-5)
  repo=$(echo "$repoTemp" | cut -d '.' -f 1)

  echo "======================================="
  echo "Searching in $repo ~ ($counter/$nbLines)"

  echo "======================================= $repo =======================================" >>"$outputFile"

  git clone -q "https://:@github.com/$repo" "$workdir/tmpGitRepo"
  cd "$workdir/tmpGitRepo" || continue

  solVersionLine=$(grep -m 1 "solidity" <"$(find . -name \*.sol | head -n 1)")
  solVersion=${solVersionLine##*^}
  solc-select install "$solVersion"
  solc-select use "$solVersion"
  slither . --detect backdoor

done <"$1"
