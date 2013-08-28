function branch-push() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
    git push origin $BC $1;
  fi
}

function branch-push-force() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
    git push origin $BC --force;
  fi
  echo "https://github.etsycorp.com/Engineering/Etsyweb/compare/$BC";
}

function branch-update() {
  BC=$(git bc);
  if [ $BC != "master" ]; then
      git co master;
      git rpull;
      git co $BC;
      git rebase master;
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
  echo "https://github.etsycorp.com/Engineering/Etsyweb/compare/$BC";
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
  g co "master"
  if [ $1 != "" ]; then
    g cob jlaster-$1;
  fi
}

function branch-clone() {
  if [ $1 != "" ]; then
    g cob jlaster-$1;
  fi
}

function branch-awake() {
}

function search() {
  g g -e "$1";
}
