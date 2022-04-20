# Clear merged in local branches
The shell script `gitcloc` is for clearing/deleting all local branches that have been merged into another given branch.

# Setup

First you will have to download the script and give execution permissions to the file.

```bash
$ curl https://raw.githubusercontent.com/rudikershaw/git-clear-local/master/gitcloc.sh > gitcloc.sh
$ chmod u+x gitcloc.sh
```

You can now execute the script by using its full path. Alternatively you may want to set up an alias by adding `alias gitcloc /path/to/your/gitcloc.sh` to the end of your `.bashrc` (Linux) or `.bash_profile` (Mac) files.

# Usage

Below is the output of `gitcloc --help`

```
usage: gitcloc branch [--help]

Clear/delete local branches that have been merged into the branch provided as first argument.
The branch must be provided as the first argument even when calling with optional arguments.
optional arguments:
    --help                   Shows this help message
```

To use `gitcloc` simply navigate to the git repository which you want to delete local merged branches. Lets say we want to remove all local branches that have been merged into a branch called `main`. You might write the following:

```bash
$ cd /home/rudi/path/to/your/repository
$ gitcloc main
```

You will then be presented with the git command line editor of your choice, showing a new-line delimited list of the branches that will be removed. Remove or add any branches as appropriate. Then save your changes and exit the editor. The script will then use a soft delete on each branch (branches that have not been merged into a remote branch that they are tracking will fail and an error will be presented for each failing branch) and confirm all deleted branches.
