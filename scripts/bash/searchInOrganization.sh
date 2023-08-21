#!/bin/bash

############################################################
# Help                                                     #
############################################################

Help() {
  # Display Help
  echo "Search a list of git repositories."
  echo
  echo "Syntax: searchRepo [-h|o|q] organization"
  echo "options:"
  echo "h     Print this Help."
  echo "o     Output file."
  echo "s     Specify the string to be searched."
}

############################################################
# Process the input options.                               #
############################################################

while getopts "hs:o:" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  o) # output file
    outputFile=$OPTARG
    ;;
  s) # string to be searched
    stringToSearch=$OPTARG
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

if [ -z "$stringToSearch" ]; then
        echo 'Missing string to be searched argument' >&2
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
tmpRepoFile="tmpRepoFile.tmp"

perPage=100
i=1

fileRegex="*.[tj]s"
fileRegexExclude=":!node_modules/**"
fileRegexExclude2=":(attr:!vendored)*.js"

echo "All results for finding $stringToSearch inside the repositories of organization $1" | tee "$outputFile"

tmpRepoFound="Start"

rm "$tmpRepoFile"

while [ -n "$tmpRepoFound" ]; do
  tmpRepoFound=$(curl -sL "https://api.github.com/orgs/$1/repos?type=public&per_page=$perPage&page=$i" | jq -r ".[].html_url" 2>/dev/null)
  echo "$tmpRepoFound" | tr " " "\n" >>"$tmpRepoFile"
  ((i++))
done

	
nbLines=$(wc -l <"$tmpRepoFile")
counter=1

while read -r repolink; do
  repoTemp=$(echo "$repolink" | cut -d '/' -f 4-5)
  repo=$(echo "$repoTemp" | cut -d '.' -f 1)

  echo "======================================="
  echo "Searching in $repo ~ ($counter/$nbLines)"

  echo "======================================= $repo =======================================" >>"$outputFile"

  git clone -q "https://:@github.com/$repo" "$workdir/tmpGitRepo"
  cd "$workdir/tmpGitRepo" || continue

  git grep -I -n -i -o -E -w "$stringToSearch" -- "$fileRegex" "$fileRegexExclude" "$fileRegexExclude2" >>"../$outputFile"

  cd "$workdir" || exit 1
  rm -rf "$workdir/tmpGitRepo"
  ((counter++))

done <"$tmpRepoFile"

rm "$tmpRepoFile"
