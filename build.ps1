$compress = @{
  Path = "assets", "libs", "src", "conf.lua", "main.lua"
  CompressionLevel = "Fastest"
  DestinationPath = "game.zip"
}
Compress-Archive @compress
mv game.zip game.love
mv game.love D:/love-android/app/src/embed/assets/
cd D:/love-android
./gradlew.bat assembleEmbedNoRecordDebug
adb install app/build/outputs/apk/embedNoRecord/debug/app-embed-noRecord-debug.apk