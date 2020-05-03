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
  git checkout `git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`
}

# 指定したgitのタグをcheckoutする
function gitt {
  git checkout  `git tag | peco`
}

# 指定したgitのリポジトリをpullして現在のリポジトリへ戻る
# git pull and back
function gitpb {
   CURB=`git rev-parse --abbrev-ref HEAD`
   gitb
   wait
   git pull
   wait
   git checkout $CURB
}

# 指定したgitのリポジトリを現在のリポジトリへマージ
function gitm {
   git merge `git branch | peco | sed -e "s/\* //g" | awk "{print \$1}"`
}

function gitc {
  git branch $1
  git checkout $1
}

function gitch {
  git fetch
  REMOTE=`git branch -r | peco | sed -e "s/\* //g" | awk "{print \$1}"`
  CHECKOUT=`echo $REMOTE | sed -e "s/origin\///g"`
  git checkout -b $CHECKOUT $REMOTE
}


function gitss {
  git stash save
}

function gitsa {
  STASH=`git stash list | peco | sed -e "s/\:.*//"`
  git stash apply $STASH
}

function gitsr {
  STASH=`git stash list | peco | sed -e "s/\:.*//"`
  git stash drop $STASH
}

CONFIG_FILE="${HOME}/.commands/gg_config"

function gcd {
  REPO_PATH=`cat ${CONFIG_FILE} | peco`
  cd $REPO_PATH
}

function gg {
    if [ "$1" == "-l" ]; then
      REPO_PATH=`cat ${CONFIG_FILE} | peco`
      sed -e 's|'$REPO_PATH'||g' $CONFIG_FILE
    else 
      if [ -e "./.git" ]; then
        STR=`echo $(pwd)`
        if [ ! `cat ${CONFIG_FILE} | grep ${STR}` ]; then
         echo $(pwd) >> $CONFIG_FILE
        else 
         echo "already registered!"
        fi 
      else 
        echo "not git repository"
      fi
    fi
}