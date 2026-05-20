# TODO - worker-app Flutter Web enablement

## Step 1
Inspect `apps/worker-app/pubspec.yaml` and verify declared asset/font paths.

## Step 2
Quick-fix: remove/adjust missing asset + font entries in `apps/worker-app/pubspec.yaml` so Flutter web compile can proceed.

## Step 3
Run `flutter pub get` inside `apps/worker-app`.

## Step 4
Run `flutter run -d web-server` and verify compilation errors.

## Step 5
If remaining web build errors persist (e.g., firebase_messaging_web / image_cropper_for_web), align dependency versions and/or apply platform guards.

