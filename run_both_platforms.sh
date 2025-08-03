#!/bin/bash

echo "🚀 Starting Flutter app on both Android and iOS..."

# Check if devices are available
echo "📱 Checking available devices..."
flutter devices

# Start Android emulator if not running
echo "🤖 Starting Android emulator..."
flutter emulators --launch Medium_Phone_API_35

# Wait for emulator to start
echo "⏳ Waiting for Android emulator to start..."
sleep 15

# Check devices again
echo "📱 Checking devices after emulator start..."
flutter devices

# Function to run on Android
run_android() {
    echo "🤖 Running on Android..."
    flutter run -d emulator-5554
}

# Function to run on iOS
run_ios() {
    echo "🍎 Running on iOS..."
    flutter run -d B4B26300-51BA-4EE2-8F7A-E47BF0FCC0EE
}

# Run both platforms in background
echo "🚀 Starting both platforms..."
run_android &
ANDROID_PID=$!

run_ios &
IOS_PID=$!

echo "✅ Both platforms started!"
echo "Android PID: $ANDROID_PID"
echo "iOS PID: $IOS_PID"
echo ""
echo "Press Ctrl+C to stop both platforms"
echo ""

# Wait for user to stop
wait 