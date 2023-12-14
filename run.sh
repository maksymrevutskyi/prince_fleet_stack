cp ./fleetstack ../projects/temp
cd ../project/temp

#Launcher Icon
unzip appicon.zip
cp -av ./logo/android/res ./android/app/src/main/res

#Logo
cp logo.png ./assets/images/logo.png
cp logo.png ./assets/images/splash_logo.png
flutter pub run change_app_package_name:main com.apollo.example
#android manifest change
./android/app/src/main/AndroidManifest



#googleservice.json change
flutter build apk --debug
flutter build apk
flutter build appbundle