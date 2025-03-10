Compress-Archive -Path . -DestinationPath game.zip
rename game.zip game.love
cp game.love ~/Documents/love-android/app/src/embed/assets
cd D:/love-android
CALL gradlew assembleEmbedNoRecordDebug
adb install app/build/outputs/apk/embedNoRecord/debug/app-embed-noRecord-debug.apk