## スクリーンショットを作成
function adbs {
  fname=$1
  if [ -n $fname ];then
    tstamp=`date "+%Y%m%d%H%M%S"`
    fname=screenshot_$tstamp
  fi
  adb shell screencap -p /sdcard/$fname.png
  adb pull /sdcard/$fname.png
  adb shell rm /sdcard/$fname.png
}

## スクリーンショット（ビデオ）を作成
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

## ターミナルからキーボード入力
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

## デバイス内のパッケージを選択してアンインストール
function adbu {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  adb uninstall $PACKAGE
}

## カレントディレクトリ以下のapkを選択してインストール
function adbi {
  APK=`find . -name "*.apk" -type f | peco`
  PACKAGE=`aapt l -a $APK | grep "A: package"`
  adb install -r $APK
}

## カレントディレクトリ以下のapkを選択して情報を表示
function apkv {
  APK=`find . -name "*.apk" -type f | peco`
  echo "apk name: $APK"
  aapt dump badging  $APK | grep Version
}

## adbにプロキシを設定する。127以外のものを選択すると設定できる
function adbpx {
  IP=`ifconfig -a | grep inet[^6]  | sed 's/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/' | grep -v 127.* | peco`
  echo $IP
  adb shell setprop net.gprs.http-proxy $IP:8888
}

## デバイス内のパッケージを選択してアプリをkillする
function adbkill {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  echo "kill process:"$PACKAGE
  adb shell am kill $PACKAGE
}

## デバイス内のパッケージを選択してアプリのデータを削除する
function adbcl {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  echo "Clear Data:"$PACKAGE
  adb shell pm clear $PACKAGE
}

## デバイス内のパッケージを選択してアプリを起動
function adbstart {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  echo "start:"$PACKAGE
  adb shell am start $PACKAGE
}

## デバイス内のパッケージを選択してアプリを強制終了
function adbstop {
  PACKAGE=`adb shell pm list package | peco | sed -e "s/package://g"`
  echo "stop:"$PACKAGE
  adb shell am force-stop $PACKAGE
}

## Gradleのインストール用タスクを選択して実行
function apkb {
    GRADLEW=`find . -name "gradlew" -type f`
    TASKS=`$GRADLEW tasks | grep install | peco | sed -e 's/\-.*//'`
    $GRADLEW $TASKS
}

## GradleのAssemble用タスクを選択して実行
function apka {
  GRADLEW=`find . -name "gradlew" -type f`
  TASKS=`$GRADLEW tasks | grep assemble | peco | sed -e 's/\-.*//'`
  $GRADLEW $TASKS
}

## Setting内の画面を選択して実行
function adbsetting {
  SETTTING=`peco << EOS
ACCESSIBILITY_SETTINGS
ADD_ACCOUNT
AIRPLANE_MODE_SETTINGS
APN_SETTINGS
APPLICATION_DETAILS_SETTINGS
APPLICATION_DEVELOPMENT_SETTINGS
APPLICATION_SETTINGS
APP_NOTIFICATION_BUBBLE_SETTINGS
APP_NOTIFICATION_SETTINGS
APP_SEARCH_SETTINGS
APP_USAGE_SETTINGS
BATTERY_SAVER_SETTINGS
BLUETOOTH_SETTINGS
CAPTIONING_SETTINGS
CAST_SETTINGS
CHANNEL_NOTIFICATION_SETTINGS
DATA_ROAMING_SETTINGS
DATA_USAGE_SETTINGS
DATE_SETTINGS
DEVICE_INFO_SETTINGS
DISPLAY_SETTINGS
DREAM_SETTINGS
FINGERPRINT_ENROLL
HARD_KEYBOARD_SETTINGS
HOME_SETTINGS
IGNORE_BACKGROUND_DATA_RESTRICTIONS_SETTINGS
IGNORE_BATTERY_OPTIMIZATION_SETTINGS
INPUT_METHOD_SETTINGS
INPUT_METHOD_SUBTYPE_SETTINGS
INTERNAL_STORAGE_SETTINGS
LOCALE_SETTINGS
LOCATION_SOURCE_SETTINGS
MANAGE_ALL_APPLICATIONS_SETTINGS
MANAGE_APPLICATIONS_SETTINGS
MANAGE_DEFAULT_APPS_SETTINGS
MANAGE_OVERLAY_PERMISSION
MANAGE_UNKNOWN_APP_SOURCES
MANAGE_WRITE_SETTINGS
MEMORY_CARD_SETTINGS
NETWORK_OPERATOR_SETTINGS
NFCSHARING_SETTINGS
NFC_PAYMENT_SETTINGS
NFC_SETTINGS
NIGHT_DISPLAY_SETTINGS
NOTIFICATION_ASSISTANT_SETTINGS
NOTIFICATION_LISTENER_SETTINGS
NOTIFICATION_POLICY_ACCESS_SETTINGS
PRINT_SETTINGS
PRIVACY_SETTINGS
PROCESS_WIFI_EASY_CONNECT_URI
QUICK_LAUNCH_SETTINGS
REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
REQUEST_SET_AUTOFILL_SERVICE
SEARCH_SETTINGS
SECURITY_SETTINGS
SETTINGS
SHOW_REGULATORY_INFO
SOUND_SETTINGS
STORAGE_VOLUME_ACCESS_SETTINGS
SYNC_SETTINGS
USAGE_ACCESS_SETTINGS
USER_DICTIONARY_SETTINGS
VOICE_CONTROL_AIRPLANE_MODE
VOICE_CONTROL_BATTERY_SAVER_MODE
VOICE_CONTROL_DO_NOT_DISTURB_MODE
VOICE_INPUT_SETTINGS
VPN_SETTINGS
VR_LISTENER_SETTINGS
WEBVIEW_SETTINGS
WIFI_IP_SETTINGS
WIFI_SETTINGS
WIRELESS_SETTINGS
ZEN_MODE_PRIORITY_SETTINGS
AUTHORITY
EXTRA_ACCOUNT_TYPES
EXTRA_AIRPLANE_MODE_ENABLED
EXTRA_APP_PACKAGE
EXTRA_AUTHORITIES
EXTRA_BATTERY_SAVER_MODE_ENABLED
EXTRA_CHANNEL_ID
EXTRA_DO_NOT_DISTURB_MODE_ENABLED
EXTRA_DO_NOT_DISTURB_MODE_MINUTES
EXTRA_INPUT_METHOD_ID
EXTRA_SUB_ID
INTENT_CATEGORY_USAGE_ACCESS_CONFIG
METADATA_USAGE_ACCESS_REASON
EOS
`
echo "adb shell am start -a android.settings.$SETTTING"
adb shell am start -a android.settings.$SETTTING
}
