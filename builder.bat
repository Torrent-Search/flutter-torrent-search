flutter clean -v &&flutter pub get -v &&flutter packages pub run build_runner clean &&flutter packages pub run build_runner build --delete-conflicting-outputs &&flutter build apk --debug --target-platform android-arm64 -v &&flutter build apk --profile --target-platform android-arm64 -v &&flutter build apk --split-per-abi -v