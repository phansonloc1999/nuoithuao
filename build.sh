zip -r game.love *
cp game.love ~/Documents/love-android/app/src/embed/assets
cd ~/Documents/love-android/
./gradlew assembleEmbedNoRecordDebug
adb install app/build/outputs/apk/embedNoRecord/debug/app-embed-noRecord-debug.apk