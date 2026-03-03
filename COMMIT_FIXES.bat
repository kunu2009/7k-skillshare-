@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - COMMIT FIXES TO GITHUB
echo ============================================================
echo.

echo Committing fixes:
echo - ThemeProvider duplicate constructor
echo - User model 'id' reference changed to 'uid'
echo - Build scripts for APK
echo.

git add .
git commit -m "Fix: Build errors - ThemeProvider constructor and User.id reference. APK ready for deployment."
git push -u origin main

echo.
echo ============================================================
echo ✓ FIXES COMMITTED & PUSHED
echo ============================================================
echo.
echo Repository: https://github.com/kunu2009/7k-skillshare-
echo.
echo Next: Run .\FINAL_BUILD.bat to build APK
echo.

pause
