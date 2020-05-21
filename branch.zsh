function log_test() {
  COUNT=$((`ls ~/src/mozilla/logs | wc -l |  tr -s " " | sed 's/^[ ]//g'` + 1))
  # COUNT="2"
  FILE="/Users/jlaster/src/mozilla/logs/out-$COUNT.log"
  touch $FILE
  tee $FILE
}


function patch() {
  FILE=~/src/moz/patches/$1.patch
  git hgp > $FILE
  less $FILE
}

alias bw="branch-work"
function branch-work() {
  DIR=~/src/mozilla/worktrees/$1

  cd ~/src/mozilla/gecko-dev
  # create worktree directory if it doesn't exist
  if [ ! -d $DIR ]; then
    git worktree add -b $1 $DIR origin/fx-team
  fi

  cd ~/src/mozilla/worktrees/$1
}

alias bwrm="branch-work-rm"
function branch-work-rm() {
  DIR=~/src/mozilla/worktrees/$1

  # remove worktree directory if it exists
  if [ -d $DIR ]; then
    git bd $1;
    rm $DIR;
  fi
}

function git-histogram() {
  git ls-files | xargs -n1 git blame --line-porcelain | sed -n 's/^author //p' | sort -f | uniq -ic | sort -nr
}

function branch-push() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
    git push me $BC $1 --no-verify;
  fi
}

function branch-push-force() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
    git push me $BC --force --no-verify;
  fi
}

function branch-update() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
      git co master;
      git rpull;
      git co $BC;
      branch-reset master;
  fi
}

function branch-merge() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
      git co master;
      git rpull;
      git co $BC;
      git r master;
      git co master;
      git r $BC;
      git r origin/master --ignore-date;
  fi
}

function branch-track() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
      git push -u origin $BC;
  fi
  #echo "https://github.etsycorp.com/Engineering/Etsyweb/compare/$BC";
}

function branch-deploy() {
  BC=$(git bc);
  if [ $BC == "master" ]; then
    git rpull;
    git push origin master;
  fi
}

function m() {
  git checkout master;
}

function branch-destroy() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
      git checkout "master";
      git branch -D $BC;
  fi
}

function branch-destroy-remote() {
  git_clean_review --checkallremotes;
}

function branch-sleep() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
    git checkout -b "zz-$BC";
    git branch -d $BC;
  fi
}

function branch-new() {
  git co "master"
  if [ $1 != "" ]; then
    git cob $1;
  fi
}

function branch-clone() {
  if [ $1 != "" ]; then
    g cob jlaster-$1;
  fi
}

function branch-rename() {
  BC=$(git bc);
  if [ $1 != "" ]; then
    g cob jlaster-$1;
    g bd $BC;
  fi
}

function branch-reset() {
  SHA=$(git rev-parse HEAD);
  if [ $1 != "" ]; then
    git reset --hard $1;
    git cp $SHA;
  fi
}

function branch-awake() {
}

function remote-add() {
  git remote add $1 https://github.com/$1/debugger.html.git
}

function search() {
  g g -e "$1";
}

function clean-log() {
  grep -v 'Unknown property' | grep -v 'Expected end of value' | grep -v 'parsing value for' | grep -v 'Expected declaration' | grep -v 'Unknown pseudo-class'
}


function mochi() {
  cd ~/src/moz/gecko-dev;
  ../mochii/bin/mochii.js "$1";
  cd -;
}

function mochi-headless() {
  cd ~/src/moz/gecko-dev;
  ../mochii/bin/mochii.js  --headless "$1";
  cd -;
}

function mochi-ci() {
  cd ~/src/moz/gecko-dev;
  ../mochii/bin/mochii.js --ci --headless "$1";
  cd -;
}

function mochi-debugger() {
  cd ~/src/moz/gecko-dev;
  ../mochii/bin/mochii.js  --jsdebugger "$1";
  cd -;
}

function moz-patch() {
  cd ~/src/moz/gecko-dev;
  moz-phab patch "$1";
  cd -;
}

function mach-try() {
  cd ~/src/moz/gecko-dev;
  ./mach try --preset debugger-tests
  cd -;
}

function mach-lint() {
  cd ~/src/moz/gecko-dev;
  ./mach lint --fix "$1";
  cd -;
}

function mach-lint-head() {
  cd ~/src/moz/gecko-dev;
  FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | tr '\n' '\ ');
  echo $FILES:
  ./mach lint --fix $FILES;
  cd -;
}

alias mm="mochi"
alias mmh="mochi-headless"
alias mmd="mochi-debugger"
alias mmc="mochi-ci"
alias mt="mach-try"
alias mp="moz-patch"
alias ml="mach-lint"
alias mlh="mach-lint-head"


alias bp="branch-push"
alias bpf="branch-push-force"

alias bc="branch-clone"
alias bn="branch-new"
alias bu="branch-update"
alias bm="branch-merge"
alias bt="branch-track"
alias bd="branch-destroy"
alias br="branch-reset"
