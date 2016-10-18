## peco
function pcd {
    cd "$( ls -1d */ | peco )"
}

function fcd {
  echo $1
  cd "$( find . -name $1 -type d | peco)"
}

# 指定したgitにブランチをスウィッチする
function gitb {
  BRANCH=`git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`
  if [ -z $BRANCH ];then
    exit 1
  fi
  echo `Checkout branch:`$BRANCH
  git checkout $BRANCH
}

# 指定したgitのタグをcheckoutする
function gitt {
  TAG=`git tag | peco`
  if [ -z $TAG ];then
    exit 1
  fi
  echo `Checkout tag:`$TAG
  git checkout $TAG
}

# 指定したgitのリポジトリをpullして現在のリポジトリへ戻る
# git pull and back
function gitpb {
   CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
   gitb
   wait
   git pull
   wait
   git checkout $CURRENT_BRANCH
}

# 指定したgitのリポジトリを現在のリポジトリへマージ
function gitm {
  BRANCH=`git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`
  if [ -z $BRANCH ];then
    exit 1
  fi
  echo 'Merge '$BRANCH' to current branch'
  git merge
}

function gitc {
  echo 'create new branch '$1
  if [ -z $1 ];then
    exit 1
  fi
  git branch $1
  git checkout $1
}

function gitch {
  git fetch
  REMOTE=`git branch -r | peco | sed -e "s/\* //g" | awk "{print \$1}"`
  if [ -z $REMOTE ];then
    exit 1
  fi
  CHECKOUT=`echo $REMOTE | sed -e "s/origin\///g"`
  echo 'Checkout remote branch '$CHECKOUT
  git checkou -zb $CHECKOUT $REMOTE
}
