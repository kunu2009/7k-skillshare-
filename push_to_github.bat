@echo off
echo ========================================
echo Committing and Pushing to GitHub
echo ========================================
echo.

echo Adding files...
git add .

echo Committing...
git commit -m "Fix: Remove invalid home parameter from MaterialApp.router - App now builds successfully"

echo Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo SUCCESS! Code pushed to GitHub
echo ========================================
echo.
echo Your APK is ready at:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Install on your phone now!
echo.

pause
