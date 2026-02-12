function branch-push() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
    git push me $BC $1 --no-verify;
  fi
}

function branch-push-force() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
    git push me $BC --force --no-verify;
  fi
}

function branch-update() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
      git fetch origin main;
      branch-reset origin/main;
  fi
}

function branch-rebase() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
      git fetch origin main;
      git rebase origin/main;
  fi
}

function branch-merge() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
      git co main;
      git rpull;
      git co $BC;
      git r main;
      git co main;
      git r $BC;
      git r origin/main --ignore-date;
  fi
}

function branch-track() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
      git push -u origin $BC;
  fi
  #echo "https://github.etsycorp.com/Engineering/Etsyweb/compare/$BC";
}

function branch-deploy() {
  BC=$(git bc);
  if [ $BC == "main" ]; then
    git rpull;
    git push origin main;
  fi
}

function m() {
  git checkout main;
}

function branch-destroy() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
      git checkout "main";
      git branch -D $BC;
  fi
}

function branch-destroy-remote() {
  git_clean_review --checkallremotes;
}

function branch-sleep() {
  BC=$(git bc);
  if [ $BC != "main" ]; then
    git checkout -b "zz-$BC";
    git branch -d $BC;
  fi
}

function branch-new() {
  git co "main"
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



alias bp="branch-push"
alias bpf="branch-push-force"

alias bc="branch-clone"
alias bn="branch-new"
alias bu="branch-update"
alias br="branch-rebase"
alias bm="branch-merge"
alias bt="branch-track"
alias bd="branch-destroy"
