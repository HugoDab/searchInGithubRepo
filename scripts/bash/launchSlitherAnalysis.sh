#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Launch the slither backdoor for every repo in the given list."
  echo
  echo "Syntax: launchSlitherAnalysis [-h|o] slitherAnalysisFile"
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

workdir=$(pwd)

############################################################
# Installation of slither tool (before first use)          #
############################################################

# git clone https://github.com/sajadmeisami/slither
# cd slither || exit 1
# make dev
# source ./env/bin/activate

############################################################
# Main program                                             #
############################################################

nbLines=$(wc -l <"$1")
counter=1

true > "$workdir/$outputFile"

while read -r repolink; do

  repoLinkTemp=$(echo "$repolink" | cut -d ',' -f 1)
  repoTemp=$(echo "$repoLinkTemp" | cut -d '/' -f 4-5)
  repo=$(echo "$repoTemp" | cut -d '.' -f 1)

  pathToFileTemp=$(echo "$repolink" | cut -d ',' -f 2)
  pathToFile=$(echo "$pathToFileTemp" | cut -d ':' -f 1)

  echo "======================================="
  echo "Searching in $repo ~ ($counter/$nbLines)"

  echo "======================================= $repo || $pathToFile =======================================" >>"$workdir/$outputFile"

  git clone -q "https://:@github.com/$repo" "$workdir/tmpGitRepo$nbLines$counter"
  cd "$workdir/tmpGitRepo$nbLines$counter" || continue

  #solFile=$(find . -name \*.sol | head -n 1)
  if [ -n "$pathToFile" ]; then
    #cd "${pathToFile%/*}" || continue
    solVersionLine=$(grep -m 1 "solidity" <"$pathToFile")
    solVersion=${solVersionLine##* }
    solVersionTemp=${solVersion##*^}
    solVersionTemp2=${solVersionTemp##*=}
    solVersionFinal=${solVersionTemp2%;*}
    solc-select install "$solVersionFinal" >/dev/null
    solc-select use "$solVersionFinal"
    #slither "${pathToFile##*/}" --detect backdoor --json "temp$nbLines$counter.json" --solc-disable-warnings
    slither "$pathToFile" --detect backdoor --json "temp$nbLines$counter.json" --solc-disable-warnings
    jq -r ".results.detectors[].description" "temp$nbLines$counter.json">> "$workdir/$outputFile"
  fi

  cd "$workdir" || exit 1
  rm -rf "$workdir/tmpGitRepo$nbLines$counter"
  ((counter++))

done <"$1"
