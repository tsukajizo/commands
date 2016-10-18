function adbs {
  fname=$1
  if [ -z $fname ];then
    tstamp=`date "+%Y%m%d%H%M%S"`
    fname=screenshot_$tstamp
  fi
  adb shell screencap -p /sdcard/$fname.png
  adb pull /sdcard/$fname.png
  adb shell rm /sdcard/$fname.png
}

function adbv {
  fname=$1
  if [ -z $fname ];then
    tstamp=`date "+%Y%m%d%H%M%S"`
    fname=screenshot_$tstamp
  fi
  ftime=$2
  if [ -z $ftime ];then
    ftime=60
  fi
  adb shell screenrecord --bit-rate 10000000 --time-limit $ftime /sdcard/$fname.mp4
  adb pull /sdcard/$fname.mp4
  adb shell rm /sdcard/$fname.mp4
}

function adbk {
  while true
  do
    read VALUE INPUT
      if [ $VALUE = "t" ];then
        for i in `seq 1 $INPUT`
        do
          adb shell input keyevent 61
        done
      elif [ $VALUE = "e" ];then
        adb shell input keyevent 66
      elif [ $VALUE = "h" ];then
        adb shell input keyevent 3
      elif [ $VALUE = "b" ];then
        adb shell input keyevent 4
      elif [ $VALUE = "m" ];then
        adb shell input keyevent 82
      elif [ $VALUE = "i" ];then
        adb shell input text $INPUT
      elif [ $VALUE = "d" ];then
        for i in `seq 1 $INPUT`
        do
          echo $i
          adb shell input keyevent 67
        done
      elif [ $VALUE = "l" ];then
        adb shell input keyevent 212
      elif [ $VALUE = "code" ];then
          adb shell input keyevent $INPUT
      fi
  done
}

function adbu {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  if [ -z $PACKAGE ];then
    exit 1
  fi
  adb uninstall $PACKAGE
}

function adbi {
  APK=`find . -name "*.apk" -type f | peco`
  if [ -z $APK ];then
    return
  fi
  adb uninstall $APK
  wait
  PACKAGE=`aapt l -a $APK | grep "A: package"`
  adb install $APK
}

function apkv {
  APK=`find . -name "*.apk" -type f | peco`
  if [ -z $APK ];then
    exit 1
  fi
  echo "apk name: $APK"
  aapt dump badging  $APK | grep Version
}

function adbkill {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  if [ -z $PACKAGE ];then
    exit 1
  fi
  echo "kill process:"$PACKAGE
  adb shell am kill $PACKAGE
}

function adbcl {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  if [ -z $PACKAGE ];then
    exit 1
  fi
  echo "Clear Data:"$PACKAGE
  adb shell pm clear $PACKAGE
}
