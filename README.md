# SearchInGithubRepo

## *Bash scripts*
### FindInGithubSearch
___

Searches for a string inside every git repositories from a search in GitHub.
It first gets the repositories that corresponds to the given query.
Then, it finds, inside the JS and TS files of every repository, every occurrence of **signTypedData**, **eth_sign** and **personal_sign**.

### FinderGithub
___
Searches for a string inside every git repository from a list of repositories.
It downloads the repository and then, search within the files for specific strings.

#### GetAllRepoFromOrganization
___
Searches a list of git repositories for a specific organization.

### GetName
___
Writes into a file the name of repositories from github links.

### MergeFile
___
Writes into a file the elements of file1 that are not in file2.

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