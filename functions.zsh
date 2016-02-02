function edit_modified() {
    vim -p `git status --porcelain | awk '{print $2}'`
}
 
function edit_conflicts() {
    vim -p `git diff --name-only --diff-filter=U`
}
 
function edit_commit {
    if [ -z "$1" ]; then
        vim -p `git diff-tree --no-commit-id --name-only -r HEAD | paste -s -d ' '`
    else
        vim -p `git diff-tree --no-commit-id --name-only -r $1 | paste -s -d ' '`
    fi
}
