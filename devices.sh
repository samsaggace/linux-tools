#!/bin/sh
/usr/local/tools/android-sdk-linux-r21.1-ng1/platform-tools/adb devices | sed '1d' | cut -f1 | sed 's#\n# #g'
