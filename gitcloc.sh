#!/usr/bin/env bash
usage() {
    echo "
usage: gitcloc branch [--help]

Clear/delete local branches that have been merged into the branch provided as first arguement.
The branch must be provided as the first arguement even when calling with optional arguements.
optional arguements:
    --help                   Shows this help message.
"
}

set -e
if [ -z "$1" ] || [ "$#" -gt 1 ] || [[ "$@" == *"--help"* ]]; then
    usage
else
    # Create a file to contain list of all merged branches.
    TMP_BRANCHES_FILE=$(mktemp)
    trap "{ rm -f $TMP_BRANCHES_FILE; }" EXIT

    # Redirect merged branches to tmp file and interactively edit file
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" != "$1" ]; then
        git checkout $1
    fi

    git branch --merged > $TMP_BRANCHES_FILE
    # Trim trailing and leading space, and empty lines, etc, before edit.
    sed -i 's/^ *//; s/ *$//; /^$/d; /^[*]/d' $TMP_BRANCHES_FILE

    LINE_COUNT=$(wc -l "$TMP_BRANCHES_FILE" | sed 's/ .*//')
    if [[ $LINE_COUNT -gt 0 ]]; then
        $(git var GIT_EDITOR) $TMP_BRANCHES_FILE
        # Trim trailing and leading space, and empty lines, etc, after edit.
        sed -i 's/^ *//; s/ *$//; /^$/d' $TMP_BRANCHES_FILE
        # Soft delete all branches left in the file and then remove tmp file.
        set +e
        xargs git branch -d < $TMP_BRANCHES_FILE
    else
        echo "No branches found for clearing."
    fi

    set -e
    if [ "$CURRENT_BRANCH" != "$1" ]; then
        git checkout $CURRENT_BRANCH 2> /dev/null
    fi
fi
