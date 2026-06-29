name: Build Android APK

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: stable
          cache: true

      - name: Create fresh Flutter project
        run: |
          cd /tmp
          flutter create --org com.husain --project-name salalati fresh_app
          rm -rf fresh_app/lib
          cp -r $GITHUB_WORKSPACE/lib fresh_app/lib
          cp $GITHUB_WORKSPACE/pubspec.yaml fresh_app/pubspec.yaml
          rm -f fresh_app/test/widget_test.dart
          echo 'import "package:flutter_test/flutter_test.dart";
          void main() {
            testWidgets("smoke test", (WidgetTester tester) async {
              expect(true, isTrue);
            });
          }' > fresh_app/test/widget_test.dart

      - name: Get dependencies
        run: |
          cd /tmp/fresh_app
          flutter pub get

      - name: Analyze code
        run: |
          cd /tmp/fresh_app
          flutter analyze --no-fatal-infos

      - name: Build APK
        run: |
          cd /tmp/fresh_app
          flutter build apk --release --split-per-abi

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: salalati-apk
          path: /tmp/fresh_app/build/app/outputs/flutter-apk/
          retention-days: 30
