# SearchInGithubRepo

## *Bash scripts*
### CreateSlitherFile
___
Creates a slither file from the repository list and the finderGithub results.

### FindInGithubSearch
___
Searches for a string inside every git repository from a search in GitHub.
It first gets repositories that correspond to the given query.
Then, it finds, inside the JS and TS files of every repository, every occurrence of **signTypedData**, **eth_sign** and **personal_sign**.

### FinderGithub
___
Searches for a string inside every git repository from a list of repositories.
It downloads the repository and then searches within the files for specific strings.

#### GetAllRepoFromOrganization
___
Searches a list of git repositories for a specific organization.

### GetName
___
Writes into a file the name of repositories from GitHub links.

### LaunchSlitherAnalysis
___
Launch the slither backdoor for every repo in the given list.
The list must be a *slither file*,
which is a CSV file containing the list of the repositories and their corresponding paths to ecrecover files

### LaunchSlitherOverDir
___
Launch the slither analysis on every slither file in the given directory or its subdirectories.
The bash script *launchSlitherAnalysis.sh* must be in a subdirectory of current directory.

### MergeFile
___
Writes into a file the elements of file1 that are not in file2.

### ResultsToCSVFromDir
___
Transforms every result from finderGithub from a directory into CSV file.                                             
It will search for file finishing with results.txt | res.txt | result.txt.                   
The python script *finder_github_results_to_csv* must be in a subdirectory of current directory.

### SearchInOrganization
___
Searches for a string inside all git repositories from an organization.
It first searches a list of git repositories for a specific organization.
And then, looks for a string inside every git repository from a list of repositories.

### Search Repo
___
Searches a list of git repositories corresponding to a query.

## *Python*
### add_name_link_to_search_result
___
Adds the name and the link of GitHub repositories to the output of finderGithub in CSV format.

### finder_github_results_to_csv
___
Converts the output of finderGithub to a CSV file.

### get_sign_typed_data_matched_file
___
Take the CSV result file from finderGithub and find the GitHub repositories that contains an ecrecover function inside their files.