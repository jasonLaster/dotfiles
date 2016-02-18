function edit-modified() {
    vim -p `git status --porcelain | awk '{print $2}'`
}

function edit-conflicts() {
    vim -p `git diff --name-only --diff-filter=U`
}

function edit-commit {
    if [ -z "$1" ]; then
        vim -p `git diff-tree --no-commit-id --name-only -r HEAD | paste -s -d ' '`
    else
        vim -p `git diff-tree --no-commit-id --name-only -r $1 | paste -s -d ' '`
    fi
}

function jshiglight() {
  highlight -O rtf -S js -s molokai -j 3 -K 24 -n $1 | pbcopy
}

function f() {
  find . -iname "*$1*" ${@:2}
}

function r() {
  grep "$1" ${@:2} -R .
}

#mkdir and cd
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


function daily {
  local current_date=`date +"%b-%d"`

  if [[ ! -a ~/src/_daily/$current_date ]]; then
    mkdir ~/src/_daily/$current_date;
  fi

  cd ~/src/_daily/$current_date
}
